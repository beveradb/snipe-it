<?php
namespace App\Models;

use App\Models\Traits\Acceptable;
use App\Models\Traits\Searchable;
use App\Presenters\Presentable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;
use Watson\Validating\ValidatingTrait;

class Floor extends SnipeModel
{
    protected $presenter = 'App\Presenters\FloorPresenter';
    use CompanyableTrait;
    use Loggable, Presentable;
    use SoftDeletes;

    use Acceptable;

    protected $dates = ['deleted_at', 'created_at'];
    protected $table = 'floors';
    protected $casts = [
        'category_id'    => 'integer',
        'company_id'     => 'integer',
    ];



    /**
    * Category validation rules
    */
    public $rules = array(
        'name'        => 'required|min:3|max:255',
        'category_id' => 'required|integer',
        'company_id'  => 'integer|nullable',
        'elevation'   => 'numeric|nullable',
        'height'      => 'numeric|nullable',
    );

    /**
    * Whether the model should inject it's identifier to the unique
    * validation rules before attempting validation. If this property
    * is not set in the model it will default to true.
    *
    * @var boolean
    */
    protected $injectUniqueIdentifier = true;
    use ValidatingTrait;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'category_id',
        'company_id',
        'name',
        'description',
        'ext_system',
        'ext_object',
        'ext_identifier',
        'elevation',
        'height',
    ];

    use Searchable;
    
    /**
     * The attributes that should be included when searching the model.
     * 
     * @var array
     */
    protected $searchableAttributes = ['name', 'description', 'ext_system', 'ext_object', 'ext_identifier'];

    /**
     * The relations and their attributes that should be included when searching the model.
     * 
     * @var array
     */
    protected $searchableRelations = [
        'category'     => ['name'],
        'company'      => ['name'],
    ];

    /**
     * Establishes the floor -> admin user relationship
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return \Illuminate\Database\Eloquent\Relations\Relation
     */
    public function admin()
    {
        return $this->belongsTo('\App\Models\User', 'user_id');
    }

    /**
     * Establishes the floor -> assignments relationship
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return \Illuminate\Database\Eloquent\Relations\Relation
     */
    public function floorAssignments()
    {
        return $this->hasMany('\App\Models\FloorAssignment');
    }

    /**
     * Establishes the floor -> company relationship
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return \Illuminate\Database\Eloquent\Relations\Relation
     */
    public function company()
    {
        return $this->belongsTo('\App\Models\Company', 'company_id');
    }

    /**
     * Establishes the floor -> category relationship
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return \Illuminate\Database\Eloquent\Relations\Relation
     */
    public function category()
    {
        return $this->belongsTo('\App\Models\Category', 'category_id');
    }


    /**
     * Establishes the floor -> action logs relationship
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return \Illuminate\Database\Eloquent\Relations\Relation
     */
    public function assetlog()
    {
        return $this->hasMany('\App\Models\Actionlog', 'ext_identifier')->where('item_type', Floor::class)->orderBy('created_at', 'desc')->withTrashed();
    }

    /**
     * Gets the full image url for the floor
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return string | false
     */
    public function getImageUrl() {
        if ($this->image) {
            return Storage::disk('public')->url(app('floors_upload_path').$this->image);
        }
        return false;

    }

    /**
     * Establishes the floor -> users relationship
     *
     * @author [A. Gianotto] [<snipe@snipe.net>]
     * @since [v3.0]
     * @return \Illuminate\Database\Eloquent\Relations\Relation
     */
    public function users()
    {
        return $this->belongsToMany('\App\Models\User', 'floors_users', 'floor_id', 'assigned_to')->withPivot('user_id')->withTrashed()->withTimestamps();
    }

    /**
    * Query builder scope to order on company
    *
    * @param  \Illuminate\Database\Query\Builder  $query  Query builder instance
    * @param  string                              $order       Order
    *
    * @return \Illuminate\Database\Query\Builder          Modified query builder
    */
    public function scopeOrderCategory($query, $order)
    {
        return $query->join('categories', 'floors.category_id', '=', 'categories.id')->orderBy('categories.name', $order);
    }

    /**
    * Query builder scope to order on location
    *
    * @param  \Illuminate\Database\Query\Builder  $query  Query builder instance
    * @param  text                              $order       Order
    *
    * @return \Illuminate\Database\Query\Builder          Modified query builder
    */
    public function scopeOrderLocation($query, $order)
    {
        return $query->leftJoin('locations', 'floors.location_id', '=', 'locations.id')->orderBy('locations.name', $order);
    }

    /**
     * Query builder scope to order on manufacturer
     *
     * @param  \Illuminate\Database\Query\Builder  $query  Query builder instance
     * @param  string   $order       Order
     *
     * @return \Illuminate\Database\Query\Builder          Modified query builder
     */
    public function scopeOrderManufacturer($query, $order)
    {
        return $query->leftJoin('manufacturers', 'floors.manufacturer_id', '=', 'manufacturers.id')->orderBy('manufacturers.name', $order);
    }


    /**
    * Query builder scope to order on company
    *
    * @param  \Illuminate\Database\Query\Builder  $query  Query builder instance
    * @param  string                              $order       Order
    *
    * @return \Illuminate\Database\Query\Builder          Modified query builder
    */
    public function scopeOrderCompany($query, $order)
    {
        return $query->leftJoin('companies', 'floors.company_id', '=', 'companies.id')->orderBy('companies.name', $order);
    }
}
