<?php

namespace App\Http\Controllers\Api;

use App\Helpers\Helper;
use App\Http\Controllers\Controller;
use App\Http\Transformers\FloorsTransformer;
use App\Http\Transformers\SelectlistTransformer;
use App\Models\Company;
use App\Models\Floor;
use App\Models\User;
use Illuminate\Http\Request;

class FloorsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v4.0]
     *
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $this->authorize('index', Floor::class);
        $floors = Company::scopeCompanyables(
            Floor::select('floors.*')
                ->with('company', 'category', 'users')
        );

        if ($request->filled('search')) {
            $floors = $floors->TextSearch(e($request->input('search')));
        }

        if ($request->filled('company_id')) {
            $floors->where('company_id','=',$request->input('company_id'));
        }

        if ($request->filled('category_id')) {
            $floors->where('category_id','=',$request->input('category_id'));
        }


        // Set the offset to the API call's offset, unless the offset is higher than the actual count of items in which
        // case we override with the actual count, so we should return 0 items.
        $offset = (($floors) && ($request->get('offset') > $floors->count())) ? $floors->count() : $request->get('offset', 0);

        // Check to make sure the limit is not higher than the max allowed
        ((config('app.max_results') >= $request->input('limit')) && ($request->filled('limit'))) ? $limit = $request->input('limit') : $limit = config('app.max_results');

        $allowed_columns = ['id','name','company','category','created_at', 'ext_system', 'ext_object','ext_identifier','description','elevation','height','image'];
        $order = $request->input('order') === 'asc' ? 'asc' : 'desc';
        $sort = in_array($request->input('sort'), $allowed_columns) ? $request->input('sort') : 'created_at';


        switch ($sort) {
            case 'category':
                $floors = $floors->OrderCategory($order);
                break;
            case 'company':
                $floors = $floors->OrderCompany($order);
                break;
            default:
                $floors = $floors->orderBy($sort, $order);
                break;
        }



        $total = $floors->count();
        $floors = $floors->skip($offset)->take($limit)->get();
        return (new FloorsTransformer)->transformFloors($floors, $total);

    }


    /**
     * Store a newly created resource in storage.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v4.0]
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $this->authorize('create', Floor::class);
        $floor = new Floor;
        $floor->fill($request->all());

        if ($floor->save()) {
            return response()->json(Helper::formatStandardApiResponse('success', $floor, trans('admin/floors/message.create.success')));
        }
        return response()->json(Helper::formatStandardApiResponse('error', null, $floor->getErrors()));
    }

    /**
     * Display the specified resource.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @param  int $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        $this->authorize('view', Floor::class);
        $floor = Floor::findOrFail($id);
        return (new FloorsTransformer)->transformFloor($floor);
    }


    /**
     * Update the specified resource in storage.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v4.0]
     * @param  \Illuminate\Http\Request $request
     * @param  int $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        $this->authorize('update', Floor::class);
        $floor = Floor::findOrFail($id);
        $floor->fill($request->all());

        if ($floor->save()) {
            return response()->json(Helper::formatStandardApiResponse('success', $floor, trans('admin/floors/message.update.success')));
        }

        return response()->json(Helper::formatStandardApiResponse('error', null, $floor->getErrors()));
    }

    /**
     * Remove the specified resource from storage.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v4.0]
     * @param  int $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        $this->authorize('delete', Floor::class);
        $floor = Floor::findOrFail($id);
        $this->authorize('delete', $floor);
        $floor->delete();
        return response()->json(Helper::formatStandardApiResponse('success', null,  trans('admin/floors/message.delete.success')));
    }

    /**
    * Returns a JSON response containing details on the users associated with this floor.
    *
    * @author [A. Gianotto] [<snipe@snipe.net>]
    * @see \App\Http\Controllers\Floors\FloorsController::getView() method that returns the form.
    * @since [v1.0]
    * @param int $floorId
    * @return array
     */
    public function getDataView($floorId)
    {
        $floor = Floor::with(array('floorAssignments'=>
        function ($query) {
            $query->orderBy($query->getModel()->getTable().'.created_at', 'DESC');
        },
        'floorAssignments.admin'=> function ($query) {
        },
        'floorAssignments.user'=> function ($query) {
        },
        ))->find($floorId);

        if (!Company::isCurrentUserHasAccess($floor)) {
            return ['total' => 0, 'rows' => []];
        }
        $this->authorize('view', Floor::class);
        $rows = array();

        foreach ($floor->floorAssignments as $floor_assignment) {
            $rows[] = [
                'name' => ($floor_assignment->user) ? $floor_assignment->user->present()->nameUrl() : 'Deleted User',
                'created_at' => Helper::getFormattedDateObject($floor_assignment->created_at, 'datetime'),
                'admin' => ($floor_assignment->admin) ? $floor_assignment->admin->present()->nameUrl() : '',
            ];
        }

        $floorCount = $floor->users->count();
        $data = array('total' => $floorCount, 'rows' => $rows);
        return $data;
    }

    /**
     * Checkout a floor
     *
     * @author [A. Gutierrez] [<andres@baller.tv>]
     * @param int $id
     * @since [v4.9.5]
     * @return JsonResponse
     */
    public function checkout(Request $request, $id)
    {
        // Check if the floor exists
        if (is_null($floor = Floor::find($id))) {
            return response()->json(Helper::formatStandardApiResponse('error', null, trans('admin/floors/message.does_not_exist')));
        }

        $this->authorize('checkout', $floor);

        if ($floor->qty > 0) {

            // Check if the user exists
            $assigned_to = $request->input('assigned_to');
            if (is_null($user = User::find($assigned_to))) {
                // Return error message
                return response()->json(Helper::formatStandardApiResponse('error', null, 'No user found'));
            }

            // Update the floor data
            $floor->assigned_to = e($assigned_to);

            $floor->users()->attach($floor->id, [
                'floor_id' => $floor->id,
                'user_id' => $user->id,
                'assigned_to' => $assigned_to
            ]);

            // Log checkout event
            $logaction = $floor->logCheckout(e($request->input('note')), $user);
            $data['log_id'] = $logaction->id;
            $data['eula'] = $floor->getEula();
            $data['first_name'] = $user->first_name;
            $data['item_name'] = $floor->name;
            $data['checkout_date'] = $logaction->created_at;
            $data['note'] = $logaction->note;
            $data['require_acceptance'] = $floor->requireAcceptance();

            return response()->json(Helper::formatStandardApiResponse('success', null,  trans('admin/floors/message.checkout.success')));
        }

        return response()->json(Helper::formatStandardApiResponse('error', null, 'No floors remaining'));
    }

    /**
    * Gets a paginated collection for the select2 menus
    *
    * @see \App\Http\Transformers\SelectlistTransformer
    *
    */
    public function selectlist(Request $request)
    {

        $floors = Floor::select([
            'floors.id',
            'floors.name'
        ]);

        if ($request->filled('search')) {
            $floors = $floors->where('floors.name', 'LIKE', '%'.$request->get('search').'%');
        }

        $floors = $floors->orderBy('name', 'ASC')->paginate(50);


        return (new SelectlistTransformer)->transformSelectlist($floors);
    }
}
