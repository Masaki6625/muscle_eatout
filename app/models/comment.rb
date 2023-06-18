class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :restaurant
  #通知モデルに関するアソシエーション
  has_many :notifications, dependent: :destroy

  validates :comment,
  length: { minimum: 5 } , presence: true
end
