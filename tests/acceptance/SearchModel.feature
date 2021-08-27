#  Copyright 2021 Practically.io All rights reserved
#
#  Use of this source is governed by a BSD-style
#  licence that can be found in the LICENCE file or at
#  https://www.practically.io/copyright/

Feature: SearchModel::class;
  In order to test my plugin
  As a plugin developer
  I need to have tests

  Background:
    Given I have the following config
      """
      <?xml version="1.0"?>
      <psalm totallyTyped="false">
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

      namespace Practically\PsalmPluginYii2\Tests\Models;

      use yii\data\ActiveDataProvider;
      """
  Scenario: You can perform a search with large query on self
    Given I have the following code
      """
	    /**
	     * A test class that will mock a post search
	     */
        class PostSearch extends \Practically\PsalmPluginYii2\Tests\Models\Post
        {
            public function search(array $params): \yii\data\ActiveDataProvider
            {
                $query = self::find()
                    ->andFilterWhere(['web_ref' => null])
                    ->andFilterWhere(['user_id' => null])
                    ->orderBy(['created_at']);

                $dataProvider = new ActiveDataProvider(['query' => $query]);

                if (!($this->load($params) && $this->validate())) {
                    return $dataProvider;
                }

                $query->andFilterWhere(['like', 'contentType', $this->contentType])
                    ->andFilterWhere(['like', 'status', $this->status]);

                return $dataProvider;
            }
        }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can perform a search with large query on Post model
    Given I have the following code
      """
	    /**
	     * A test class that will mock a post search
	     */
        class PostSearch extends \Practically\PsalmPluginYii2\Tests\Models\Post
        {
            public function search(array $params): \yii\data\ActiveDataProvider
            {
                $query = Post::find()
                    ->andFilterWhere(['web_ref' => null])
                    ->andFilterWhere(['user_id' => null])
                    ->orderBy(['created_at']);

                $dataProvider = new ActiveDataProvider(['query' => $query]);

                if (!($this->load($params) && $this->validate())) {
                    return $dataProvider;
                }

                $query->andFilterWhere(['like', 'contentType', $this->contentType])
                    ->andFilterWhere(['like', 'status', $this->status]);

                return $dataProvider;
            }
        }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can perform a search with one condition removed from query on self before creating the dataProvider
    Given I have the following code
      """
	    /**
	     * A test class that will mock a post search
	     */
        class PostSearch extends \Practically\PsalmPluginYii2\Tests\Models\Post
        {
            public function search(array $params): \yii\data\ActiveDataProvider
            {
                $query = self::find()
                    ->andFilterWhere(['web_ref' => null])
                    ->orderBy(['created_at']);

                $dataProvider = new ActiveDataProvider(['query' => $query]);

                if (!($this->load($params) && $this->validate())) {
                    return $dataProvider;
                }

                $query->andFilterWhere(['like', 'contentType', $this->contentType])
                    ->andFilterWhere(['like', 'status', $this->status]);

                return $dataProvider;
            }
        }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can perform a search with one condition removed from query on self after creating the dataProvider
    Given I have the following code
      """
	    /**
	     * A test class that will mock a post search
	     */
        class PostSearch extends \Practically\PsalmPluginYii2\Tests\Models\Post
        {
            public function search(array $params): \yii\data\ActiveDataProvider
            {
                $query = self::find()
                    ->andFilterWhere(['web_ref' => null])
                    ->andFilterWhere(['user_id' => null])
                    ->orderBy(['created_at']);

                $dataProvider = new ActiveDataProvider(['query' => $query]);

                if (!($this->load($params) && $this->validate())) {
                    return $dataProvider;
                }

                $query->andFilterWhere(['like', 'contentType', $this->contentType]);

                return $dataProvider;
            }
        }
      """
    When I run Psalm
    Then I see no errors
  Scenario: You can perform a search with large query on self, but with chunked $query condition assignment
    Given I have the following code
      """
	    /**
	     * A test class that will mock a post search
	     */
        class PostSearch extends \Practically\PsalmPluginYii2\Tests\Models\Post
        {
            public function search(array $params): \yii\data\ActiveDataProvider
            {
                $query = self::find()
                    ->andFilterWhere(['web_ref' => null])
                    ->andFilterWhere(['user_id' => null])
                    ->orderBy(['created_at']);

                $dataProvider = new ActiveDataProvider(['query' => $query]);

                if (!($this->load($params) && $this->validate())) {
                    return $dataProvider;
                }

                $query->andFilterWhere(['like', 'contentType', $this->contentType]);
                $query->andFilterWhere(['like', 'status', $this->status]);

                return $dataProvider;
            }
        }
      """
    When I run Psalm
    Then I see no errors
