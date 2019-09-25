class EnableIntArrayExtension < ActiveRecord::Migration[5.2]
  def change
    enable_extension "intarray"
  end
end
