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
			PastBasedRecommendation.where(user_id: params[:user_id]).destroy_all
		end
		
		redirect_to :past_filtering
	end

	def index
		@reviews = Review.all
		respond_to do |format|
		  format.html
		  format.csv { send_data @reviews.to_csv }
		end
	end

end