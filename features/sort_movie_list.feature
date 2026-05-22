Feature: Sort movie list
  As a movie fan
  So that I can organize the movie list
  I want to sort movies by title or release date

  Background:
    Given the following movies exist:
      | Title           | Rating | Description                                                     | Release date |
      | Apocalypse Now  | R      | An epic war film depicting the horrors and chaos of the Vietnam | 1979-05-19   |
      | Zorro           | PG     | A classic adventure film about a masked hero fighting injustice | 1920-01-28   |

  Scenario: Sort movies alphabetically by title
    When I go to the RottenPotatoes home page
    And I click "title" sort header
    Then "Apocalypse Now" should appear before "Zorro" in the movie list

  Scenario: Sort movies by release date
    When I go to the RottenPotatoes home page
    And I click "release date" sort header
    Then "Zorro" should appear before "Apocalypse Now" in the movie list
