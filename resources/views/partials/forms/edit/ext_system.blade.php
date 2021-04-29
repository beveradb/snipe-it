<!-- Ext. System -->
<div class="form-group {{ $errors->has('ext_system') ? ' has-error' : '' }}">
    <label for="ext_system" class="col-md-3 control-label">{{ trans('general.ext_system') }}</label>
    <div class="col-md-7 col-sm-12{{  (\App\Helpers\Helper::checkIfRequired($item, 'ext_system')) ? ' required' : '' }}">
        <input class="form-control" type="text" name="ext_system" aria-label="ext_system" id="ext_system" value="{{ old('ext_system', $item->ext_system) }}"{!!  (\App\Helpers\Helper::checkIfRequired($item, 'ext_system')) ? ' data-validation="required" required' : '' !!} />
        {!! $errors->first('ext_system', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
    </div>
</div>
