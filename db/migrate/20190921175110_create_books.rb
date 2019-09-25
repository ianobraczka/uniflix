class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :name
      t.string :author
      t.integer :height
      t.string :publisher
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
