#  Copyright 2021 Practically.io All rights reserved
#
#  Use of this source is governed by a BSD-style
#  licence that can be found in the LICENCE file or at
#  https://www.practically.io/copyright/

Feature: ActiveRecord->each();
  In order to test my plugin
  As a plugin developer
  I need to have tests

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="true">
        <projectFiles>
          <directory name="."/>
          <ignoreFiles> <directory name="../../vendor"/> </ignoreFiles>
        </projectFiles>
        <plugins>
          <pluginClass class="Practically\PsalmPluginYii2\Plugin" />
        </plugins>
      </psalm>
      """
  And I have the following code preamble
      """
      <?php
      declare(strict_types=1);

      namespace Practically\PsalmPluginYii2\Tests\Sandbox;

      use Practically\PsalmPluginYii2\Tests\Models\User;
      """
  Scenario: You can loop through with `each()`
    Given I have the following code
      """
      foreach (User::find()->each() as $user) {
          $user->getName();
      }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can loop through with `each()` but files on bad function call
    Given I have the following code
      """
      foreach (User::find()->each() as $user) {
          $user->getNotMyName();
      }
      """
    When I run Psalm
    Then I see these errors
      | Type                 | Message                                                                                 |
      | UndefinedMagicMethod | Magic method Practically\PsalmPluginYii2\Tests\Models\User::getnotmyname does not exist |
    And I see no other errors
