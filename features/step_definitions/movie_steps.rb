Given('I am on the RottenPotatoes home page') do
  visit movies_path
end

Then('I should see {string}') do |text|
  # Check in both page content and flash messages
  has_content = page.has_content?(text, wait: 5)
  raise "Expected to see #{text.inspect} on the page" unless has_content || page.text.include?(text)
end

Then('I should not see {string}') do |text|
  raise "Expected not to see #{text.inspect} on the page" if page.has_content?(text, wait: 1)
end

When('I fill in {string} with {string}') do |field, value|
  field_name = case field
               when 'Search Terms' then 'search_terms'
               when 'Title' then 'movie_title'
               when 'Description' then 'movie_description'
               when 'Release date' then 'movie_release_date'
               when 'Rating' then 'movie_rating'
               else field
               end

  fill_in field_name, with: value
end

When('I press {string}') do |button_text|
  normalized_text = case button_text
                    when 'Save Changes' then 'Save Movie'
                    else button_text
                    end

  pattern = /#{Regexp.escape(normalized_text)}/i
  button = page.all(:button, text: pattern, minimum: 0).first
  button ||= page.all(:link, text: pattern, minimum: 0).first
  if button
    button.click
  else
    xpath = "//input[@type='submit' and contains(translate(@value, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), '#{normalized_text.downcase}')]"
    button = page.all(:xpath, xpath, visible: true, minimum: 0).first
    raise "Unable to find button or submit input matching #{normalized_text.inspect}" unless button
    button.click
  end
end

Then('I should be on the RottenPotatoes home page') do
  raise "Expected to be on #{movies_path}, but was on #{current_path}" unless current_path == movies_path
end

Then('I should be on the Create New Movie page') do
  raise "Expected to be on #{new_movie_path}, but was on #{current_path}" unless current_path == new_movie_path
end

When('I follow {string}') do |link_text|
  link = find(:link, text: /#{Regexp.escape(link_text)}/i, match: :first)
  link.click
end

When('I check the {string} checkbox') do |label|
  check(label)
end

When('I select {string} from {string}') do |value, field|
  mapped_value = case value
                 when 'PG' then '2'
                 when 'R' then '5'
                 else value
                 end

  field_name = case field
               when 'Rating' then 'movie_rating'
               else field
               end

  select mapped_value, from: field_name
end

When('I click {string} sort header') do |column|
  pattern = case column.downcase
            when 'title' then /Title/i
            when 'release date' then /Release Date/i
            else /#{Regexp.escape(column)}/i
            end

  header = find(:link, text: pattern, match: :first)
  header.click
end

Then('{string} should appear before {string} in the movie list') do |first_movie, second_movie|
  first_index = page.body.index(first_movie)
  second_index = page.body.index(second_movie)
  raise "Expected #{first_movie.inspect} and #{second_movie.inspect} to appear on the page" unless first_index && second_index
  raise "Expected #{first_movie.inspect} to appear before #{second_movie.inspect}" unless first_index < second_index
end

Then('I should see {string} before {string}') do |first_text, second_text|
  first_index = page.body.index(first_text)
  second_index = page.body.index(second_text)
  raise "Expected #{first_text.inspect} and #{second_text.inspect} to appear on the page" unless first_index && second_index
  raise "Expected #{first_text.inspect} to appear before #{second_text.inspect}" unless first_index < second_index
end

def create_movies_from_table(table)
  table.hashes.each do |movie_data|
    rating_value = case movie_data['Rating']
                   when 'G' then '0'
                   when 'PG' then '2'
                   when 'PG-13' then '3'
                   when 'R' then '5'
                   when 'NC-17' then '5'
                   else movie_data['Rating']
                   end

    Movie.create!(
      title: movie_data['Title'],
      rating: rating_value,
      description: movie_data['Description'],
      release_date: Date.parse(movie_data['Release date'])
    )
  end
end

Given('there are {int} movies with the following details:') do |count, table|
  raise "Expected #{count} movies, but got #{table.hashes.size}" unless table.hashes.size == count

  create_movies_from_table(table)
end

Given('the following movies exist:') do |table|
  create_movies_from_table(table)
end

When('I go to the RottenPotatoes home page') do
  visit movies_path
end
