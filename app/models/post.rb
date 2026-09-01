class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }

  has_many :like_relationships, class_name: "Like", foreign_key: :post_id, dependent: :destroy
  has_many :likers, through: :like_relationships, source: :user

  belongs_to :user
end
