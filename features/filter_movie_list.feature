Feature: Filter movie list
  As a movie fan
  So that I can quickly find movies with ratings I care about
  I want to filter the movie list by selected star ratings

  Background:
    Given the following movies exist:
      | Title          | Rating | Description                                                    | Release date |
      | Aladdin        | 1      | A musical adventure about a street-smart hero and a magic lamp | 1992-11-25   |
      | Finding Nemo   | 2      | A colorful ocean adventure about family and friendship         | 2003-05-30   |
      | The Avengers   | 4      | A superhero team joins forces to protect the world             | 2012-05-04   |
      | The Terminator | 5      | A science fiction action film about a cyborg assassin          | 1984-10-26   |

  Scenario: View movies created by the background
    When I go to the RottenPotatoes home page
    Then I should see all of the movies

  Scenario: Restrict to movies with 2 or 5 stars
    When I go to the RottenPotatoes home page
    And I check the following ratings: "2, 5"
    And I press "Apply Filter"
    Then I should see "Finding Nemo"
    And I should see "The Terminator"
    And I should not see "Aladdin"
    And I should not see "The Avengers"

  Scenario: All ratings selected
    When I go to the RottenPotatoes home page
    And I check the following ratings: "1, 2, 3, 4, 5"
    And I press "Apply Filter"
    Then I should see all of the movies
