require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "has many posts association" do
    association = User.reflect_on_association(:posts)

    assert_equal :has_many, association.macro
  end
end
