<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FloorAssignment extends Model
{
    use CompanyableTrait;

    protected $dates = ['deleted_at'];
    protected $table = 'floors_users';

    public function floor()
    {
        return $this->belongsTo('\App\Models\Floor');
    }

    public function user()
    {
        return $this->belongsTo('\App\Models\User', 'assigned_to');
    }

    public function admin()
    {
        return $this->belongsTo('\App\Models\User', 'user_id');
    }
}
