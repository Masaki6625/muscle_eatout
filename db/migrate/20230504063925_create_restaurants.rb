class CreateRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|

      t.integer :user_id, nill: false
      t.string :shop_name, nill: false
      t.text :introduction, nill: false
      t.timestamps
    end
  end
end
