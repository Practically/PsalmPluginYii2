#  Copyright 2021 Practically.io All rights reserved
#
#  Use of this source is governed by a BSD-style
#  licence that can be found in the LICENCE file or at
#  https://www.practically.io/copyright/

Feature: BaseYii::class;
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

	  use yii\BaseYii;
	  use yii\db\Command;
      """
  Scenario: You can create and object from a class string
    Given I have the following code
      """
	  function createCommand(): Command {
	      return BaseYii::createObject(Command::class); 
	  }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can create and object with an array and a `class` key
    Given I have the following code
      """
	  function createCommand(): Command {
	      return BaseYii::createObject(['class' => Command::class]); 
	  }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can create and object from a callback
    Given I have the following code
      """
	  function createCommand(): Command {
	      return BaseYii::createObject(
		      function () {
			      return new Command;
			  }
		  ); 
	  }
      """
    When I run Psalm
    Then I see no errors
