class Book < ApplicationRecord

	belongs_to :category
  	has_many :likes
  	has_many :users, through: :likes

	include SimpleRecommender::Recommendable
	similar_by :users

  def self.signal_processing
    Book.where(genre: 'horror' )
  end

  def self.data_science
    Book.where(genre: 'horror' )
  end

  def self.mathematics
    Book.where(genre: 'horror' )
  end

  def self.economics
    Book.where(genre: 'horror' )
  end

  def self.history
    Book.where(genre: 'horror' )
  end

  def self.science
    Book.where(genre: 'horror' )
  end

  def self.psychology
    Book.where(genre: 'horror' )
  end

  def self.fiction
    Book.where(genre: 'horror' )
  end

  def self.computer_science
    Book.where(genre: 'horror' )
  end

  def self.philosophy
    Book.where(genre: 'horror' )
  end

  def self.nonfiction
    Book.where(genre: 'horror' )
  end

  def self.comic
    Book.where(genre: 'horror' )
  end
  	
	require 'csv'
  	def self.import_table(filepath=Rails.public_path.join('books.csv'))
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
