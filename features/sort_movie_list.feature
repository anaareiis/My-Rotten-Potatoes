Feature: Sort movie list
  As a movie fan
  So that I can organize the movie list
  I want to sort movies by title or release date

  Scenario: Sort movies alphabetically by title
    Given there are 2 movies with the following details:
      | Title           | Rating | Description                                                     | Release date |
      | Apocalypse Now  | R      | An epic war film depicting the horrors and chaos of the Vietnam | 1979-05-19   |
      | Zorro           | PG     | A classic adventure film about a masked hero fighting injustice | 1920-01-28   |
    When I go to the RottenPotatoes home page
    And I click "title" sort header
    Then "Apocalypse Now" should appear before "Zorro" in the movie list
