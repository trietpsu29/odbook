class Post < ApplicationRecord
  validates :title, length: { maximum: 50 }

  belongs_to :user
end
