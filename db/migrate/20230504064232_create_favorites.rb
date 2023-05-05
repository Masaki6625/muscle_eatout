class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|

      t.integer :user_id, nill: false
      t.integer :restaurant_id, nill: false
      t.timestamps
    end
  end
end
