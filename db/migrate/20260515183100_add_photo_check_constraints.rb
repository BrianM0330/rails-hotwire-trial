class AddPhotoCheckConstraints < ActiveRecord::Migration[8.1]
  def change
    add_check_constraint :photos, "pexels_id > 0", name: "photos_pexels_id_positive"
    add_check_constraint :photos, "width > 0", name: "photos_width_positive"
    add_check_constraint :photos, "height > 0", name: "photos_height_positive"
    add_check_constraint :photos, "photographer_id > 0", name: "photos_photographer_id_positive"
    add_check_constraint :photos, "likes_count >= 0", name: "photos_likes_count_non_negative"
    add_check_constraint :photos, "comments_count >= 0", name: "photos_comments_count_non_negative"
  end
end
