<!-- Height -->
<div class="form-group {{ $errors->has('height') ? ' has-error' : '' }}">
    <label for="height" class="col-md-3 control-label">{{ trans('general.height') }}</label>
    <div class="col-md-7 col-sm-12{{  (\App\Helpers\Helper::checkIfRequired($item, 'height')) ? ' required' : '' }}">
        <input class="form-control" type="text" name="height" aria-label="height" id="height" value="{{ old('height', $item->height) }}"{!!  (\App\Helpers\Helper::checkIfRequired($item, 'height')) ? ' data-validation="required" required' : '' !!} />
        {!! $errors->first('height', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
    </div>
</div>
