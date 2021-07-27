<?php
/**
 * Copyright 2021 Practically.io All rights reserved
 *
 * Use of this source is governed by a BSD-style
 * licence that can be found in the LICENCE file or at
 * https://www.practically.io/copyright/
 */
declare(strict_types=1);

namespace Practically\PsalmPluginYii2\Handlers;

use Practically\PsalmPluginYii2\Handlers\BaseObjectPropertyAccessor;
use Psalm\Plugin\EventHandler\AfterCodebasePopulatedInterface;
use Psalm\Plugin\EventHandler\Event\AfterCodebasePopulatedEvent;

/**
 * Differs the property event until after the codebase has been populated. This
 * was we can add a property event handler using the classes defined in the
 * codebase rather than doing our own scan of all the files in the application.
 */
class DifferedPluginRegistration implements AfterCodebasePopulatedInterface
{

    /**
     * @inheritDoc
     */
    public static function afterCodebasePopulated(AfterCodebasePopulatedEvent $event)
    {
        BaseObjectPropertyAccessor::$codebase = $event->getCodebase();
        /** @psalm-suppress InternalProperty */
        $event->getCodebase()->properties->property_visibility_provider->registerClass(BaseObjectPropertyAccessor::class);
        /** @psalm-suppress InternalProperty */
        $event->getCodebase()->properties->property_type_provider->registerClass(BaseObjectPropertyAccessor::class);
        /** @psalm-suppress InternalProperty */
        $event->getCodebase()->properties->property_existence_provider->registerClass(BaseObjectPropertyAccessor::class);
    }

}
