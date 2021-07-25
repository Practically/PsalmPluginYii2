#  Copyright 2021 Practically.io All rights reserved
#
#  Use of this source is governed by a BSD-style
#  licence that can be found in the LICENCE file or at
#  https://www.practically.io/copyright/

Feature: ActiveRecord->hasOne();
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

      use Practically\PsalmPluginYii2\Tests\Models\Post;
      use Practically\PsalmPluginYii2\Tests\Models\User;
      """

  Scenario: You can find one and it returns the model instance
    Given I have the following code
      """
      $post = Post::find()->one();
	  if ($post === null) {
	  	 throw new \Exception('Not found');
	  }
	  
	  $user = $post->getCreator()->one();
	  if ($user === null) {
	  	 throw new \Exception('Not found');
	  }

	  $user->getName();
      """
    When I run Psalm
    Then I see no errors
