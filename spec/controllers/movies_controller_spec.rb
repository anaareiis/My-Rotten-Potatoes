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
end
