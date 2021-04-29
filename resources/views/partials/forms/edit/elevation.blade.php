<!-- Elevation -->
<div class="form-group {{ $errors->has('elevation') ? ' has-error' : '' }}">
    <label for="elevation" class="col-md-3 control-label">{{ trans('general.elevation') }}</label>
    <div class="col-md-7 col-sm-12{{  (\App\Helpers\Helper::checkIfRequired($item, 'elevation')) ? ' required' : '' }}">
        <input class="form-control" type="text" name="elevation" aria-label="elevation" id="elevation" value="{{ old('elevation', $item->elevation) }}"{!!  (\App\Helpers\Helper::checkIfRequired($item, 'elevation')) ? ' data-validation="required" required' : '' !!} />
        {!! $errors->first('elevation', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
    </div>
</div>
