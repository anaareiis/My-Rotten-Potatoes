Feature: Filter movie list
  As a movie fan
  So that I can quickly find movies with ratings I care about
  I want to filter the movie list by selected ratings

  Background:
    Given the following movies exist:
      | Title          | Rating | Description                                                    | Release date |
      | Aladdin        | G      | A musical adventure about a street-smart hero and a magic lamp | 1992-11-25   |
      | Finding Nemo   | PG     | A colorful ocean adventure about family and friendship         | 2003-05-30   |
      | The Avengers   | PG-13  | A superhero team joins forces to protect the world             | 2012-05-04   |
      | The Terminator | R      | A science fiction action film about a cyborg assassin          | 1984-10-26   |

  Scenario: View movies created by the background
    When I go to the RottenPotatoes home page
    Then I should see "Aladdin"
    And I should see "The Terminator"

  Scenario: Restrict to movies with PG or R ratings
    When I go to the RottenPotatoes home page
    And I check the "PG" checkbox
    And I check the "R" checkbox
    And I press "Apply Filter"
    Then I should see "Finding Nemo"
    And I should see "The Terminator"
    And I should not see "Aladdin"
    And I should not see "The Avengers"
