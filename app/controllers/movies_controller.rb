class Array

  def to_activerecord_relation
    return ApplicationRecord.none if self.empty?

    clazzes = self.collect(&:class).uniq
    raise 'Array cannot be converted to ActiveRecord::Relation since it does not have same elements' if clazzes.size > 1

    clazz = clazzes.first
    raise 'Element class is not ApplicationRecord and as such cannot be converted' unless clazz.ancestors.include? ApplicationRecord

    clazz.where(id: self.collect(&:id))
  end
end

class MoviesController < ApplicationController

	before_action :authenticate_user!

	
	def show
		@movie = Movie.find(params[:id])
	end

	def index
	end

	# FILTRAGEM BASEADA EM CONTEÚDO
	def content_based_filtering
		@movies = Movie.content_based_filter(current_user).first(30)
	end

	# FILTRAGEM BASEADA EM FILTRO COLABORATIVO
	def collaborative_filtering
		@movies = Movie.collaborative_filter(current_user.id).first(30)
	end

	# FILTRAGEM BASEADA NO PASSADO DO USUÁRIO
	def past_filtering
		@movies = []
		#@movies = Movie.past_filter.order('RANDOM()').first(50)
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
