class Category < ApplicationRecord

	has_many :movies

	def self.set_category(name)
		if self.where(name: name).empty?
			new_category = self.create!(name: name)
			return new_category.id
		else
			return self.find_by(name: name).id
		end
	end
	
end
