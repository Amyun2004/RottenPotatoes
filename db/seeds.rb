# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed the RottenPotatoes DB with some movies.
movies = [{ title: 'Aladdin', rating: 'G', release_date: '1992-11-25' },
          { title: 'The Terminator', rating: 'R', release_date: '1984-10-26' },
          { title: 'When Harry Met Sally', rating: 'R', release_date: '1989-07-21' },
          { title: 'The Help', rating: 'PG-13', release_date: '2011-08-10' },
          { title: 'Chocolat', rating: 'PG-13', release_date: '2001-01-05' },
          { title: 'Amelie', rating: 'R', release_date: '2001-04-25' },
          { title: '2001: A Space Odyssey', rating: 'G', release_date: '1968-04-06' },
          { title: 'The Incredibles', rating: 'PG', release_date: '2004-11-05' },
          { title: 'Raiders of the Lost Ark', rating: 'PG', release_date: '1981-06-12' },
          { title: 'Chicken Run', rating: 'G', release_date: '2000-06-21' }]

movies.each do |movie|
  Movie.find_or_create_by!(title: movie.fetch(:title)) do |record|
    record.assign_attributes(movie)
  end
end
