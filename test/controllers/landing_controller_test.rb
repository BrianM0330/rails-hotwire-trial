require "test_helper"

class LandingControllerTest < ActionDispatch::IntegrationTest
  test "index is public" do
    get root_path

    assert_response :success
  end

  test "sign in link points to login path" do
    get root_path

    assert_select "a[href=?]", login_path do |links|
      assert links.any? { |link| link.text.match?(/Sign in/) }
    end
  end

  test "index is accessible to authenticated users" do
    sign_in_as(users(:one))

    get root_path

    assert_response :success
  end
end
