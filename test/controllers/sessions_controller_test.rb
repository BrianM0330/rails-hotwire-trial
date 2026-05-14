require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "friendly auth routes" do
    assert_routing({ method: :get, path: "/login" }, controller: "sessions", action: "new")
    assert_routing({ method: :post, path: "/login" }, controller: "sessions", action: "create")
    assert_routing({ method: :delete, path: "/logout" }, controller: "sessions", action: "destroy")
  end

  test "new" do
    get login_path

    assert_response :success
    assert_select "a[href='#{signup_path}']", count: 0
    assert_select "a[href='#{new_password_path}']", count: 0
  end

  test "new redirects authenticated users to photos" do
    sign_in_as(@user)

    get login_path

    assert_redirected_to photos_path
  end

  test "create with valid credentials" do
    post login_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to photos_path
    assert cookies[:session_id]
  end

  test "create ignores attempted protected destination" do
    post photo_like_path(photos(:one))
    assert_redirected_to login_path

    post login_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to photos_path
    assert cookies[:session_id]
  end

  test "create redirects authenticated users to photos" do
    sign_in_as(@user)

    post login_path, params: { email_address: @user.email_address, password: "password" }

    assert_redirected_to photos_path
  end

  test "create with invalid credentials" do
    post login_path, params: { email_address: @user.email_address, password: "wrong" }

    assert_redirected_to login_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(@user)
    session = Current.session

    delete logout_path

    assert_redirected_to root_path
    assert_empty cookies[:session_id]
    assert_not Session.exists?(session.id)
  end
end
