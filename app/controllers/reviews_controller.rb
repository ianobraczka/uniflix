class ReviewsController < ApplicationController

	before_action :authenticate_user!

	def review
		review = Review.new

		movie = Movie.find(params[:movie_id])

		review.rating = params[:rating].to_i
		review.user = User.find(params[:user_id])
		review.movie = movie

		if review.save!
			movie.update_ratings
		end
		
		redirect_to :root
	end

end