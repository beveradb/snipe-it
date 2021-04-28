<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateFloors extends Migration
{

    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        //
        Schema::create('floors', function ($table) {
            // Fields from COBIE spec for Floor:
            // Name
            // CreatedBy
            // CreatedOn
            // Category
            // ExtSystem
            // ExtObject
            // ExtIdentifier
            // Description
            // Elevation
            // Height

            $table->increments('id');
            $table->string('name')->nullable()->default(null);
            $table->integer('category_id')->nullable()->default(null);
            $table->integer('location_id')->nullable()->default(null);
            $table->integer('user_id')->nullable()->default(null);
            $table->integer('qty')->default(0);
            $table->boolean('requestable')->default(0);
            $table->timestamps();
            $table->softDeletes();
            $table->date('purchase_date')->nullable();
            $table->decimal('purchase_cost', 20, 2)->nullable()->default(null);
            $table->string('order_number')->nullable();
            $table->integer('company_id')->unsigned()->nullable();
            $table->integer('min_amt')->nullable()->default(null);
            $table->integer('model_number')->nullable()->default(null);
            $table->integer('manufacturer_id')->nullable()->default(null);
            $table->string('item_no')->nullable()->default(null);
            $table->string('image')->nullable()->default(null);

            $table->engine = 'InnoDB';
        });

        Schema::table('asset_logs', function ($table) {
            $table->integer('floor_id')->nullable()->default(null);
        });

        Schema::create('floors_users', function ($table) {
            $table->increments('id');
            $table->integer('user_id')->nullable()->default(null);
            $table->integer('floor_id')->nullable()->default(null);
            $table->integer('assigned_to')->nullable()->default(null);
            $table->timestamps();
        });


    }


    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        //
        Schema::drop('floors');

        Schema::table('asset_logs', function ($table) {
            $table->dropColumn('floor_id');
        });

        Schema::drop('floors_users');

    }

}
