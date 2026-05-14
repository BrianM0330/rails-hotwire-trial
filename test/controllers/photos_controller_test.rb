require "test_helper"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @photo = create_photo
  end

  test "index redirects unauthenticated users to sign in" do
    get photos_path

    assert_redirected_to login_path
  end

  test "index renders for authenticated users" do
    sign_in_as(users(:one))

    get photos_path

    assert_response :success
    assert_select "h1", "All Photos"
    assert_select "p", text: "Premium Gallery Access", count: 0
    assert_select "img.blur-xl", count: 0
    assert_select "a[href='#{photo_path(@photo)}']", minimum: 1
  end

  test "show redirects unauthenticated users to sign in" do
    get photo_path(@photo)

    assert_redirected_to login_path
  end

  test "show renders for authenticated users" do
    sign_in_as(users(:one))

    get photo_path(@photo)

    assert_response :success
    assert_select "h2", text: "Premium Gallery Access", count: 0
    assert_select "img.blur-xl", count: 0
  end

  test "index renders an empty state when no photos exist" do
    sign_in_as(users(:one))

    Comment.delete_all
    Like.delete_all
    Photo.delete_all

    get photos_path

    assert_response :success
    assert_select "h2", "No photos yet"
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
