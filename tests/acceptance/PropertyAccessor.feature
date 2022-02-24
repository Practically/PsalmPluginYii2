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
      <psalm errorLevel="1">
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
  Scenario: You can get a has many relation
    Given I have the following code
      """
	  /** @psalm-return array<array-key, User> */
	  function test(Post $post): array
	  {
	      return $post->contributors;
	  }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can use has many in a loop
    Given I have the following code
      """
	  function test(Post $post): ?User
	  {
		  foreach ($post->contributors as $key => $value) {
		      /** @psalm-trace $key */
		      return $value;
          }

          return null;
	  }
      """
    When I run Psalm
    Then I see these errors
      | Type       | Message		                                       |
	  | UnusedVariable | $key is never referenced or the value is not used |
      | Trace      | $key: array-key                                       |
    And I see no other errors
  Scenario: Wrong return type is picked up correctly
    Given I have the following code
      """
	  function test(Post $post): User
	  {
	      return $post->contributors;
	  }
      """
    When I run Psalm
    Then I see these errors
      | Type                   | Message																																																				        |
      | InvalidReturnType      | The declared return type 'Practically\PsalmPluginYii2\Tests\Models\User' for Practically\PsalmPluginYii2\Tests\Sandbox\test is incorrect, got 'array<array-key, Practically\PsalmPluginYii2\Tests\Models\User>                 |
      | InvalidReturnStatement | The inferred type 'array<array-key, Practically\PsalmPluginYii2\Tests\Models\User>' does not match the declared return type 'Practically\PsalmPluginYii2\Tests\Models\User' for Practically\PsalmPluginYii2\Tests\Sandbox\test |
    And I see no other errors
  Scenario: You can use prop if only a setter is set
    Given I have the following code
      """
	  function test(Post $post): void
	  {
	      $content = $post->content;
          /** @psalm-trace $content */
          $post->content = $content . ' Testing';
      }
      """
    When I run Psalm
    Then I see these errors
      | Type       | Message          |
      | Trace      | $content: string |
    And I see no other errors
  Scenario: You can use prop if only a setter is set
    Given I have the following code
      """
      function test(Post $post): void
      {
          $contentType = $post->contentType;
          $post->contentType = $contentType . ' Testing';
      }
      """
    When I run Psalm
    Then I see these errors
      | MixedAssignment | Unable to determine the type that $contentType is being assigned to |
      | MixedOperand    | Left operand cannot be mixed                                        |
