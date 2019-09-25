module Recommendation
  def recommend_books # recommend books to a user
    
    other_users = self.class.all.where.not(id: self.id)
    recommended = Hash.new(0)
    
    other_users.each do |user|
      common_books = user.books & self.books
      weight = common_books.size.to_f / user.books.size
      (user.books - common_books).each do |movie|
        recommended[movie] += weight
      end
    end

    # sort by weight in descending order
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
    
  end
end