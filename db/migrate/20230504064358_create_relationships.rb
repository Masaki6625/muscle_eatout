class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|

      t.integer :followed_id, nill: false
      t.integer :follower_id, nill: false
      t.timestamps
    end
  end
end
