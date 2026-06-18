require 'net/http'
require 'json'

class TmdbClient
  BASE_URL = 'https://api.themoviedb.org/3'

  def initialize(api_key: Rails.application.credentials.tmdb_api_key)
    @api_key = api_key
  end

  def search(title)
    response = get('/search/movie', query: title)
    response['results']&.first
  end

  def find_director(tmdb_movie_id)
    response = get("/movie/#{tmdb_movie_id}/credits")
    director = response['crew']&.find { |member| member['job'] == 'Director' }
    director && director['name']
  end

  private

  def get(path, params = {})
    uri = URI("#{BASE_URL}#{path}")
    uri.query = URI.encode_www_form(params.merge(api_key: @api_key))
    JSON.parse(Net::HTTP.get(uri))
  end
end
