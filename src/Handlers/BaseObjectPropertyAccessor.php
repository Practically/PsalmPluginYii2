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

use Psalm\Codebase;
use Psalm\Plugin\EventHandler\Event\PropertyExistenceProviderEvent;
use Psalm\Plugin\EventHandler\Event\PropertyTypeProviderEvent;
use Psalm\Plugin\EventHandler\Event\PropertyVisibilityProviderEvent;
use Psalm\Plugin\EventHandler\PropertyExistenceProviderInterface;
use Psalm\Plugin\EventHandler\PropertyTypeProviderInterface;
use Psalm\Plugin\EventHandler\PropertyVisibilityProviderInterface;
use Psalm\Type;
use Psalm\Type\Atomic\TArray;
use Psalm\Type\Atomic\TGenericObject;
use Psalm\Type\Union;
use RuntimeException;
use Throwable;
use yii\base\BaseObject;
use yii\db\ActiveQuery;
use yii\db\ActiveQueryInterface;

/**
 * Evaluates properties from the BaseObject getters and setters.
 */
class BaseObjectPropertyAccessor implements PropertyExistenceProviderInterface, PropertyVisibilityProviderInterface, PropertyTypeProviderInterface
{

    /**
     * @var Codebase|null
     */
    public static $codebase = null;

    /**
     * @return array<string>
     */
    public static function getClassLikeNames(): array
    {
        $codebase = self::$codebase;
        if ($codebase === null) {
            throw new RuntimeException('BaseObjectPropertyAccessor::$codebase must be populated before adding the plugin.');
        }

        /** @psalm-suppress InternalMethod */
        $classlikes = $codebase->classlikes->getMatchingClassLikeNames('*\\');
        return array_filter(
            $classlikes,
            function ($fq_classlike_name) use ($codebase): bool {
                try {
                    return $codebase->classExtends($fq_classlike_name, BaseObject::class);
                } catch (Throwable $e) {
                    return false;
                }
            }
        );
    }

    /**
     * @inheritDoc
     */
    public static function doesPropertyExist(PropertyExistenceProviderEvent $event): ?bool
    {
        $source = $event->getSource();
        if (!$source || !$event->isReadMode()) {
            return null;
        }

        $codebase = $source->getCodebase();
        $fq_classlike_name = $event->getFqClasslikeName();

        if (!$codebase->classExtends($fq_classlike_name, BaseObject::class)) {
            return null;
        }

        $property_name = $event->getPropertyName();
        if (self::doesGetterExist($codebase, $fq_classlike_name, $property_name)
         || self::doesSetterExist($codebase, $fq_classlike_name, $property_name)
        ) {
            return true;
        }

        return null;
    }

    /**
     * @inheritDoc
     */
    public static function isPropertyVisible(PropertyVisibilityProviderEvent $event): ?bool
    {
        $source = $event->getSource();
        if (!$event->isReadMode()) {
            return null;
        }

        $codebase = $source->getCodebase();
        $fq_classlike_name = $event->getFqClasslikeName();

        if (!$codebase->classExtends($fq_classlike_name, BaseObject::class)) {
            return null;
        }

        $property_name = $event->getPropertyName();
        $setter_exists = self::doesSetterExist($codebase, $fq_classlike_name, $property_name);
        $getter_exists = self::doesGetterExist($codebase, $fq_classlike_name, $property_name);
        if ($setter_exists || $getter_exists) {
            return true;
        }

        return null;
    }

    /**
     * @inheritDoc
     */
    public static function getPropertyType(PropertyTypeProviderEvent $event): ?Union
    {
        $source = $event->getSource();
        if ($source === null || !$event->isReadMode()) {
            return null;
        }

        $codebase = $source->getCodebase();
        $fq_classlike_name = $event->getFqClasslikeName();

        if (!$codebase->classExtends($fq_classlike_name, BaseObject::class)) {
            return null;
        }

        $property_name = $event->getPropertyName();
        if (self::doesGetterExist($codebase, $fq_classlike_name, $property_name)) {
            $getter = sprintf('%s::get%s', $fq_classlike_name, ucfirst($property_name));
            $type = $codebase->getMethodReturnType($getter, $fq_classlike_name);
            if ($type === null) {
                return Type::getMixed();
            }

            foreach ($type->getAtomicTypes() as $atomic_type) {
                if ($atomic_type instanceof TGenericObject) {
                    if ($atomic_type->value === ActiveQuery::class
                     || $codebase->classExtendsOrImplements($atomic_type->value, ActiveQueryInterface::class)
                    ) {
                        $isArray = false;
                        if (count($atomic_type->type_params) === 2 && (string)$atomic_type->type_params[1] === 'true') {
                            $isArray = true;
                        }

                        $type->removeType($atomic_type->getKey());
                        if ($isArray) {
                            $type->addType(new TArray([Type::getArrayKey(), $atomic_type->type_params[0]]));
                        } else {
                            foreach ($atomic_type->type_params[0]->getAtomicTypes() as $type_to_add) {
                                $type->addType($type_to_add);
                            }
                        }
                    }
                }
            }

            return $type;
        }

        return null;
    }

    /**
     * Tests to see if a getter function exists on a class.
     */
    private static function doesGetterExist(Codebase $codebase, string $fq_classlike_name, string $property_name): bool
    {
        $getter = sprintf('%s::get%s', $fq_classlike_name, ucfirst($property_name));
        return $codebase->methodExists($getter);
    }

    /**
     * Tests to see if a setter function exists on a class
     */
    private static function doesSetterExist(Codebase $codebase, string $fq_classlike_name, string $property_name): bool
    {
        $setter = sprintf('%s::set%s', $fq_classlike_name, ucfirst($property_name));
        return $codebase->methodExists($setter);
    }

}
