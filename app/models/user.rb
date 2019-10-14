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

end
