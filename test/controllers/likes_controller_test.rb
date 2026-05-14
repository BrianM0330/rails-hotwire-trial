require "test_helper"

class LikesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @photo = create_photo
  end

  test "create redirects unauthenticated users to sign in" do
    post photo_like_path(@photo)

    assert_redirected_to login_path
  end

  test "create adds like for authenticated user" do
    sign_in_as(@user)

    assert_difference -> { @user.likes.count }, 1 do
      post photo_like_path(@photo)
    end

    assert_redirected_to photos_path
  end

  test "create replaces like button for turbo stream request" do
    sign_in_as(@user)

    assert_difference -> { @user.likes.count }, 1 do
      post photo_like_path(@photo), headers: turbo_stream_headers
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, %(<turbo-stream action="replace" target="like_photo_#{@photo.id}")
    assert_includes response.body, "Unlike photo by #{@photo.photographer}"
    assert_includes response.body, %(data-icon="star-fill")
  end

  test "create is idempotent for the same user and photo" do
    sign_in_as(@user)
    @user.likes.create!(photo: @photo)

    assert_no_difference -> { @user.likes.count } do
      post photo_like_path(@photo)
    end

    assert_redirected_to photos_path
  end

  test "destroy removes existing like for authenticated user" do
    sign_in_as(@user)
    @user.likes.create!(photo: @photo)

    assert_difference -> { @user.likes.count }, -1 do
      delete photo_like_path(@photo)
    end

    assert_redirected_to photos_path
  end

  test "destroy replaces like button for turbo stream request" do
    sign_in_as(@user)
    @user.likes.create!(photo: @photo)

    assert_difference -> { @user.likes.count }, -1 do
      delete photo_like_path(@photo), headers: turbo_stream_headers
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, %(<turbo-stream action="replace" target="like_photo_#{@photo.id}")
    assert_includes response.body, "Like photo by #{@photo.photographer}"
    assert_includes response.body, %(data-icon="star-line")
  end

  test "destroy is safe when like does not exist" do
    sign_in_as(@user)

    assert_no_difference -> { @user.likes.count } do
      delete photo_like_path(@photo)
    end

    assert_redirected_to photos_path
  end

  test "destroy redirects unauthenticated users to sign in" do
    delete photo_like_path(@photo)

    assert_redirected_to login_path
  end

  test "create raises not found for missing photo" do
    sign_in_as(@user)

    post photo_like_path(-1)

    assert_response :not_found
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

    def turbo_stream_headers
      { "Accept" => "text/vnd.turbo-stream.html", "Turbo-Frame" => "like_photo_#{@photo.id}" }
    end
end
