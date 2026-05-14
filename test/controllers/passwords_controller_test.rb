require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_password_path
    assert_redirected_to login_path
  end

  test "create" do
    assert_no_enqueued_emails do
      post passwords_path, params: { email_address: @user.email_address }
      assert_redirected_to login_path
    end
  end

  test "create for an unknown user redirects but sends no mail" do
    assert_no_enqueued_emails do
      post passwords_path, params: { email_address: "missing-user@example.com" }
      assert_redirected_to login_path
    end
  end

  test "edit" do
    get edit_password_path(@user.password_reset_token)
    assert_redirected_to login_path
  end

  test "edit with invalid password reset token" do
    get edit_password_path("invalid token")
    assert_redirected_to login_path
  end

  test "update" do
    assert_no_changes -> { @user.reload.password_digest } do
      put password_path(@user.password_reset_token), params: { password: "new", password_confirmation: "new" }
      assert_redirected_to login_path
    end
  end

  test "update destroys existing sessions" do
    @user.sessions.create!

    assert_no_difference -> { @user.sessions.count } do
      put password_path(@user.password_reset_token), params: { password: "new", password_confirmation: "new" }
      assert_redirected_to login_path
    end
  end

  test "update with non matching passwords" do
    token = @user.password_reset_token
    assert_no_changes -> { @user.reload.password_digest } do
      put password_path(token), params: { password: "no", password_confirmation: "match" }
      assert_redirected_to login_path
    end
  end
end
