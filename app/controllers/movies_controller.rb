class MoviesController < ApplicationController

	before_action :authenticate_user!

	
	def show
		@movie = Movie.find(params[:id])
	end

	def index
	end

	# FILTRAGEM BASEADA EM CONTEÚDO
	def query_filtering
		# if params[:category] && params[:category] != "todas"
		# 	@all = Book.where(genre: params[:category])
		# else
		# 	@all = Book.all
		# end
		# if params[:search] && !params[:search].empty?
		# 	@books1 = @all.where('title ILIKE ?', "%#{params[:search]}%")
		# 	@books2 = @all.where('author ILIKE ?', "%#{params[:search]}%")
		# 	@books = @books1 + @books2
		# 	@books = @books - (@books1 & @books2)
		# else
		# 	@books = @all
		# end

		@movies = Movie.where("vote_avg > ?", 3).order('RANDOM()').first(50)
	end

	# FILTRAGEM BASEADA EM FILTRO COLABORATIVO
	def collaborative_filtering
		# require 'matrix'
		# a = current_user.recommended_books 
		# mat = Matrix[ *a ]
		# @weights = mat.column(1).to_a
		# recommended = mat.column(0).to_a

		# all = Book.all - recommended
		# @books = recommended + all

		@movies = Movie.where("vote_avg > ?", 3).order('RANDOM()').first(50)
	end

	# FILTRAGEM BASEADA NO PASSADO DO USUÁRIO
	def past_filtering
		@movies = Movie.where("vote_avg > ?", 3).order('RANDOM()').first(50)
		mean = current_user.height_mean
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
