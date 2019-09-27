module Recommendation
  def recommend_books # recomendar livros a um usuário
    
    # lista usuários que não o próprio usuário
    other_users = self.class.all.where.not(id: self.id)
    recommended = Hash.new(0)
    
    # para cada um destes usuários, faça:
    other_users.each do |user|
      # separe os livros em comum entre usuário em questão e outro
      common_books = user.books & self.books
      # descubra o peso dessa relação (número de livros em comum)
      weight = common_books.size.to_f / user.books.size
      # adicione o grau/peso aos livros em comum
      (user.books - common_books).each do |book|
        recommended[book] += weight
      end
    end

    # ordene pelo grau em ordem decrescente
    sorted_recommended = recommended.sort_by { |key, value| value }.reverse
    
  end
end