<!-- Description -->
<div class="form-group {{ $errors->has('description') ? ' has-error' : '' }}">
    <label for="description" class="col-md-3 control-label">{{ trans('general.description') }}</label>
    <div class="col-md-7 col-sm-12{{  (\App\Helpers\Helper::checkIfRequired($item, 'description')) ? ' required' : '' }}">
        <textarea class="form-control" name="description" aria-label="description" id="description" value="{{ old('description', $item->description) }}"{!!  (\App\Helpers\Helper::checkIfRequired($item, 'description')) ? ' data-validation="required" required' : '' !!}></textarea>
        {!! $errors->first('description', '<span class="alert-msg" aria-hidden="true"><i class="fa fa-times" aria-hidden="true"></i> :message</span>') !!}
    </div>
</div>
