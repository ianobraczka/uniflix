class Book < ApplicationRecord

	belongs_to :category
  	has_many :likes
  	has_many :users, through: :likes

	include SimpleRecommender::Recommendable
	similar_by :users
  	
	require 'csv'
  	def self.import_table(filepath='/home/ianobraczka/datasets/books.csv')
  		CSV.foreach(filepath, headers: true) do |row|
  			book = Book.new row.to_hash
  			book.category_id = 1
  			book.save!
  		end
  	end

  	def liked?(user)
  		if user && user.likes?(self.id)
  			return true
  		else
  			return false
  		end
  	end
end
