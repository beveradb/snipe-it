@extends('layouts/default')

{{-- Page title --}}
@section('title')
     {{ trans('admin/floors/general.checkout') }}
@parent
@stop

{{-- Page content --}}
@section('content')

<div class="row">
  <div class="col-md-9">

    <form class="form-horizontal" method="post" action="" autocomplete="off">
      <!-- CSRF Token -->
      <input type="hidden" name="_token" value="{{ csrf_token() }}" />

      <div class="box box-default">

        @if ($floor->id)
          <div class="box-header with-border">
            <div class="box-heading">
              <h2 class="box-title">{{ $floor->name }} </h2>
            </div>
          </div><!-- /.box-header -->
        @endif

        <div class="box-body">
          @if ($floor->name)
          <!-- floor name -->
          <div class="form-group">
            <label class="col-sm-3 control-label">{{ trans('admin/floors/general.floor_name') }}</label>
            <div class="col-md-6">
              <p class="form-control-static">{{ $floor->name }}</p>
            </div>
          </div>
          @endif

          <!-- User -->
            @include ('partials.forms.edit.user-select', ['translated_name' => trans('general.select_user'), 'fieldname' => 'assigned_to', 'required'=> 'true'])


            @if ($floor->requireAcceptance() || $floor->getEula() || ($snipeSettings->slack_endpoint!=''))
              <div class="form-group notification-callout">
                <div class="col-md-8 col-md-offset-3">
                  <div class="callout callout-info">

                    @if ($floor->category->require_acceptance=='1')
                      <i class="fa fa-envelope"></i>
                      {{ trans('admin/categories/general.required_acceptance') }}
                      <br>
                    @endif

                    @if ($floor->getEula())
                      <i class="fa fa-envelope"></i>
                      {{ trans('admin/categories/general.required_eula') }}
                        <br>
                    @endif

                    @if ($snipeSettings->slack_endpoint!='')
                        <i class="fa fa-slack"></i>
                        A slack message will be sent
                    @endif
                  </div>
                </div>
              </div>
            @endif
          <!-- Note -->
          <div class="form-group {{ $errors->has('note') ? 'error' : '' }}">
            <label for="note" class="col-md-3 control-label">{{ trans('admin/hardware/form.notes') }}</label>
            <div class="col-md-7">
              <textarea class="col-md-6 form-control" id="note" name="note">{{ old('note', $floor->note) }}</textarea>
              {!! $errors->first('note', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
            </div>
          </div>
        </div> <!-- .box-body -->
        <div class="box-footer">
          <a class="btn btn-link" href="{{ URL::previous() }}">{{ trans('button.cancel') }}</a>
          <button type="submit" class="btn btn-primary pull-right"><i class="fa fa-check icon-white" aria-hidden="true"></i> {{ trans('general.checkout') }}</button>
       </div>
      </div>
    </form>

  </div>
</div>
@stop
