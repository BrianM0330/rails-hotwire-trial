require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "increments photo comments_count" do
    photo = create_photo

    Comment.create!(user: users(:one), photo:, body: "Beautiful shot.")

    assert_equal 1, photo.reload.comments_count
  end

  test "requires body" do
    comment = Comment.new(user: users(:one), photo: create_photo, body: "")

    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "allows multiple comments from same user on same photo" do
    photo = create_photo

    Comment.create!(user: users(:one), photo:, body: "First.")
    Comment.create!(user: users(:one), photo:, body: "Second.")

    assert_equal 2, photo.reload.comments_count
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
