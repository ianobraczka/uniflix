require "./lib/recommendation.rb"

class User < ApplicationRecord
    include Recommendation

	has_many :likes 
	has_many :books, through: :likes

	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
	devise :database_authenticatable, :registerable,
	    :recoverable, :rememberable, :validatable

    def likes?(book_id)
    	if self.books.include? Book.find(book_id)
    		return true
    	else
    		return false
    	end
    end

    def height_mean
        total = 0
        self.books.each do |book|
            total = total + book.height
        end
        return total/self.books.count
    end

    def recommended_books
        self.recommend_books
    end
end
