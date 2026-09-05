require "test_helper"

class ProfileTest < ActionDispatch::IntegrationTest
  test "edit profile page loads" do
    user = User.create!(
      email: "test@example.com",
      password: "password",
      name: "Test User"
    )

    sign_in user

    get edit_user_path(user)

    assert_response :success
    assert_select "h2", "Edit profile"
  end
end
