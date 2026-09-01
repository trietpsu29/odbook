class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, length: { maximum: 50 }
  validates :bio, length: { maximum: 500 }

  has_many :posts, dependent: :destroy
  has_many :sent_follow_requests, class_name: "FollowRequest", foreign_key: :requester_id, dependent: :destroy
  has_many :requested_users, through: :sent_follow_requests, source: :requested

  has_many :received_follow_requests, class_name: "FollowRequest", foreign_key: :requested_id, dependent: :destroy
  has_many :requesting_users, through: :received_follow_requests, source: :requester

  has_many :following_relationships, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :following_relationships, source: :followed

  has_many :follower_relationships, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :like_relationships, class_name: "Like", foreign_key: :user_id, dependent: :destroy
  has_many :liked_posts, through: :like_relationships, source: :post

  has_many :comments, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
