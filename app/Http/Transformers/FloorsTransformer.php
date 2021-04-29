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
            'id' => (int)$floor->id,
            'name' => e($floor->name),
            'image' => ($floor->image) ? Storage::disk('public')->url('floors/' . e($floor->image)) : null,
            'category' => ($floor->category) ? ['id' => $floor->category->id, 'name' => e($floor->category->name)] : null,
            'company' => ($floor->company) ? ['id' => (int)$floor->company->id, 'name' => e($floor->company->name)] : null,
            'ext_system' => e($floor->ext_system),
            'ext_object' => e($floor->ext_object),
            'ext_identifier' => e($floor->ext_identifier),
            'description' => e($floor->description),
            'elevation' => $floor->elevation,
            'height' => $floor->height,
            'created_at' => Helper::getFormattedDateObject($floor->created_at, 'datetime'),
            'updated_at' => Helper::getFormattedDateObject($floor->updated_at, 'datetime'),
        ];

        $permissions_array['user_can_checkout'] = false;

        $permissions_array['available_actions'] = [
            'update' => Gate::allows('update', Floor::class),
            'delete' => Gate::allows('delete', Floor::class),
        ];
        $array += $permissions_array;
        return $array;
    }

}
