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

    def name
        return self.email.split("@").first
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

    def movies_to_watch
        return Movie.all - self.movies
    end

    def liked_movies
        movies = []
        self.reviews.each do |review|
            if review.rating >= 3
                movies.push(review.movie)
            end
        end
        return movies
    end

    def last_liked_movie
        unless self.reviews.empty?
            return Movie.find(self.reviews.where("rating >= ?", 3).order(created_at: :desc).first.movie_id)
        end
    end

    # metodo para ler usuarios mais proximos (distancia = 1 - pearson)
    def similar_users_hash(filepath=Rails.public_path.join('pearson-result.csv'))
        users = Hash.new
        CSV.foreach(filepath, headers: true, :col_sep => ";") do |row|
            print row
            if row['user_id'].to_i == self.id
                for i in 1..(row.size-1)
                    if i != self.id
                        unless row[i].nil?
                            users[i] = row[i].gsub(",", ".").to_f
                        end
                    end
                end
            end
        end
        target_users = users.sort_by {|_key, value| value}.first(3)

        #binding.pry

        return target_users
    end

    def get_colab_based
        user = self
        user_id = self.id
        target_users = User.find(user_id).similar_users_hash
        
        pearson_sum = 0
        target_movies = []

        puts "Os usuários selecionados pela proximidade com o usuário corrente foram: "
        target_users.each do |u|
            unless u[0] == "0"
                puts User.find(u[0]).email
                pearson_sum = pearson_sum + (1-u[1])
                puts "somando pearsons: " + pearson_sum.to_s
                target_movies = target_movies + (User.find(u[0]).movies.all - user.movies)
            end
        end

        target_movies = target_movies.select{|movie| movie.vote_avg > 3.5}

        final_target_movies = []

        puts "Os filmes avaliados pelos usuários-alvo e ainda não avaliados pelo usuário corrente foram: "
        target_movies.each do |movie|
            
            delta = 0
            users = []

            target_users.each do |tu|
                users << User.find(tu[0])
                if User.find(tu[0]).movies.include?(movie)
                    review = Review.find_by(user_id: User.find(tu[0]), movie_id: movie.id)
                    delta = delta + (1-tu[1])*(review.rating - movie.vote_avg)
                end
            end

            puts movie.title.upcase
            puts "Média de avaliações de " + movie.title + "(id " + movie.id.to_s + "): " + user.movies.average(:rating).to_f.to_s
        
            puts "Delta: " + delta.to_s
            puts "Somatório dos valores de Pearson: " + pearson_sum.to_s

            rec = user.reviews.average(:rating).to_f + ((delta)/pearson_sum)
            puts "Resultado (nota esperada para o usuário: " + rec.to_s

            if rec > 3.5 && !(users - movie.users).empty?
                puts "> 3.5 (entra na lista)"
                final_target_movies << movie
            else
                puts "< 3.5 (não entra na lista)"
            end
        end
    end

    def get_content_based
        ranked_hash = Hash.new
        recommendations = []
        to_watch = self.movies_to_watch.select{|movie| movie.vote_avg > 3.5}
        to_watch.each do |movie|
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

                puts "Média geral do filme: " + movie.title + " (id " + movie.id.to_s + "): " + movie_average.to_s
                puts "Média da categoria " + movie.category.name + ": " + category_average.to_s
                puts "Média de avaliações do usuário na categoria: " + user_category_average.to_s

                rec = (movie_average*user_category_average)/category_average

                puts "Nota esperada para o usuário: " + rec.to_s

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

    def get_past_based

        user = self
        user_id = self.id
        target_users = User.find(user_id).similar_users_hash

        target_movies = []

        puts "Os usuários selecionados pela proximidade com o usuário corrente foram: "
        target_users.each do |u|
            unless u[0] == "0"
                puts User.find(u[0]).email
                target_movies = target_movies + (User.find(u[0]).movies.all - user.movies)
            end
        end

        target_movies = target_movies.select{|movie| movie.vote_avg > 3.5}

        recommendations = []

        liked_movie = self.last_liked_movie

        target_movies.each do |target_movie|
            suporte = ( liked_movie.reviews.count.to_f/target_movie.reviews.count.to_f ) * 100
            puts "Suporte=" + suporte.to_s + "%"

            confianca  = ( Review.count_interception(liked_movie, target_movie)/target_movie.reviews.where("rating >= ?", 3).count.to_f ) * 100
            puts "Confiança=" + confianca.to_s + "%"

            if suporte > 30 && confianca > 70
                puts "entra na lista"
                recommendations << target_movie
            end

        end

        return recommendations.uniq
    end

    def colab_based
        recommendation = ColabBasedRecommendation.find_by(user_id: self.id)
        if recommendation
            if recommendation.is_valid?
                return recommendation.movies
            else
                recommendation.update
                return recommendation.movies
            end
        else
            cb = self.get_colab_based
            ColabBasedRecommendation.generate(self.id, cb)
            return cb
        end
    end

    def content_based
        recommendation = ContentBasedRecommendation.find_by(user_id: self.id)
        if recommendation
            if recommendation.is_valid?
                return recommendation.movies
            else
                recommendation.update
                return recommendation.movies
            end
        else
            cb = self.get_content_based
            ContentBasedRecommendation.generate(self.id, cb)
            return cb
        end
    end

    def past_based
        recommendation = PastBasedRecommendation.find_by(user_id: self.id)
        if recommendation
            if recommendation.is_valid?
                return recommendation.movies
            else
                recommendation.update
                return recommendation.movies
            end
        else
            pb = self.get_past_based
            PastBasedRecommendation.generate(self.id, pb)
            return pb
        end
    end

    def self.flush_recommendations
        PastBasedRecommendation.destroy_all
        ContentBasedRecommendation.destroy_all
        ColabBasedRecommendation.destroy_all
    end

end
