<!-- Ext. Identifier -->
<div class="form-group {{ $errors->has('ext_identifier') ? ' has-error' : '' }}">
    <label for="ext_identifier" class="col-md-3 control-label">{{ trans('general.ext_identifier') }}</label>
    <div class="col-md-7 col-sm-12{{  (\App\Helpers\Helper::checkIfRequired($item, 'ext_identifier')) ? ' required' : '' }}">
        <input class="form-control" type="text" name="ext_identifier" aria-label="ext_identifier" id="ext_identifier" value="{{ old('ext_identifier', $item->ext_identifier) }}"{!!  (\App\Helpers\Helper::checkIfRequired($item, 'ext_identifier')) ? ' data-validation="required" required' : '' !!} />
        {!! $errors->first('ext_identifier', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
    </div>
</div>
