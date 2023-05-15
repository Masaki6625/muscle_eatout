class AddLatitudeToRestaurant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :latitude, :float
  end
end
