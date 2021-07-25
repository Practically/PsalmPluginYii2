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

use yii\db\ActiveQuery;

/**
 * A test class that will mock a blog post category
 */
class CategoryQuery extends ActiveQuery
{

    public function active(): self
    {
        return $this;
    }

}
