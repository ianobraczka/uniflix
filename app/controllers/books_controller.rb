class BooksController < ApplicationController

	before_action :authenticate_user!

	
	def show
		@book = Book.find(params[:id])
	end

	def index
	end

	# FILTRAGEM BASEADA EM CONTEÚDO
	def query_filtering
		@books = Book.all
	end

	# FILTRAGEM BASEADA EM FILTRO COLABORATIVO
	def collaborative_filtering
		require 'matrix'
		a = current_user.recommended_books 
		mat = Matrix[ *a ]
		@weights = mat.column(1).to_a
		recommended = mat.column(0).to_a

		all = Book.all - recommended
		@books = recommended + all
	end

	# FILTRAGEM BASEADA NO PASSADO DO USUÁRIO
	def past_filtering
		@books = Book.all
		mean = current_user.height_mean
		@books.order!("abs(books.height - #{mean})")
	end

	def liked
		@books = current_user.books
	end

	def like
		book = Book.find(params[:book_id])
		user = User.find(params[:user_id])
		Like.create(book_id: book.id, user_id: user.id)
		redirect_to book
	end

	def unlike
		book = Book.find(params[:book_id])
		user = User.find(params[:user_id])
		Like.where(book_id: book.id, user_id: user.id).destroy_all
		redirect_to :root
	end

end
