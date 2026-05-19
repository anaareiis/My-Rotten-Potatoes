Feature: Filter movie list
  As a movie fan
  So that I can quickly find movies with ratings I care about
  I want to filter the movie list by selected ratings

  Background:
    Given the following movies exist:
      | Title          | Rating | Description                                                    | Release date |
      | Aladdin        | G      | A musical adventure about a street-smart hero and a magic lamp | 1992-11-25   |
      | The Terminator | R      | A science fiction action film about a cyborg assassin          | 1984-10-26   |

  Scenario: View movies created by the background
    When I go to the RottenPotatoes home page
    Then I should see "Aladdin"
    And I should see "The Terminator"
