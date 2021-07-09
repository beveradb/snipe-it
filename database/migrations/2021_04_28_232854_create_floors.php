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
            $table->integer('user_id')->nullable()->default(null);
            $table->integer('company_id')->unsigned()->nullable()->default(null);;
            $table->integer('category_id')->nullable()->default(null);
            $table->timestamps();
            $table->softDeletes();
            $table->string('ext_system')->nullable()->default(null);
            $table->string('ext_object')->nullable()->default(null);
            $table->string('ext_identifier')->nullable()->default(null);
            $table->string('description')->nullable()->default(null);
            $table->decimal('elevation', 20, 2)->nullable()->default(null);
            $table->decimal('height', 20, 2)->nullable()->default(null);
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
