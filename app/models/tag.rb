class Tag < ApplicationRecord
  has_many :restaurant_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :restaurants, through: :restaurant_tags
  validates :name, uniqueness: true, presence: true

  #タグ検索機能のransackを書いています。
  def self.ransackable_attributes(auth_object = nil)
    ["created_at","id","name","update_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["restaurant_tags", "restaurants"]
  end
end
