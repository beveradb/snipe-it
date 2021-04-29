<!-- Ext. Object -->
<div class="form-group {{ $errors->has('ext_object') ? ' has-error' : '' }}">
    <label for="ext_object" class="col-md-3 control-label">{{ trans('general.ext_object') }}</label>
    <div class="col-md-7 col-sm-12{{  (\App\Helpers\Helper::checkIfRequired($item, 'ext_object')) ? ' required' : '' }}">
        <input class="form-control" type="text" name="ext_object" aria-label="ext_object" id="ext_object" value="{{ old('ext_object', $item->ext_object) }}"{!!  (\App\Helpers\Helper::checkIfRequired($item, 'ext_object')) ? ' data-validation="required" required' : '' !!} />
        {!! $errors->first('ext_object', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
    </div>
</div>
