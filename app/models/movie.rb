class Movie < ApplicationRecord
	
	belongs_to :category
	has_many :reviews
	has_many :users, through: :reviews

	require 'csv'


	# -----------------------------------------------------------------------
	# FILTERING

	def self.collaborative_filter(user)
		return user.colab_based
	end

	def self.content_based_filter(user)
		return user.content_based
	end

	# implementar
	def self.past_filter
		return self.where("vote_avg > ?", 3.5)
	end
		
	# -----------------------------------------------------------------------

	def self.generate(filepath=Rails.public_path.join('movies.csv'))
		CSV.foreach(filepath, headers: true) do |row|
			old_id = row['id'].to_i
			title = row['title']
			date = row['release_date']
			poster_path = row['poster_path']
			vote_avg = row['vote_average'].to_f
			vote_count = row['vote_count'].to_i
			if row['genres'] == "[]"
				category_id = Category.set_category("Undefined")
			else
				category_id = Category.set_category(row['genres'].split("name': '")[1].split("'}")[0])
			end
			movie = Movie.new(old_id: old_id, title: title, date: date, poster_path: poster_path, vote_avg: vote_avg, vote_count: vote_count, category_id: category_id)
			movie.save!
		end
	end

	def self.update_averages
		self.where.not(vote_avg: 0.0).each do |movie|
			unless movie.reviews.count == 0
				movie.vote_avg = movie.reviews.sum(:rating).to_f/movie.reviews.count.to_f
				movie.vote_count = movie.reviews.count
				movie.save!
			else
				movie.vote_avg = 0
				movie.vote_count = 0
				movie.save!
			end
		end
	end

	def self.destroy_useless
		self.where(vote_count: 0).each do |movie|
			if movie.reviews.empty?
				movie.destroy!
			end
		end
	end

	def reviewed?(user)
		if user && user.reviewed?(self.id)
			return true
		else
			return false
		end
	end

	def image
		if poster_path
			return ("https://image.tmdb.org/t/p/w500" + poster_path)
		else
			return "https://dentalmedsul.fbitsstatic.net/img/p/produto-nao-possui-foto-no-momento/sem-foto.jpg?w=420&h=420&v=no-change"
		end
	end

	def update_ratings
		self.vote_count = self.reviews.count
		self.vote_avg = self.reviews.sum(:rating).to_f/self.reviews.count.to_f
		self.save!
	end
			
end
