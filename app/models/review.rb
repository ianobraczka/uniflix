class Review < ApplicationRecord

	belongs_to :user
	belongs_to :movie

	require 'csv'
	def self.generate(filepath=Rails.public_path.join('ratings_sample.csv'))
		CSV.foreach(filepath, headers: true) do |row|
			user_id = row['userId'].to_i
			movie_id = row['movieId'].to_i
			rating = row['rating'].to_i
			review = Review.new(rating: rating)
			review.user = User.find_by(old_id: user_id)
			review.movie = Movie.find_by(old_id: movie_id)
			counter = 0
			if review.movie.nil? || review.user.nil?
				counter=counter+1
			else
				review.save!
			end
			print counter
  		end
	end

end
