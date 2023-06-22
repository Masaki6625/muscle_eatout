class Tag < ApplicationRecord
  has_many :restaurant_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :restaurants, through: :restaurant_tags
  validates :name, uniqueness: true, presence: true

  #タグ検索機能のransackを書いています。
  #タグモデルの中で紐ずくカラムを探している
  def self.ransackable_attributes(auth_object = nil)
    ["created_at","id","name","update_at"]
  end

  #レストランとそれに紐ずくタグを探してる
  def self.ransackable_associations(auth_object = nil)
    ["restaurant_tags", "restaurants"]
  end
end
