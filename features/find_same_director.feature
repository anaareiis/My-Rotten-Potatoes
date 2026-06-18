Feature: Find movies with the same director
  As a movie fan
  So that I can discover more movies from a director I like
  I want to find movies with the same director as the one I'm viewing

  Scenario: Add director info to an existing movie
    Given the following movies exist:
      | Title     | Rating | Description                                  | Release date |
      | Inception | PG-13  | A thief steals secrets through dream-sharing | 2010-07-16   |
    When I go to the RottenPotatoes home page
    And I follow "Inception"
    And I follow "Edit"
    And I fill in "Director" with "Christopher Nolan"
    And I press "Update Movie"
    And I follow "Inception"
    Then I should see "Christopher Nolan"

  Scenario: Find movies with the same director
    Given the following movies exist:
      | Title       | Rating | Description                                     | Release date | Director         |
      | Goodfellas  | R      | A chronicle of Henry Hill's rise in the mob     | 1990-09-19    | Martin Scorsese  |
      | Taxi Driver | R      | A lonely veteran becomes a vigilante taxi driver | 1976-02-08    | Martin Scorsese  |
      | Jaws        | PG     | A giant shark terrorizes a beach town           | 1975-06-20    | Steven Spielberg |
    When I go to the RottenPotatoes home page
    And I follow "Goodfellas"
    And I follow "Find Movies With Same Director"
    Then I should see "Taxi Driver"
    And I should not see "Jaws"

  Scenario: Try to find movies with the same director when there is no director (sad path)
    Given the following movies exist:
      | Title         | Rating | Description                          | Release date |
      | Mystery Movie | PG     | A movie with no director listed yet | 2000-01-01   |
    When I go to the RottenPotatoes home page
    And I follow "Mystery Movie"
    And I follow "Find Movies With Same Director"
    Then I should see "Mystery Movie has no director information."
