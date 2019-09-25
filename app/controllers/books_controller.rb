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
		@books = current_user.recommended_books
	end

	# FILTRAGEM BASEADA NO PASSADO DO USUÁRIO
	def past_filtering
		@books = Book.all
		mean = current_user.height_mean
		@books.order!("abs(books.height - #{mean})")
	end

	def like
		book = Book.find(params[:book_id])
		user = User.find(params[:user_id])
		Like.create(book_id: book.id, user_id: user.id)
		redirect_to :root
	end

	def unlike
		book = Book.find(params[:book_id])
		user = User.find(params[:user_id])
		Like.where(book_id: book.id, user_id: user.id).destroy_all
		redirect_to :root
	end

end
