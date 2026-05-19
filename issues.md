**Issue #1 - Add a movie**

As a movie fan  
So that I can share a movie with other fans  
I want to add a movie to the database  

Acceptance Criteria:
- User can access a form to add a movie
- User can fill in movie details
- Movie is saved in the database
- Movie appears in the list

**Issue #2 - view movies**

As a movie fan  
So that I can see available movies  
I want to view the list of movies  

Acceptance Criteria:
- User can see a list of movies
- Each movie shows basic information

**Issue #3 - View movie details**

As a movie fan  
So that I can know more about a movie  
I want to see details of a movie  

Acceptance Criteria:
- User can click on a movie
- User sees full movie details

**Issue #4 - Edit a movie**

As a movie fan  
So that I can correct movie information  
I want to edit a movie  

Acceptance Criteria:
- User can access edit form
- Changes are saved
- Updated info appears correctly

**Issue #5 -Delete a movie**

As a movie fan  
So that I can remove incorrect movies  
I want to delete a movie  

Acceptance Criteria:
- User can delete a movie
- Movie is removed from the list

**Issue #6 - Filter movies by rating**

As a movie fan  
So that I can find movies I like  
I want to filter movies by rating  

Acceptance Criteria:
- User can select ratings
- Only selected ratings are displayed

**Issue #7 - Sort movies**

As a movie fan  
So that I can organize the list  
I want to sort movies by title or release date  

Acceptance Criteria:
- User can choose sorting option
- Movies are displayed in selected order

**Issue #8 - Improve UI and layout**

As a movie fan  
So that I can have a better user experience  
I want the application to have a clean and organized interface  

Acceptance Criteria:
- Pages have consistent layout and spacing
- Movies are displayed in a visually organized way
- Buttons and links are styled clearly
- Forms are easy to read and use
- Flash messages (success/errors) are visible and styled

**Issue #9 - Create project README**

As a developer  
So that others can understand and run the project  
I want to create a clear and complete README file  

Acceptance Criteria:
- README includes project description
- README explains how to install dependencies
- README explains how to run the application
- README includes main features of the system
- README includes basic usage instructions

**Issue #10 - Final adjustments and improvements**

As a developer  
So that the application is more robust and user-friendly  
I want to make final adjustments and improvements  

Acceptance Criteria:
- Release date range is properly configured (no invalid dates)
- Movie description has a maximum character limit
- Rating is validated between 0 and 5
- Forms prevent invalid or empty inputs
- Error messages are displayed clearly to the user
- UI elements are consistent across pages

**Issue #11 - Final polish — Sorting, UX consistency and code quality**

As a developer
So that the application behaves consistently and meets all assignment requirements
I want to refine sorting, filtering, and overall user experience

Acceptance Criteria:

- Sorting by title and release date works correctly through clickable headers
- Sorting order (ascending/descending) toggles properly when clicking multiple times
- Selected sorting column is visually highlighted
- Filtering by rating works together with sorting without breaking results
- Selected filters and sorting persist across navigation (index, new, edit)
- URL parameters (`sort_by`, `sort_order`, `rating`) are handled safely and correctly
- Only valid sorting attributes are accepted (no invalid params allowed)
- Application displays a clear message when no movies match the filter
- Navigation and UI behavior remain consistent across all pages

**Issue #12 - Implement and Document BDD Scenarios for TMDb Sad Path and Movie Sorting**

As a developer
So that the BDD assignment is documented, testable, and easy to validate
I want to implement and consolidate the required Cucumber scenarios for TMDb sad path search and movie sorting

Acceptance Criteria:

- A Cucumber feature covers the TMDb sad path for searching a nonexistent movie
- The TMDb sad path redirects back to the RottenPotatoes home page
- The TMDb sad path displays a clear “movie not found” message
- A Cucumber feature covers adding two movies and sorting them alphabetically by title
- The sorting scenario is implemented in imperative style with detailed UI steps
- The same sorting behavior is also implemented in declarative style using a Gherkin table
- Step definitions support navigation, form filling, button clicks, link clicks, sorting headers, and order assertions
- Cucumber is configured with Rails, Capybara, and DatabaseCleaner
- The test database is cleaned between BDD scenarios
- Related Rails integration tests cover the TMDb sad path and title sorting behavior
- bundle exec cucumber runs all BDD scenarios successfully
- bundle exec rails test runs the related Rails tests successfully
- BDD documentation is consolidated in BDD.md
- BDD.md explains the implemented scenarios, files, commands, acceptance criteria, and maintenance notes
- README references the BDD documentation and remains consistent with the implemented code
- Obsolete delivery summary files are removed so the BDD documentation has a single source of truth

**obs: issues 1 to 11 HW1 and issue 12 HW2**

**Issue #13 - Configure HW3 Cucumber feature structure**

As a developer  
So that the HW3 BDD assignment can be implemented and validated  
I want to organize the Cucumber feature files and support files required by the new phase  

Acceptance Criteria:

- Project has Cucumber configured for the HW3 scenarios
- Feature files for sorting and filtering movies are present
- Step definitions are organized in `features/step_definitions/movie_steps.rb`
- Cucumber support configuration loads Rails and Capybara correctly
- Database is cleaned between scenarios
- `bundle exec cucumber` can run the feature suite

**Issue #14 - Add declarative step for creating movies in BDD backgrounds**

As a developer  
So that BDD scenarios focus on behavior instead of setup details  
I want to create a declarative step that adds movies directly to the test database  

Acceptance Criteria:

- Step definition supports `Given the following movies exist:`
- Step reads movie data from a Gherkin table
- Movies are created using ActiveRecord
- The step supports title, rating, description, and release date fields
- The step can be reused by sorting and filtering feature files
- Background steps for `sort_movie_list.feature` and `filter_movie_list.feature` pass successfully

**Issue #15 - Implement BDD happy path for filtering movies by selected ratings**

As a movie fan  
So that I can find movies with ratings I care about  
I want to filter the movie list by selected ratings  

Acceptance Criteria:

- `filter_movie_list.feature` includes a scenario for restricting movies to `PG` and `R`
- User can select the `PG` and `R` rating filters
- User can submit the filter form
- Movies with selected ratings appear in the list
- Movies with unselected ratings do not appear in the list
- Scenario runs successfully with Cucumber

**Issue #16 - Add declarative step for checking multiple ratings**

As a developer  
So that filtering scenarios are concise and readable  
I want to check multiple rating filters with one Cucumber step  

Acceptance Criteria:

- Step definition supports `When I check the following ratings: G, PG, R`
- The step checks only the ratings listed in the scenario
- Existing checkbox behavior remains compatible with Capybara
- Filtering scenarios use the declarative rating step where appropriate
- Cucumber scenarios remain green after replacing repetitive checkbox steps

**Issue #17 - Add declarative step for verifying all movies are visible**

As a developer  
So that BDD scenarios avoid repetitive assertions  
I want a step that verifies all movies from the test setup are visible  

Acceptance Criteria:

- Step definition supports `Then I should see all of the movies`
- The step verifies that every movie from the scenario setup appears in the movie list
- The step can be used in the `all ratings selected` scenario
- Scenario remains readable and focused on behavior
- All filtering scenarios pass successfully

**Issue #18 - Implement BDD scenario for all ratings selected**

As a movie fan  
So that I can reset or broaden my movie search  
I want to see all movies when all ratings are selected  

Acceptance Criteria:

- `filter_movie_list.feature` includes the `all ratings selected` scenario
- Scenario uses the declarative movie setup background
- Scenario uses the declarative rating selection step
- Scenario uses the `Then I should see all of the movies` step
- All movies from the background appear after submitting the filter
- Scenario passes with `bundle exec cucumber features/filter_movie_list.feature`

**Issue #19 - Implement BDD happy path for sorting movies by release date**

As a movie fan  
So that I can browse movies chronologically  
I want to sort the movie list by release date  

Acceptance Criteria:

- `sort_movie_list.feature` includes a scenario for sorting movies by release date
- Scenario uses the declarative movie setup background
- User can click the release date sorting control
- Movies appear in increasing order of release date
- Step definition supports assertions like `Then I should see "Aladdin" before "Amelie"`
- Sorting by title continues to work
- Sorting by release date scenario passes with Cucumber

**Issue #20 - Validate HW3 BDD scenarios and update documentation**

As a developer  
So that the HW3 delivery is easy to review and maintain  
I want to validate all BDD scenarios and document the implemented behavior  

Acceptance Criteria:

- `bundle exec cucumber` runs all BDD scenarios successfully
- `bundle exec rails test` runs related Rails tests successfully
- `BDD.md` documents the HW3 scenarios
- Documentation explains filtering by ratings
- Documentation explains sorting by title and release date
- Documentation explains the declarative movie setup step
- Documentation lists the validation commands
- `README.md` references the updated BDD documentation

**obs: issues 13 to 20 HW3**
