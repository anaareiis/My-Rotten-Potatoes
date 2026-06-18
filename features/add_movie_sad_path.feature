Feature: User can add movie by searching for it in The Movie Database (TMDb)
  As a movie fan
  So that I can add new movies without manual tedium
  I want to add movies by looking up their details in TMDb

  Background: Start from the Search form on the home page
    Given I am on the RottenPotatoes home page
    Then I should see "Search TMDb for a movie"

  Scenario: Try to add nonexistent movie (sad path)
    Given TMDb has no movie called "Movie That Does Not Exist"
    When I fill in "Search Terms" with "Movie That Does Not Exist"
    And I press "Search TMDb"
    Then I should be on the RottenPotatoes home page
    And I should see "Movie That Does Not Exist was not found in TMDb."

  Scenario: Add a movie found in TMDb (happy path)
    Given TMDb has a movie called "Inception" directed by "Christopher Nolan"
    When I fill in "Search Terms" with "Inception"
    And I press "Search TMDb"
    Then I should be on the RottenPotatoes home page
    And I should see "Inception was added from TMDb."
    When I follow "Inception"
    Then I should see "Christopher Nolan"
