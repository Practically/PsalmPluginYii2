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
use yii\db\ActiveRecord;

/**
 * A test class that will mock a blog post
 */
class Post extends ActiveRecord
{

    /**
     * Gets the user that created this post
     *
     * @return ActiveQuery<User, false>
     */
    public function getCreator(): ActiveQuery
    {
        return $this->hasOne(User::class, ['user_id' => 'user_id']);
    }

    /**
     * Gets the user that created this post
     *
     * @return ActiveQuery<User, true>
     */
    public function getContributors(): ActiveQuery
    {
        return $this->hasMany(User::class, ['user_id' => 'user_id']);
    }

    /**
     * Gets the user that created this post
     *
     * @return CategoryQuery<Category, false>
     */
    public function getCategory(): CategoryQuery
    {
        return $this->hasOne(Category::class, ['user_id' => 'user_id']);
    }

}
