class PastBasedRecommendation < ApplicationRecord
  belongs_to :user

  def self.generate(user_id, movies)
  	recommendation = self.new(user_id: user_id)
  	movies.each do |movie|
  		recommendation.movies_ids.push(movie.id)
  	end
  	recommendation.save!
  end

  def update()
  	self.movies = []
  	self.user.content_based.each do |movie|
  		self.movies.push(movie.id)
  	end
  	self.save!
  end

  def movies
  	movies_array = []
  	self.movies_ids.each do |id|
  		movie = Movie.find(id)
  		if movie
  			movies_array.push(movie)
  		end
  	end
  	return movies_array
  end

  def is_valid?
  	return true
  end

end
