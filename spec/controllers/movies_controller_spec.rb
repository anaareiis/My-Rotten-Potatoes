require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  describe 'GET #same_director' do
    context 'when the specified movie has a director' do
      it 'finds movies with the same director' do
        movie = Movie.create!(title: 'Goodfellas', rating: 5, description: 'A mob movie.', release_date: '1990-09-19', director: 'Martin Scorsese')
        same_director_movie = Movie.create!(title: 'Taxi Driver', rating: 5, description: 'A lonely man drives a cab.', release_date: '1976-02-08', director: 'Martin Scorsese')

        get :same_director, params: { id: movie.id }

        expect(assigns(:movies)).to include(same_director_movie)
        expect(response).to render_template(:same_director)
      end
    end

    context 'when the specified movie has no director' do
      it 'redirects to the movie page with an alert' do
        movie = Movie.create!(title: 'Unknown Director Movie', rating: 3, description: 'No director listed.', release_date: '2000-01-01')

        get :same_director, params: { id: movie.id }

        expect(response).to redirect_to(movie_path(movie))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'POST #search_tmdb' do
    context 'when TMDb finds a matching movie' do
      it 'creates the movie with details and director from TMDb' do
        stub_request(:get, 'https://api.themoviedb.org/3/search/movie')
          .with(query: hash_including({ 'query' => 'Inception' }))
          .to_return(status: 200, body: {
            results: [
              { id: 27205, title: 'Inception', overview: 'A thief who steals secrets through dreams.', release_date: '2010-07-16', vote_average: 8.4 }
            ]
          }.to_json)
        stub_request(:get, 'https://api.themoviedb.org/3/movie/27205/credits')
          .with(query: hash_including({}))
          .to_return(status: 200, body: { crew: [{ job: 'Director', name: 'Christopher Nolan' }] }.to_json)

        post :search_tmdb, params: { search_terms: 'Inception' }

        movie = Movie.find_by(title: 'Inception')
        expect(movie).to be_present
        expect(movie.director).to eq('Christopher Nolan')
        expect(movie.rating).to eq('4')
        expect(response).to redirect_to(movies_path)
      end
    end

    context 'when TMDb finds no matching movie' do
      it 'redirects with a not-found alert' do
        stub_request(:get, 'https://api.themoviedb.org/3/search/movie')
          .with(query: hash_including({ 'query' => 'Movie That Does Not Exist' }))
          .to_return(status: 200, body: { results: [] }.to_json)

        post :search_tmdb, params: { search_terms: 'Movie That Does Not Exist' }

        expect(response).to redirect_to(movies_path)
        expect(flash[:alert]).to eq('Movie That Does Not Exist was not found in TMDb.')
      end
    end
  end
end
