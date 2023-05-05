class CreateRestaurantTags < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_tags do |t|

      t.integer :restaurant_id, nill: false
      t.integer :tag_id, nill: false
      t.timestamps
    end
  end
end
