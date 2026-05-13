require "test_helper"

class LandingControllerTest < ActionDispatch::IntegrationTest
  test "index is public" do
    get root_path

    assert_response :success
  end

  test "sign in link points to protected photos path" do
    get root_path

    assert_select "a[href=?]", photos_path do |links|
      assert links.any? { |link| link.text.match?(/Sign in/) }
    end
  end
end
