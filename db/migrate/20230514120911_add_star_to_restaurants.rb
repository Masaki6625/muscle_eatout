class AddStarToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :star, :string
  end
end
