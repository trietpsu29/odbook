class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }

  has_many :likes, class_name: "Like", foreign_key: :post_id, dependent: :destroy
  has_many :likers, through: :like_relationships, source: :user
  has_many :comments, dependent: :destroy

  has_many_attached :images
  belongs_to :user
end
