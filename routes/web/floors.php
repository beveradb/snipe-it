<?php


    # Floors
    Route::group([ 'prefix' => 'floors', 'middleware' => ['auth']], function () {
        Route::get(
            '{floorID}/checkout',
            [ 'as' => 'checkout/floor','uses' => 'Floors\FloorCheckoutController@create' ]
        );
        Route::post(
            '{floorID}/checkout',
            [ 'as' => 'checkout/floor', 'uses' => 'Floors\FloorCheckoutController@store' ]
        );
    });

    Route::resource('floors', 'Floors\FloorsController', [
        'middleware' => ['auth'],
        'parameters' => ['floor' => 'floor_id']
    ]);
