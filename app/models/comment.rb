class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :restaurant

  validates :comment,
  length: { minimum: 5 } , presence: true
end
