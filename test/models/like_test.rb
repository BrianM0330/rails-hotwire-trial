require "test_helper"

class LikeTest < ActiveSupport::TestCase
  include ActionCable::TestHelper

  test "increments photo likes_count" do
    photo = create_photo

    Like.create!(user: users(:one), photo:)

    assert_equal 1, photo.reload.likes_count
  end

  test "database rejects duplicate user photo pair" do
    photo = create_photo

    Like.create!(user: users(:one), photo:)

    assert_raises ActiveRecord::RecordNotUnique do
      Like.create!(user: users(:one), photo:)
    end
  end

  test "broadcasts like count after create and destroy" do
    photo = create_photo

    assert_broadcasts "photos", 1 do
      @like = Like.create!(user: users(:one), photo:)
    end

    assert_broadcasts "photos", 1 do
      @like.destroy!
    end
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
