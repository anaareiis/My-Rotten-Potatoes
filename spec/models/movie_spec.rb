require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe '#movies_with_same_director' do
    let(:scorsese) { Movie.create!(title: 'Goodfellas', rating: 5, description: 'A mob movie.', release_date: '1990-09-19', director: 'Martin Scorsese') }

    it 'finds movies by the same director' do
      other_scorsese_movie = Movie.create!(title: 'Taxi Driver', rating: 5, description: 'A lonely man drives a cab.', release_date: '1976-02-08', director: 'Martin Scorsese')

      expect(scorsese.movies_with_same_director).to include(other_scorsese_movie)
    end

    it 'does not find movies by different directors' do
      different_director_movie = Movie.create!(title: 'Jaws', rating: 4, description: 'A shark terrorizes a beach town.', release_date: '1975-06-20', director: 'Steven Spielberg')

      expect(scorsese.movies_with_same_director).not_to include(different_director_movie)
    end

    it 'does not include itself' do
      expect(scorsese.movies_with_same_director).not_to include(scorsese)
    end
  end
end
