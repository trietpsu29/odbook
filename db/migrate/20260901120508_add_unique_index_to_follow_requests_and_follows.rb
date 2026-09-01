class AddUniqueIndexToFollowRequestsAndFollows < ActiveRecord::Migration[8.1]
  def change
    add_index :follow_requests,
          [ :requester_id, :requested_id ],
          unique: true

    add_index :follows,
              [ :follower_id, :followed_id ],
              unique: true
  end
end
