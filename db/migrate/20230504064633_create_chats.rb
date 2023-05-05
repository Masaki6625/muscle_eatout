class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|

      t.integer :user_id, nill: false
      t.integer :room_id, nill: false
      t.text :message, nill: false
      t.timestamps
    end
  end
end
