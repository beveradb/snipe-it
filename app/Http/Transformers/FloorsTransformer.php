<?php
namespace App\Http\Transformers;

use App\Helpers\Helper;
use App\Models\Floor;
use Gate;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Support\Facades\Storage;

class FloorsTransformer
{

    public function transformFloors (Collection $floors, $total)
    {
        $array = array();
        foreach ($floors as $floor) {
            $array[] = self::transformFloor($floor);
        }
        return (new DatatablesTransformer)->transformDatatables($array, $total);
    }

    public function transformFloor (Floor $floor)
    {
        $array = [
            'id'            => (int) $floor->id,
            'name'          => e($floor->name),
            'image' =>   ($floor->image) ? Storage::disk('public')->url('floors/'.e($floor->image)) : null,
            'category'      => ($floor->category) ? ['id' => $floor->category->id, 'name' => e($floor->category->name)] : null,
            'company'   => ($floor->company) ? ['id' => (int) $floor->company->id, 'name' => e($floor->company->name)] : null,
            'item_no'       => e($floor->item_no),
            'location'      => ($floor->location) ? ['id' => (int) $floor->location->id, 'name' => e($floor->location->name)] : null,
            'manufacturer'  => ($floor->manufacturer) ? ['id' => (int) $floor->manufacturer->id, 'name' => e($floor->manufacturer->name)] : null,
            'min_amt'       => (int) $floor->min_amt,
            'model_number'  => ($floor->model_number!='') ? e($floor->model_number) : null,
            'remaining'  => $floor->numRemaining(),
            'order_number'  => e($floor->order_number),
            'purchase_cost'  => Helper::formatCurrencyOutput($floor->purchase_cost),
            'purchase_date'  => Helper::getFormattedDateObject($floor->purchase_date, 'date'),
            'qty'           => (int) $floor->qty,
            'created_at' => Helper::getFormattedDateObject($floor->created_at, 'datetime'),
            'updated_at' => Helper::getFormattedDateObject($floor->updated_at, 'datetime'),
        ];

        $permissions_array['user_can_checkout'] = false;

        if ($floor->numRemaining() > 0) {
            $permissions_array['user_can_checkout'] = true;
        }

        $permissions_array['available_actions'] = [
            'checkout' => Gate::allows('checkout', Floor::class),
            'checkin' => Gate::allows('checkin', Floor::class),
            'update' => Gate::allows('update', Floor::class),
            'delete' => Gate::allows('delete', Floor::class),
        ];
        $array += $permissions_array;
        return $array;
    }


    public function transformCheckedoutFloors (Collection $floors_users, $total)
    {

        $array = array();
        foreach ($floors_users as $user) {
            $array[] = (new UsersTransformer)->transformUser($user);
        }
        return (new DatatablesTransformer)->transformDatatables($array, $total);
    }



}
