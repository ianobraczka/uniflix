class BooksController < ApplicationController

	before_action :authenticate_user!

	
	def show
		@book = Book.find(params[:id])
	end

	def index
	end

	# FILTRAGEM BASEADA EM CONTEÚDO
	def query_filtering
		if params[:category] && params[:category] != "todas"
			@all = Book.where(genre: params[:category])
		else
			@all = Book.all
		end
		if params[:search] && !params[:search].empty?
			@books1 = @all.where('title ILIKE ?', "%#{params[:search]}%")
			@books2 = @all.where('author ILIKE ?', "%#{params[:search]}%")
			@books = @books1 + @books2
			@books = @books - (@books1 & @books2)
		else
			@books = @all
		end
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
