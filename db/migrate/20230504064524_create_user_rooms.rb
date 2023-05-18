class CreateUserRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :user_rooms do |t|

      t.integer :user_id, nill: false
      t.integer :room_id, nill: false
      t.timestamps
    end
  end
end
