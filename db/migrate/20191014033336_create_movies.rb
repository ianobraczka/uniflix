class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :old_id
      t.string :title
      t.string :date
      t.string :poster_path
      t.float :vote_avg
      t.integer :vote_count
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
