require "./lib/recommendation.rb"

class User < ApplicationRecord
    include Recommendation

	has_many :likes 
	has_many :books, through: :likes

    has_many :reviews
    has_many :movies, through: :reviews

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
	    :recoverable, :rememberable, :validatable

    @@content_based = []
    @@collaborative_based = []

    def self.generate
        for i in 1..670
            email = "user" + i.to_s + "@gmail.com"
            User.create!({:email => email, old_id: i, :password => "111111", :password_confirmation => "111111" })
        end
    end

    def reviewed?(movie_id)
        if self.movies.include? Movie.find(movie_id)
            return true
        else
            return false
        end
    end

    def rate(movie)
        self.reviews.find_by(movie_id: movie.id).rating
    end

    def height_mean
        total = 0
        self.books.each do |book|
            total = total + book.height
        end
        unless self.books.count == 0
            return total/self.books.count
        else
            return 0
        end
    end

    def recommended_books
        self.recommend_books
    end

    def similar_users_hash(filepath=Rails.public_path.join('pearson1.csv'))
        users = Hash.new
        target_users_array = Hash.new
        target_movies_array = Hash.new
        CSV.foreach(filepath, headers: true) do |row|
            print row
            if row['user_id'].to_i == self.id
                for i in 1..(row.size-1)
                    unless row[i].nil?
                        users[i] = row[i].gsub(",", ".").to_f
                    end
                end
            end
        end
        target_users = users.sort_by {|_key, value| value}.first(3)
    end

    def movies_to_watch
        return Movie.all - self.movies
    end

    def content_based
        ranked_hash = Hash.new
        recommendations = []
        self.movies_to_watch.each do |movie|
            movie_id = movie.id
            category_id = movie.category.id

            unless self.movies.where(category_id: category_id).empty?
            
                movie_average = movie.vote_avg
                category_average = movie.category.movies.average(:vote_avg).to_f
                
                user_category_average = 0  
                self.movies.where(category_id: category_id).each do |movie|
                    user_category_average = user_category_average + self.reviews.find_by(movie_id: movie.id).rating
                end

                user_category_average = user_category_average/self.movies.where(category_id: category_id).count

                puts "Média geral do filme: " + movie_average.to_s
                puts "Média da categoria " + movie.category.name + ": " + category_average.to_s
                puts "Média de avaliações do usuário na categoria: " + user_category_average.to_s

                rec = (movie_average*user_category_average)/category_average

                #binding.pry

                if rec > 3.5
                    puts "> 3.5 (entra na lista)"
                    recommendations << movie
                else
                    puts "< 3.5 (não entra na lista)"
                end
            end
        end

        return recommendations
    end

end
