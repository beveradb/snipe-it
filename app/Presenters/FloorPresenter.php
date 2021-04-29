<?php

namespace App\Presenters;


/**
 * Class ComponentPresenter
 * @package App\Presenters
 */
class FloorPresenter extends Presenter
{

    /**
     * Json Column Layout for bootstrap table
     * @return string
     */
    public static function dataTableLayout()
    {
        $layout = [
            [
                "field" => "id",
                "searchable" => false,
                "sortable" => true,
                "switchable" => true,
                "title" => trans('general.id'),
                "visible" => false
            ],
            [
                "field" => "company",
                "searchable" => true,
                "sortable" => true,
                "switchable" => true,
                "title" => trans('general.company'),
                "visible" => false,
                "formatter" => 'companiesLinkObjFormatter',
            ],
            [
                "field" => "name",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.name'),
                "visible" => true,
                "formatter" => 'floorsLinkFormatter',
            ],
            [
                "field" => "image",
                "searchable" => false,
                "sortable" => true,
                "switchable" => true,
                "title" => trans('general.image'),
                "visible" => false,
                "formatter" => 'imageFormatter',
            ], [
                "field" => "category",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.category'),
                "formatter" => "categoriesLinkObjFormatter"
            ],[
                "field" => "ext_system",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.ext_system'),
            ],[
                "field" => "ext_object",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.ext_object')
            ],[
                "field" => "ext_identifier",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.ext_identifier')
            ],[
                "field" => "description",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.description')
            ],[
                "field" => "elevation",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.elevation')
            ],[
                "field" => "height",
                "searchable" => true,
                "sortable" => true,
                "title" => trans('general.height')
            ],[
                "field" => "actions",
                "searchable" => false,
                "sortable" => false,
                "switchable" => false,
                "title" => trans('table.actions'),
                "visible" => true,
                "formatter" => "floorsActionsFormatter",
            ]
        ];

        return json_encode($layout);
    }

    /**
     * Url to view this item.
     * @return string
     */
    public function viewUrl()
    {
        return route('floors.show', $this->id);
    }

    /**
     * Generate html link to this items name.
     * @return string
     */
    public function nameUrl()
    {
        return (string) link_to_route('floors.show', e($this->name), $this->id);
    }


}
