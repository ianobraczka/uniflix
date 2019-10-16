class AddUpdatedToColabBasedRecommendation < ActiveRecord::Migration[5.2]
  def change
    add_column :colab_based_recommendations, :updated, :date
  end
end
