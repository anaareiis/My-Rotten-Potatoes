require 'rails_helper'

RSpec.describe TmdbClient do
  let(:client) { TmdbClient.new(api_key: 'test_api_key') }

  describe '#search' do
    it 'returns the first matching result' do
      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { api_key: 'test_api_key', query: 'Inception' })
        .to_return(
          status: 200,
          body: {
            results: [
              { id: 27205, title: 'Inception', overview: 'A thief who steals secrets through dreams.', release_date: '2010-07-16', vote_average: 8.4 }
            ]
          }.to_json
        )

      result = client.search('Inception')

      expect(result['title']).to eq('Inception')
      expect(result['id']).to eq(27205)
    end

    it 'returns nil when there are no results' do
      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { api_key: 'test_api_key', query: 'Nonexistent Movie' })
        .to_return(status: 200, body: { results: [] }.to_json)

      expect(client.search('Nonexistent Movie')).to be_nil
    end
  end

  describe '#find_director' do
    it 'returns the director name from the credits' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/27205/credits")
        .with(query: { api_key: 'test_api_key' })
        .to_return(
          status: 200,
          body: {
            crew: [
              { job: 'Writer', name: 'Someone Else' },
              { job: 'Director', name: 'Christopher Nolan' }
            ]
          }.to_json
        )

      expect(client.find_director(27205)).to eq('Christopher Nolan')
    end

    it 'returns nil when there is no director credited' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/27205/credits")
        .with(query: { api_key: 'test_api_key' })
        .to_return(status: 200, body: { crew: [] }.to_json)

      expect(client.find_director(27205)).to be_nil
    end
  end
end
