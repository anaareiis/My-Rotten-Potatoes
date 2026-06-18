Feature: View movie list after adding 2 movies
  As a user
  So that I can manage my movie collection
  I want to view and sort movies alphabetically by title

  Scenario: View movie list after adding 2 movies and order alphabetically by title (Imperative)
    Given I am on the RottenPotatoes home page
    When I follow "Add new movie"
    Then I should be on the Create New Movie page
    When I fill in "Title" with "Zorro"
    And I select "2" from "Rating"
    And I fill in "Description" with "A classic adventure film about a masked hero fighting injustice"
    And I fill in "Release date" with "1920-01-28"
    And I press "Save Changes"
    Then I should be on the RottenPotatoes home page
    When I follow "Add new movie"
    Then I should be on the Create New Movie page
    When I fill in "Title" with "Apocalypse Now"
    And I select "5" from "Rating"
    And I fill in "Description" with "An epic war film depicting the horrors and chaos of the Vietnam War"
    And I fill in "Release date" with "1979-05-19"
    And I press "Save Changes"
    Then I should be on the RottenPotatoes home page
    When I click "title" sort header
    Then I should see "Apocalypse Now" before "Zorro"

  Scenario: View movie list after adding 2 movies and order alphabetically by title (Declarative)
    Given there are 2 movies with the following details:
      | Title           | Rating | Description                                                       | Release date |
      | Apocalypse Now  | 5      | An epic war film depicting the horrors and chaos of the Vietnam   | 1979-05-19   |
      | Zorro           | 2      | A classic adventure film about a masked hero fighting injustice   | 1920-01-28   |
    When I go to the RottenPotatoes home page
    And I click "title" sort header
    Then "Apocalypse Now" should appear before "Zorro" in the movie list
