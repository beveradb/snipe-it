@extends('layouts/default')

{{-- Page title --}}
@section('title')
 {{ $floor->name }}
 {{ trans('general.floor') }}
@parent
@stop

@section('header_right')
<a href="{{ URL::previous() }}" class="btn btn-primary pull-right">
  {{ trans('general.back') }}</a>
@stop


{{-- Page content --}}
@section('content')

<div class="row">
  <div class="col-md-9">
    <div class="box box-default">
      @if ($floor->id)
      <div class="box-header with-border">
        <div class="box-heading">
          <h2 class="box-title"> {{ $floor->name }}</h2>
        </div>
      </div><!-- /.box-header -->
      @endif

      <div class="box-body">
        <div class="row">
          <div class="col-md-12">
            <div class="table table-responsive">

              <table
                      data-cookie-id-table="floorsCheckedoutTable"
                      data-pagination="true"
                      data-id-table="floorsCheckedoutTable"
                      data-search="false"
                      data-side-pagination="server"
                      data-show-columns="true"
                      data-show-export="true"
                      data-show-footer="true"
                      data-show-refresh="true"
                      data-sort-order="asc"
                      data-sort-name="name"
                      id="floorsCheckedoutTable"
                      class="table table-striped snipe-table"
                      data-url="{{route('api.floors.showUsers', $floor->id)}}"
                      data-export-options='{
                "fileName": "export-floors-{{ str_slug($floor->name) }}-checkedout-{{ date('Y-m-d') }}",
                "ignoreColumn": ["actions","image","change","checkbox","checkincheckout","icon"]
                }'>
                <thead>
                  <tr>
                    <th data-searchable="false" data-sortable="false" data-field="name">{{ trans('general.user') }}</th>
                    <th data-searchable="false" data-sortable="false" data-field="created_at" data-formatter="dateDisplayFormatter">{{ trans('general.date') }}</th>
                    <th data-searchable="false" data-sortable="false" data-field="admin">{{ trans('general.admin') }}</th>
                  </tr>
                </thead>
              </table>
            </div>
          </div> <!-- /.col-md-12-->

        </div>
      </div>
    </div> <!-- /.box.box-default-->
  </div> <!-- /.col-md-9-->
  <div class="col-md-3">
    @if ($floor->image!='')
      <div class="col-md-12 text-center" style="padding-bottom: 15px;">
        <a href="{{ Storage::disk('public')->url('floors/'.e($floor->image)) }}" data-toggle="lightbox">
            <img src="{{ Storage::disk('public')->url('floors/'.e($floor->image)) }}" class="img-responsive img-thumbnail" alt="{{ $floor->name }}"></a>
      </div>
    @endif

    @if ($floor->purchase_date)
      <div class="col-md-12" style="padding-bottom: 5px;">
        <strong>{{ trans('general.purchase_date') }}: </strong>
        {{ $floor->purchase_date }}
      </div>
    @endif

    @if ($floor->purchase_cost)
      <div class="col-md-12" style="padding-bottom: 5px;">
        <strong>{{ trans('general.purchase_cost') }}:</strong>
        {{ $snipeSettings->default_currency }}
        {{ \App\Helpers\Helper::formatCurrencyOutput($floor->purchase_cost) }}
      </div>
    @endif

    @if ($floor->item_no)
      <div class="col-md-12" style="padding-bottom: 5px;">
        <strong>{{ trans('admin/floors/general.item_no') }}:</strong>
        {{ $floor->item_no }}
      </div>
    @endif

    @if ($floor->model_number)
      <div class="col-md-12" style="padding-bottom: 5px;">
        <strong>{{ trans('general.model_no') }}:</strong>
        {{ $floor->model_number }}
      </div>
    @endif

    @if ($floor->manufacturer)
      <div class="col-md-12" style="padding-bottom: 5px;">
        <strong>{{ trans('general.manufacturer') }}:</strong>
        {{ $floor->manufacturer->name }}
      </div>
    @endif

    @if ($floor->order_number)
      <div class="col-md-12" style="padding-bottom: 5px;">
        <strong>{{ trans('general.order_number') }}:</strong>
        {{ $floor->order_number }}
      </div>
    @endif

    @can('checkout', \App\Models\Accessory::class)
    <div class="col-md-12">
        <a href="{{ route('checkout/floor', $floor->id) }}" style="padding-bottom:5px;" class="btn btn-primary btn-sm" {{ (($floor->numRemaining() > 0 ) ? '' : ' disabled') }}>{{ trans('general.checkout') }}</a>
    </div>
    @endcan
  </div> <!-- /.col-md-3-->
</div> <!-- /.row-->

@stop

@section('moar_scripts')
@include ('partials.bootstrap-table', ['exportFile' => 'floor' . $floor->name . '-export', 'search' => false])
@stop
