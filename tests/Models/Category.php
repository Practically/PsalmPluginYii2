<?php
/**
 * Copyright 2021 Practically.io All rights reserved
 *
 * Use of this source is governed by a BSD-style
 * licence that can be found in the LICENCE file or at
 * https://www.practically.io/copyright/
 */
declare(strict_types=1);

namespace Practically\PsalmPluginYii2\Tests\Models;

use yii\db\ActiveRecord;

/**
 * A test class that will mock a blog post category
 */
class Category extends ActiveRecord
{

    /**
     * Override the function to return a custom query
     */
    public static function find(): CategoryQuery
    {
        return new CategoryQuery(get_called_class());
    }

    /**
     * A test method to get the category name
     */
    public function getDisplyName(): string
    {
        return 'The category';
    }

}
