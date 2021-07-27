<?php
/**
 * Copyright 2021 Practically.io All rights reserved
 *
 * Use of this source is governed by a BSD-style
 * licence that can be found in the LICENCE file or at
 * https://www.practically.io/copyright/
 */
declare(strict_types=1);

namespace Practically\PsalmPluginYii2;

use Practically\PsalmPluginYii2\Handlers\DifferedPluginRegistration;
use SimpleXMLElement;
use Psalm\Plugin\PluginEntryPointInterface;
use Psalm\Plugin\RegistrationInterface;

/**
 * Yii2 Psalm plugin for a type safer yii2 application
 */
class Plugin implements PluginEntryPointInterface
{

    /**
     * @inheritDoc
     */
    public function __invoke(RegistrationInterface $psalm, ?SimpleXMLElement $config = null): void
    {
        // This is plugin entry point. You can initialize things you need here,
        // and hook them into psalm using RegistrationInterface
        //
        // Here's some examples:
        // 1. Add a stub file
        // ```php
        // $psalm->addStubFile(__DIR__ . '/stubs/YourStub.php');
        // ```
        foreach ($this->getStubFiles() as $file) {
            $psalm->addStubFile($file);
        }

        // Psalm allows arbitrary content to be stored under you plugin entry in
        // its config file, psalm.xml, so your plugin users can put some
        // configuration values there. They will be provided to your plugin
        // entry point in $config parameter, as a SimpleXmlElement object. If
        // there's no configuration present, null will be passed instead.

        require_once 'Handlers/DifferedPluginRegistration.php';
        $psalm->registerHooksFromClass(DifferedPluginRegistration::class);
    }

    /**
     * @return list<string>
     */
    private function getStubFiles(): array
    {
        return glob(dirname(__DIR__).'/stubs/*.phpstub') ?: [];
    }

}
