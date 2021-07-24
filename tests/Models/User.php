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
 * The user stub for getting a user of an application. This will also be the
 * return type of relations in the `Post` model
 */
class User extends ActiveRecord
{

    /**
     * Gets the users name. This is used for testing that the instance of user
     * can be inferred. When calling `$user->getName()` psalm will fail if it
     * dose not know the `$user` is an instance of `User`
     */
    public function getName(): string
    {
        return 'Ade';
    }

}
