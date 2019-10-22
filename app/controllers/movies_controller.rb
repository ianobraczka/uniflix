class MoviesController < ApplicationController

	before_action :authenticate_user!

	
	def show
		@movie = Movie.find(params[:id])
	end

	def index
	end

	# FILTRAGEM BASEADA EM CONTEÚDO
	def content_based_filtering
		recommendations = Movie.content_based_filter(current_user)
		movies = recommendations + (Movie.all - recommendations)
		@recommendations_count = recommendations.count
		@movies = movies.first(30)
	end

	# FILTRAGEM BASEADA EM FILTRO COLABORATIVO
	def collaborative_filtering
		recommendations = Movie.collaborative_filter(current_user)
		movies = recommendations + (Movie.all - recommendations)
		@recommendations_count = recommendations.count
		@movies = movies.first(30)
	end

	# FILTRAGEM BASEADA NO PASSADO DO USUÁRIO
	def past_filtering
		recommendations = Movie.past_filter(current_user)
		movies = recommendations + (Movie.all - recommendations)
		@recommendations_count = recommendations.count
		@last_liked_movie = current_user.last_liked_movie
		@movies = movies.first(30)
	end

	def liked
		@movies = current_user.movies
	end

	def like
		book = Book.find(params[:book_id])
		user = User.find(params[:user_id])
		Like.create(book_id: book.id, user_id: user.id)
		if request.xhr?
    		head :ok
 		else
			redirect_to book
		end
	end

	def unlike
		book = Book.find(params[:book_id])
		user = User.find(params[:user_id])
		Like.where(book_id: book.id, user_id: user.id).destroy_all
		if request.xhr?
    		head :ok
 		else
			redirect_to book
		end
	end

end
