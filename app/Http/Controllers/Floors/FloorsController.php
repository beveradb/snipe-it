<?php

namespace App\Http\Controllers\Floors;

use App\Helpers\Helper;
use App\Http\Controllers\Controller;
use App\Http\Requests\ImageUploadRequest;
use App\Models\Company;
use App\Models\Floor;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Input;

/**
 * This controller handles all actions related to Floors for
 * the Snipe-IT Asset Management application.
 *
 * @version    v1.0
 */
class FloorsController extends Controller
{
    /**
     * Return a view to display component information.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @see FloorsController::getDatatable() method that generates the JSON response
     * @since [v1.0]
     * @return \Illuminate\Contracts\View\View
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function index()
    {
        $this->authorize('index', Floor::class);
        return view('floors/index');
    }


    /**
     * Return a view to display the form view to create a new floor
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @see FloorsController::postCreate() method that stores the form data
     * @since [v1.0]
     * @return \Illuminate\Contracts\View\View
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function create()
    {
        $this->authorize('create', Floor::class);
        return view('floors/edit')->with('category_type', 'floor')
            ->with('item', new Floor);
    }


    /**
     * Validate and store new floor data.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @see FloorsController::getCreate() method that returns the form view
     * @since [v1.0]
     * @param ImageUploadRequest $request
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(ImageUploadRequest $request)
    {
        $this->authorize('create', Floor::class);
        $floor = new Floor();
        $floor->name                   = $request->input('name');
        $floor->category_id            = $request->input('category_id');
        $floor->location_id            = $request->input('location_id');
        $floor->company_id             = Company::getIdForCurrentUser($request->input('company_id'));
        $floor->order_number           = $request->input('order_number');
        $floor->min_amt                = $request->input('min_amt');
        $floor->manufacturer_id        = $request->input('manufacturer_id');
        $floor->model_number           = $request->input('model_number');
        $floor->item_no                = $request->input('item_no');
        $floor->purchase_date          = $request->input('purchase_date');
        $floor->purchase_cost          = Helper::ParseFloat($request->input('purchase_cost'));
        $floor->qty                    = $request->input('qty');
        $floor->user_id                = Auth::id();


        $floor = $request->handleImages($floor);

        if ($floor->save()) {
            return redirect()->route('floors.index')->with('success', trans('admin/floors/message.create.success'));
        }

        return redirect()->back()->withInput()->withErrors($floor->getErrors());

    }

    /**
     * Returns a form view to edit a floor.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @param  int $floorId
     * @see FloorsController::postEdit() method that stores the form data.
     * @since [v1.0]
     * @return \Illuminate\Contracts\View\View
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function edit($floorId = null)
    {
        if ($item = Floor::find($floorId)) {
            $this->authorize($item);
            return view('floors/edit', compact('item'))->with('category_type', 'floor');
        }

        return redirect()->route('floors.index')->with('error', trans('admin/floors/message.does_not_exist'));

    }


    /**
     * Returns a form view to edit a floor.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @param ImageUploadRequest $request
     * @param  int $floorId
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     * @see FloorsController::getEdit() method that stores the form data.
     * @since [v1.0]
     */
    public function update(ImageUploadRequest $request, $floorId = null)
    {
        if (is_null($floor = Floor::find($floorId))) {
            return redirect()->route('floors.index')->with('error', trans('admin/floors/message.does_not_exist'));
        }

        $this->authorize($floor);

        $floor->name                   = $request->input('name');
        $floor->category_id            = $request->input('category_id');
        $floor->location_id            = $request->input('location_id');
        $floor->company_id             = Company::getIdForCurrentUser($request->input('company_id'));
        $floor->order_number           = $request->input('order_number');
        $floor->min_amt                = $request->input('min_amt');
        $floor->manufacturer_id        = $request->input('manufacturer_id');
        $floor->model_number           = $request->input('model_number');
        $floor->item_no                = $request->input('item_no');
        $floor->purchase_date          = $request->input('purchase_date');
        $floor->purchase_cost          = Helper::ParseFloat($request->input('purchase_cost'));
        $floor->qty                    = Helper::ParseFloat($request->input('qty'));

        $floor = $request->handleImages($floor);

        if ($floor->save()) {
            return redirect()->route('floors.index')->with('success', trans('admin/floors/message.update.success'));
        }
        return redirect()->back()->withInput()->withErrors($floor->getErrors());
    }

    /**
     * Delete a floor.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @param  int $floorId
     * @since [v1.0]
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function destroy($floorId)
    {
        if (is_null($floor = Floor::find($floorId))) {
            return redirect()->route('floors.index')->with('error', trans('admin/floors/message.not_found'));
        }
        $this->authorize($floor);
        $floor->delete();
        // Redirect to the locations management page
        return redirect()->route('floors.index')->with('success', trans('admin/floors/message.delete.success'));
    }

    /**
     * Return a view to display component information.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @see FloorsController::getDataView() method that generates the JSON response
     * @since [v1.0]
     * @param int $floorId
     * @return \Illuminate\Contracts\View\View
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function show($floorId = null)
    {
        $floor = Floor::find($floorId);
        $this->authorize($floor);
        if (isset($floor->id)) {
            return view('floors/view', compact('floor'));
        }
        return redirect()->route('floors.index')
            ->with('error', trans('admin/floors/message.does_not_exist'));
    }

}
