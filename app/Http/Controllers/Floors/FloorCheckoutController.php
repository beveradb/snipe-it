<?php

namespace App\Http\Controllers\Floors;

use App\Events\CheckoutableCheckedOut;
use App\Http\Controllers\Controller;
use App\Models\Floor;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Input;

class FloorCheckoutController extends Controller
{

    /**
     * Return a view to checkout a floor to a user.
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @see FloorCheckoutController::store() method that stores the data.
     * @since [v1.0]
     * @param int $floorId
     * @return \Illuminate\Contracts\View\View
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function create($floorId)
    {
        if (is_null($floor = Floor::find($floorId))) {
            return redirect()->route('floors.index')->with('error', trans('admin/floors/message.does_not_exist'));
        }
        $this->authorize('checkout', $floor);
        return view('floors/checkout', compact('floor'));
    }

    /**
     * Saves the checkout information
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @see FloorCheckoutController::create() method that returns the form.
     * @since [v1.0]
     * @param int $floorId
     * @return \Illuminate\Http\RedirectResponse
     * @throws \Illuminate\Auth\Access\AuthorizationException
     */
    public function store(Request $request, $floorId)
    {
        if (is_null($floor = Floor::find($floorId))) {
            return redirect()->route('floors.index')->with('error', trans('admin/floors/message.not_found'));
        }

        $this->authorize('checkout', $floor);

        $admin_user = Auth::user();
        $assigned_to = e($request->input('assigned_to'));

        // Check if the user exists
        if (is_null($user = User::find($assigned_to))) {
            // Redirect to the floor management page with error
            return redirect()->route('checkout/floor', $floor)->with('error', trans('admin/floors/message.checkout.user_does_not_exist'));
        }

        // Update the floor data
        $floor->assigned_to = e($request->input('assigned_to'));

        $floor->users()->attach($floor->id, [
            'floor_id' => $floor->id,
            'user_id' => $admin_user->id,
            'assigned_to' => e($request->input('assigned_to'))
        ]);

        event(new CheckoutableCheckedOut($floor, $user, Auth::user(), $request->input('note')));

        // Redirect to the new floor page
        return redirect()->route('floors.index')->with('success', trans('admin/floors/message.checkout.success'));

    }
}
