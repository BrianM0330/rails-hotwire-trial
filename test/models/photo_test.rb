require "test_helper"

class PhotoTest < ActiveSupport::TestCase
  PEXELS_BASE_URL = "https://images.pexels.com/photos/21751820/pexels-photo-21751820.jpeg"

  test "generates pexels image URLs from pexels_id" do
    photo = build_photo(pexels_id: 21_751_820)

    assert_equal PEXELS_BASE_URL, photo.src_original
    assert_equal "#{PEXELS_BASE_URL}?auto=compress&cs=tinysrgb&h=650&w=940", photo.src_large
    assert_equal "#{PEXELS_BASE_URL}?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940", photo.src_large2x
    assert_equal "#{PEXELS_BASE_URL}?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200", photo.src_landscape
  end

  test "model-based srcset returns width descriptors for gallery rendering" do
    photo = build_photo(pexels_id: 21_751_820)

    assert_equal(
      {
        photo.src_medium => "350w",
        photo.src_large => "940w",
        photo.src_large2x => "1880w"
      },
      photo.srcset
    )
  end

  test "orientation scopes use dimensions" do
    portrait = create_photo(pexels_id: 21_751_820, width: 3_888, height: 5_184)
    landscape = create_photo(pexels_id: 21_405_575, width: 5_284, height: 3_514)

    assert_includes Photo.portrait, portrait
    assert_not_includes Photo.portrait, landscape
    assert_includes Photo.landscape, landscape
    assert_not_includes Photo.landscape, portrait
  end

  private

  def build_photo(attributes = {})
    Photo.new({
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

  def create_photo(attributes = {})
    build_photo(attributes).tap(&:save!)
  end
end
