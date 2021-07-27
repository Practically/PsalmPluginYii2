#  Copyright 2021 Practically.io All rights reserved
#
#  Use of this source is governed by a BSD-style
#  licence that can be found in the LICENCE file or at
#  https://www.practically.io/copyright/

Feature: BaseObejct::get and BaseObject::set;
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

      namespace Practically\PsalmPluginYii2\Tests\Sandbox;

      use Practically\PsalmPluginYii2\Tests\Models\User;
      use Practically\PsalmPluginYii2\Tests\Models\Category;
      use Practically\PsalmPluginYii2\Tests\Models\Post;
      """
  Scenario: You can get a property via the magic methord __get
    Given I have the following code
      """
	  function test(User $user): string
	  {
	      return $user->name;
	  }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can get a model relation via the magic methord __get
    Given I have the following code
      """
	  function test(Post $post): User
	  {
	      return $post->creator;
	  }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can get a model relation that has a custom query class
    Given I have the following code
      """
	  function test(Post $post): Category
	  {
	      return $post->category;
	  }
      """
    When I run Psalm
    Then I see no errors
