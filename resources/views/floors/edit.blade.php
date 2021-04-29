@extends('layouts/edit-form', [
    'createText' => trans('admin/floors/general.create') ,
    'updateText' => trans('admin/floors/general.update'),
    'helpPosition'  => 'right',
    'helpText' => trans('help.floors'),
    'formAction' => (isset($item->id)) ? route('floors.update', ['floor' => $item->id]) : route('floors.store'),
])
{{-- Page content --}}
@section('inputFields')

@include ('partials.forms.edit.company-select', ['translated_name' => trans('general.company'), 'fieldname' => 'company_id'])
@include ('partials.forms.edit.name', ['translated_name' => trans('admin/floors/table.title')])
@include ('partials.forms.edit.category-select', ['translated_name' => trans('general.category'), 'fieldname' => 'category_id', 'required' => 'true', 'category_type' => 'floor'])
@include ('partials.forms.edit.ext_system')
@include ('partials.forms.edit.ext_object')
@include ('partials.forms.edit.ext_identifier')
@include ('partials.forms.edit.description')
@include ('partials.forms.edit.elevation')
@include ('partials.forms.edit.height')

<!-- Image -->
@if ($item->image)
    <div class="form-group {{ $errors->has('image_delete') ? 'has-error' : '' }}">
        <label class="col-md-3 control-label" for="image_delete">{{ trans('general.image_delete') }}</label>
        <div class="col-md-5">
            {{ Form::checkbox('image_delete') }}
            <img src="{{ Storage::disk('public')->url(app('floors_upload_path').e($item->image)) }}"  class="img-responsive" />
            {!! $errors->first('image_delete', '<span class="alert-msg">:message</span>') !!}
        </div>
    </div>
@endif

@include ('partials.forms.edit.image-upload')
@stop
