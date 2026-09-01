class FollowRequest < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requested, class_name: "User"
  validates :requester_id, uniqueness: { scope: :requested_id }
end
