class CreateColabBasedRecommendations < ActiveRecord::Migration[5.2]
  def change
    create_table :colab_based_recommendations do |t|
      t.references :user, foreign_key: true
      t.integer :movies_ids, array: true, default: []

      t.timestamps
    end
  end
end
