require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new redirects unauthenticated users to sign in" do
    get new_user_path

    assert_redirected_to login_path
  end

  test "create redirects unauthenticated users to sign in" do
    assert_no_difference -> { User.count } do
      post users_path, params: {
        user: {
          email_address: "new-user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to login_path
  end

  test "create with invalid params renders new with unprocessable entity for authenticated users" do
    sign_in_as(users(:one))

    assert_no_difference -> { User.count } do
      post users_path, params: {
        user: {
          email_address: users(:one).email_address,
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_response :unprocessable_entity
  end
end
