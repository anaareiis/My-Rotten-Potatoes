require 'test_helper'

class MovieFilterTest < ActionDispatch::IntegrationTest
  test "filters movies by selected ratings" do
    Movie.create!(
      title: 'Aladdin',
      rating: 1,
      description: 'A musical adventure about a street-smart hero and a magic lamp',
      release_date: '1992-11-25'
    )
    Movie.create!(
      title: 'Finding Nemo',
      rating: 2,
      description: 'A colorful ocean adventure about family and friendship',
      release_date: '2003-05-30'
    )
    Movie.create!(
      title: 'The Avengers',
      rating: 3,
      description: 'A superhero team joins forces to protect the world',
      release_date: '2012-05-04'
    )
    Movie.create!(
      title: 'The Terminator',
      rating: 5,
      description: 'A science fiction action film about a cyborg assassin',
      release_date: '1984-10-26'
    )

    get movies_path, params: { ratings: ['2', '5'] }

    assert_response :success
    assert_includes response.body, 'Finding Nemo'
    assert_includes response.body, 'The Terminator'
    assert_not_includes response.body, 'Aladdin'
    assert_not_includes response.body, 'The Avengers'
  end
end
