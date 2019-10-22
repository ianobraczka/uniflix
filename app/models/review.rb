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

	def self.to_csv(options = {})
		array = ["movie_id", "category_id"]
		for i in 1..User.count-1
			array << i
		end
		CSV.generate(options) do |csv|
		    csv << array
		    Movie.all.each do |movie|
		    	reviews_array = [movie.id, movie.category.id]
		    	for user in User.all
		    		if user.reviewed?(movie.id)
		    			reviews_array << Review.where(user_id: user.id).where(movie_id: movie.id).first.rating
		    		else
		    			reviews_array << ""
		    		end
		    	end
		      	csv << reviews_array
		    end
		end
	end

	def self.count_interception(movieA, movieB)
		(movieA.users & movieB.users).count
	end	

end
