class AddUpdatedToPastBasedRecommendation < ActiveRecord::Migration[5.2]
  def change
    add_column :past_based_recommendations, :updated, :date
  end
end
