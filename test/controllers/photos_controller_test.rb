require "test_helper"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @photo = create_photo
  end

  test "index redirects unauthenticated users to sign in" do
    get photos_path

    assert_redirected_to new_session_path
  end

  test "index renders for authenticated users" do
    sign_in_as(users(:one))

    get photos_path

    assert_response :success
  end

  test "show renders for unauthenticated users" do
    get photo_path(@photo)

    assert_response :success
  end

  test "show renders for authenticated users" do
    sign_in_as(users(:one))

    get photo_path(@photo)

    assert_response :success
  end

  test "index redirects back after sign in" do
    get photos_path
    assert_redirected_to new_session_path

    post session_path, params: { email_address: users(:one).email_address, password: "password" }

    assert_redirected_to photos_url
  end

  private
    def create_photo(attributes = {})
      Photo.create!({
        pexels_id: 21_751_820,
        width: 3_888,
        height: 5_184,
        url: "https://www.pexels.com/photo/example-21751820/",
        photographer: "Felix",
        photographer_url: "https://www.pexels.com/@felix",
        photographer_id: 21_751_820,
        avg_color: "#333831",
        alt: "A small island surrounded by trees in the middle of a lake"
      }.merge(attributes))
    end
end
