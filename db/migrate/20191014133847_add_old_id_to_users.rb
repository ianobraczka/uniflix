class AddOldIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :old_id, :integer
  end
end
