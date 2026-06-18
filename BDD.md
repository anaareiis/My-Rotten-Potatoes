# BDD Guide - RottenPotatoes

## Overview

This document centralizes the BDD delivery for the RottenPotatoes project. It describes the Gherkin scenarios, the files involved, the Cucumber/Capybara configuration, and the commands required to run and validate the tests.

The BDD suite verifies the following user-visible behaviors:

- Movie search in TMDb (real API integration), with both the sad path (movie not found) and the happy path (movie found and imported, including its director).
- Adding and sorting the movie list by title, in both imperative and declarative versions.
- Filtering the movie list by selected star ratings (1 to 5).
- Sorting the movie list by release date.
- Adding director information to a movie and finding other movies by the same director, including the sad path when a movie has no director.

## Delivery goals

| Requested goal | Status | Where it is implemented |
| --- | --- | --- |
| Implement the sad path for the TMDb search feature. | Implemented | `features/add_movie_sad_path.feature` |
| Implement the real TMDb search happy path (movie found and imported). | Implemented | `features/add_movie_sad_path.feature`, `app/services/tmdb_client.rb` |
| Implement the imperative scenario for adding two movies and sorting by title. | Implemented | `features/view_sorted_movies.feature` |
| Convert the imperative scenario to declarative style. | Implemented | `features/view_sorted_movies.feature` |
| Implement declarative step for creating movies via Gherkin table. | Implemented | `features/step_definitions/movie_steps.rb` |
| Implement BDD happy path for filtering movies by selected star ratings. | Implemented | `features/filter_movie_list.feature` |
| Implement declarative step for checking multiple rating checkboxes. | Implemented | `features/step_definitions/movie_steps.rb` |
| Implement declarative step for verifying all setup movies are visible. | Implemented | `features/step_definitions/movie_steps.rb` |
| Implement BDD scenario for all ratings selected. | Implemented | `features/filter_movie_list.feature` |
| Implement BDD happy path for sorting movies by release date. | Implemented | `features/sort_movie_list.feature` |
| Add director info to a movie and find movies with the same director (happy and sad paths). | Implemented | `features/find_same_director.feature` |

## Implemented structure

### Features

| File | Purpose |
| --- | --- |
| `features/add_movie_sad_path.feature` | Validates the real TMDb search flow: not-found (sad path) and found-and-imported (happy path). |
| `features/view_sorted_movies.feature` | Validates alphabetical movie sorting by title (imperative and declarative). |
| `features/filter_movie_list.feature` | Validates filtering movies by selected star ratings (1-5). |
| `features/sort_movie_list.feature` | Validates sorting movies by title and by release date. |
| `features/find_same_director.feature` | Validates adding a director to a movie and finding other movies by the same director, including the sad path. |

### Test support

| File | Purpose |
| --- | --- |
| `features/step_definitions/movie_steps.rb` | Implements the steps used by the BDD scenarios. |
| `features/support/env.rb` | Loads Cucumber/Rails, starts SimpleCov, enables WebMock (blocking real network calls), disables controller rescue, and cleans the database between scenarios. |
| `cucumber.yml` | Defines the default profile with `pretty` output, an HTML report in `tmp/cucumber.html`, and quiet publishing. |

### Complementary Rails tests

| File | Purpose |
| --- | --- |
| `test/integration/movie_search_test.rb` | Validates the TMDb search sad path at the Rails integration level (TMDb call stubbed with WebMock). |
| `test/integration/movie_list_sort_test.rb` | Validates title sorting with Rails integration tests. |
| `test/integration/movie_filter_test.rb` | Validates filtering by star rating with Rails integration tests. |
| `spec/models/movie_spec.rb` | RSpec model specs for `Movie#movies_with_same_director`. |
| `spec/controllers/movies_controller_spec.rb` | RSpec controller specs for `same_director`, `search_tmdb`, `create`, `update`, and `destroy`. |
| `spec/services/tmdb_client_spec.rb` | RSpec specs for the `TmdbClient` service (search and credits lookup), stubbed with WebMock. |

### Rails code exercised by the scenarios

| File | BDD-related change |
| --- | --- |
| `config/routes.rb` | Adds `POST /movies/search_tmdb` and `GET /movies/:id/same_director` inside `resources :movies`. |
| `app/controllers/movies_controller.rb` | Implements `search_tmdb` (real TMDb search/import) and `same_director`, and keeps sorting by `title` and `release_date`. |
| `app/services/tmdb_client.rb` | Wraps the TMDb search and credits endpoints; reads the API key from Rails encrypted credentials. |
| `app/models/movie.rb` | Validates `rating` as an integer from 1 to 5; implements `movies_with_same_director`. |
| `app/views/movies/index.html.erb` | Displays the "Search TMDb for a movie" form, the 1-5 star rating filter checkboxes, and sorting links (with `title_header`/`release_date_header` ids). |
| `app/views/movies/show.html.erb` | Displays the director (when present) and the "Find Movies With Same Director" link. |
| `Gemfile` | Includes test dependencies for Cucumber, Capybara, DatabaseCleaner, RSpec, SimpleCov, and WebMock. |

## BDD scenarios

### 1. TMDb search - sad and happy paths

File: `features/add_movie_sad_path.feature`

These scenarios exercise the real TMDb integration (`TmdbClient`), with the actual HTTP calls stubbed via WebMock so the suite never depends on network access.

```gherkin
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
```

Expected behavior:

- The search form appears on the home page.
- The user fills in the `Search Terms` field.
- The controller receives the request in `search_tmdb`, which calls `TmdbClient#search`.
- If no result is found, the application redirects to `movies_path` with the message `"#{search_terms} was not found in TMDb."`.
- If a result is found, a new `Movie` is created (title, description, release date, a rating mapped from TMDb's vote average, and the director fetched via `TmdbClient#find_director`), and the application redirects with a success notice.

### 2. Sort by title - imperative scenario

File: `features/view_sorted_movies.feature`

The imperative scenario describes the full UI flow step by step. It creates the movies the way a real user would: opens the creation page, fills in the fields, saves each movie, and then clicks the `Title` header to sort.

Movies used:

| Title | Rating | Release date |
| --- | --- | --- |
| Zorro | 2 | 1920-01-28 |
| Apocalypse Now | 5 | 1979-05-19 |

Main validation:

```gherkin
When I click "title" sort header
Then I should see "Apocalypse Now" before "Zorro"
```

This format is more detailed and documents the UI path well, but it tends to be longer and more sensitive to interface changes.

### 3. Sort by title - declarative scenario

File: `features/view_sorted_movies.feature`

The declarative scenario expresses the business requirement with fewer interface details. The movies are created directly through a Gherkin table, and the test focuses on the main expectation: when sorted by title, `Apocalypse Now` should appear before `Zorro`.

```gherkin
Given there are 2 movies with the following details:
  | Title           | Rating | Description                                                     | Release date |
  | Apocalypse Now  | 5      | An epic war film depicting the horrors and chaos of the Vietnam | 1979-05-19   |
  | Zorro           | 2      | A classic adventure film about a masked hero fighting injustice | 1920-01-28   |
When I go to the RottenPotatoes home page
And I click "title" sort header
Then "Apocalypse Now" should appear before "Zorro" in the movie list
```

This format is more concise, more readable as a specification, and less coupled to the screen-by-screen flow.

### 4. Filter movies by selected star ratings

File: `features/filter_movie_list.feature`

These scenarios ensure that the rating filter shows only movies with the selected star ratings (1 to 5), and that selecting all of them shows every movie.

Background used across all filtering scenarios:

```gherkin
Background:
  Given the following movies exist:
    | Title          | Rating | Description                                                    | Release date |
    | Aladdin        | 1      | A musical adventure about a street-smart hero and a magic lamp | 1992-11-25   |
    | Finding Nemo   | 2      | A colorful ocean adventure about family and friendship         | 2003-05-30   |
    | The Avengers   | 4      | A superhero team joins forces to protect the world             | 2012-05-04   |
    | The Terminator | 5      | A science fiction action film about a cyborg assassin          | 1984-10-26   |
```

**Scenario: View movies created by the background**

```gherkin
When I go to the RottenPotatoes home page
Then I should see all of the movies
```

**Scenario: Restrict to movies with 2 or 5 stars**

```gherkin
When I go to the RottenPotatoes home page
And I check the following ratings: "2, 5"
And I press "Apply Filter"
Then I should see "Finding Nemo"
And I should see "The Terminator"
And I should not see "Aladdin"
And I should not see "The Avengers"
```

**Scenario: All ratings selected**

```gherkin
When I go to the RottenPotatoes home page
And I check the following ratings: "1, 2, 3, 4, 5"
And I press "Apply Filter"
Then I should see all of the movies
```

### 5. Sort by release date

File: `features/sort_movie_list.feature`

This scenario verifies that clicking the release date sort header orders movies chronologically.

Background used:

```gherkin
Background:
  Given the following movies exist:
    | Title           | Rating | Description                                                     | Release date |
    | Apocalypse Now  | 5      | An epic war film depicting the horrors and chaos of the Vietnam | 1979-05-19   |
    | Zorro           | 2      | A classic adventure film about a masked hero fighting injustice | 1920-01-28   |
```

**Scenario: Sort movies by release date**

```gherkin
When I go to the RottenPotatoes home page
And I click "release date" sort header
Then "Zorro" should appear before "Apocalypse Now" in the movie list
```

Zorro (1920) appears before Apocalypse Now (1979) when sorted by ascending release date.

### 6. Director info and "find movies with the same director"

File: `features/find_same_director.feature`

These scenarios cover adding director information to a movie, finding other movies sharing the same director, and the sad path when a movie has no director.

```gherkin
Feature: Find movies with the same director
  As a movie fan
  So that I can discover more movies from a director I like
  I want to find movies with the same director as the one I'm viewing

  Scenario: Add director info to an existing movie
    Given the following movies exist:
      | Title     | Rating | Description                                  | Release date |
      | Inception | 4      | A thief steals secrets through dream-sharing | 2010-07-16   |
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
      | Goodfellas  | 5      | A chronicle of Henry Hill's rise in the mob     | 1990-09-19    | Martin Scorsese  |
      | Taxi Driver | 5      | A lonely veteran becomes a vigilante taxi driver | 1976-02-08    | Martin Scorsese  |
      | Jaws        | 4      | A giant shark terrorizes a beach town           | 1975-06-20    | Steven Spielberg |
    When I go to the RottenPotatoes home page
    And I follow "Goodfellas"
    And I follow "Find Movies With Same Director"
    Then I should see "Taxi Driver"
    And I should not see "Jaws"

  Scenario: Try to find movies with the same director when there is no director (sad path)
    Given the following movies exist:
      | Title         | Rating | Description                          | Release date |
      | Mystery Movie | 3      | A movie with no director listed yet | 2000-01-01   |
    When I go to the RottenPotatoes home page
    And I follow "Mystery Movie"
    And I follow "Find Movies With Same Director"
    Then I should see "Mystery Movie has no director information."
```

Expected behavior:

- `Movie#movies_with_same_director` returns other movies sharing the same director, excluding the movie itself.
- `MoviesController#same_director` renders the matches when a director is present, or redirects back to the movie with an alert when it is not.

## Step definitions

The steps in `features/step_definitions/movie_steps.rb` cover the following groups:

### Navigation

- `Given('I am on the RottenPotatoes home page')`
- `When('I go to the RottenPotatoes home page')`
- `Then('I should be on the RottenPotatoes home page')`
- `Then('I should be on the Create New Movie page')`

### TMDb stubbing (WebMock)

- `Given('TMDb has no movie called {string}')`
- `Given('TMDb has a movie called {string} directed by {string}')`

### Interface interaction

- `When('I fill in {string} with {string}')`
- `When('I select {string} from {string}')`
- `When('I press {string}')`
- `When('I follow {string}')`
- `When('I click {string} sort header')`
- `When('I check the {string} checkbox')`
- `When('I check the following ratings: {string}')`

### Content and order assertions

- `Then('I should see {string}')`
- `Then('I should not see {string}')`
- `Then('I should see {string} before {string}')`
- `Then('{string} should appear before {string} in the movie list')`
- `Then('I should see all of the movies')`

### Declarative data creation

- `Given('there are {int} movies with the following details:')`
- `Given('the following movies exist:')`

Both steps read the Gherkin table and create the records directly with `Movie.create!`, using the `Rating` column as the 1-5 star value and an optional `Director` column. The `the following movies exist:` step also tracks created titles in `@movies_from_setup` so the `I should see all of the movies` assertion can verify them.

## BDD environment configuration

### Dependencies

The relevant gems for the BDD tests are:

- `cucumber`
- `cucumber-rails`
- `capybara`
- `selenium-webdriver`
- `database_cleaner-active_record`
- `rack-test`
- `webmock` (stubs TMDb HTTP calls; blocks any real network access in tests)
- `simplecov` (generates a merged coverage report across RSpec, Minitest, and Cucumber)

### `features/support/env.rb`

The support configuration does four important things:

- Starts SimpleCov before anything else, so coverage is tracked from the first line loaded.
- Loads the Cucumber and Rails integration with `require 'cucumber/rails'`.
- Enables WebMock and blocks real network connections (allowing only localhost, for Capybara's own server).
- Sets `ActionController::Base.allow_rescue = false`, and uses `DatabaseCleaner.strategy = :transaction` / `DatabaseCleaner.cleaning` to isolate the scenarios.

### `cucumber.yml`

The default profile runs the scenarios with readable terminal output and generates an HTML report:

```yaml
default: --format pretty --format html --out tmp/cucumber.html --publish-quiet
```

## How to run

### Prepare the environment

```bash
bundle install
RAILS_ENV=test bundle exec rails db:test:prepare
```

### Run all BDD scenarios

```bash
bundle exec cucumber
```

### Run the related Rails tests

```bash
bundle exec rails test
bundle exec rspec
```

### Run specific features

```bash
bundle exec cucumber features/add_movie_sad_path.feature
bundle exec cucumber features/view_sorted_movies.feature
bundle exec cucumber features/filter_movie_list.feature
bundle exec cucumber features/sort_movie_list.feature
bundle exec cucumber features/find_same_director.feature
```

### Generate or update the HTML report

The report is already generated by the default profile at:

```text
tmp/cucumber.html
```

It can also be called explicitly:

```bash
bundle exec cucumber --format pretty --format html --out tmp/cucumber.html
```

### Coverage report

`bundle exec rspec` and `bundle exec cucumber` both feed the same SimpleCov report at `coverage/index.html`. `app/models/movie.rb` and `app/controllers/movies_controller.rb` are both above 90% line coverage.

## Acceptance criteria

The BDD delivery is complete when:

- `bundle exec cucumber` runs all scenarios successfully.
- The related Rails tests pass with `bundle exec rails test` and `bundle exec rspec`.
- The TMDb scenarios cover both the not-found message and the successful import (with director).
- The imperative scenario adds both movies through the interface and validates alphabetical order by title.
- The declarative scenario creates data through a table and validates the same sorting rule.
- Filtering by 2 or 5 stars shows only the matching movies and hides the rest.
- Selecting all star ratings shows every movie from the background.
- Sorting by release date shows movies in chronological (ascending) order.
- Adding a director and finding movies by the same director works, including the sad path when there is no director.
- The test database is cleaned between scenarios, avoiding execution order dependencies.
- No test makes a real network call (WebMock blocks anything not stubbed).

## Relevant final structure

```text
myrottenpotatoes/
├── features/
│   ├── add_movie_sad_path.feature
│   ├── filter_movie_list.feature
│   ├── find_same_director.feature
│   ├── sort_movie_list.feature
│   ├── view_sorted_movies.feature
│   ├── step_definitions/
│   │   └── movie_steps.rb
│   └── support/
│       └── env.rb
├── app/
│   ├── controllers/
│   │   └── movies_controller.rb
│   ├── models/
│   │   └── movie.rb
│   ├── services/
│   │   └── tmdb_client.rb
│   └── views/
│       └── movies/
│           ├── index.html.erb
│           ├── show.html.erb
│           └── same_director.html.erb
├── config/
│   └── routes.rb
├── spec/
│   ├── models/movie_spec.rb
│   ├── controllers/movies_controller_spec.rb
│   └── services/tmdb_client_spec.rb
├── test/
│   └── integration/
│       ├── movie_list_sort_test.rb
│       ├── movie_filter_test.rb
│       └── movie_search_test.rb
├── BDD.md
├── cucumber.yml
├── Gemfile
└── Gemfile.lock
```

## Tools and concepts demonstrated

### Tools

- Cucumber/Cucumber Rails for writing and running BDD scenarios.
- RSpec for TDD-driven model and controller specs.
- Capybara for simulating user navigation and interaction with the application.
- Selenium WebDriver as a browser automation dependency.
- WebMock for stubbing the real TMDb HTTP calls in every test environment.
- DatabaseCleaner for isolating data between scenarios.
- SimpleCov for tracking combined RSpec/Cucumber/Minitest coverage.
- Gherkin for describing behavior with `Feature`, `Background`, `Scenario`, `Given`, `When`, `Then`, and tables.

### BDD/TDD concepts

- User story focused on user value.
- Sad path and happy path for validating both error handling and the main success flow.
- Imperative scenario for documenting the detailed UI flow.
- Declarative scenario for expressing the business rule with less interface coupling.
- Background for shared setup across scenarios within a feature.
- Gherkin tables for creating structured data.
- Separation between specification (`.feature`) and automation (`step_definitions`).
- TDD cycle (red/green) used to drive `TmdbClient`, `Movie#movies_with_same_director`, and the `same_director`/`search_tmdb` controller actions before wiring up the corresponding Cucumber scenarios.

## Quantitative summary

| Item | Quantity |
| --- | --- |
| BDD features | 5 |
| BDD scenarios | 12 |
| Main Cucumber support files | 3 |
| Related Rails integration tests (Minitest) | 3 |
| RSpec spec files | 3 |
| Rails routes added | 2 (`search_tmdb`, `same_director`) |
| Controller actions added | 2 (`search_tmdb`, `same_director`) |
| Consolidated delivery document | 1 |

## Suggested video demonstration

1. Briefly present `BDD.md` and the delivery goals.
2. Show `features/add_movie_sad_path.feature` and explain both the sad path and the real TMDb import happy path.
3. Show `features/view_sorted_movies.feature` comparing the imperative and declarative scenarios.
4. Show `features/filter_movie_list.feature` and explain the 1-5 star rating filter.
5. Show `features/sort_movie_list.feature` and explain the release date sorting scenario.
6. Show `features/find_same_director.feature` and explain the director feature, including the sad path.
7. Run `bundle exec cucumber` and `bundle exec rspec`.
8. Open `tmp/cucumber.html` and `coverage/index.html`, if generated.
9. Start the application with `bundle exec rails server` and demonstrate filtering, sorting, the real TMDb search, and the director feature.

## Maintenance notes

- Prefer declarative scenarios for stable business rules.
- Use imperative scenarios when the UI flow is also an important part of the specification.
- When changing labels, field names, or button text, review the mappings in `movie_steps.rb`.
- The rating scale is 1 to 5 stars; if it changes again, update `app/models/movie.rb`, the filter checkboxes in `app/views/movies/index.html.erb`, and every feature file's `Rating` column.
- Any code that performs an HTTP request must have its calls stubbed via WebMock in `spec/`, `test/`, and `features/` — real network calls are blocked everywhere except localhost.
