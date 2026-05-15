require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "new is public" do
    get new_user_path

    assert_response :success
    assert_select "h2", "Sign Up"
  end

  test "create signs up and authenticates public users" do
    assert_difference -> { User.count }, 1 do
      post users_path, params: {
        user: {
          email_address: "new-user@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to photos_path
    assert cookies[:session_id]
  end

  test "create with invalid params renders new with unprocessable entity" do
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
