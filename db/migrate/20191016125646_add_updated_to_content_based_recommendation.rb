class AddUpdatedToContentBasedRecommendation < ActiveRecord::Migration[5.2]
  def change
    add_column :content_based_recommendations, :updated, :date
  end
end
