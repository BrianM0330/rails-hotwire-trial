class Like < ApplicationRecord
  belongs_to :user
  belongs_to :photo, counter_cache: true

  after_commit :broadcast_like_count, on: %i[create destroy]

  private
    def broadcast_like_count
      photo.reload
      broadcast_replace_to :photos, target: like_count_dom_id, partial: "likes/count", locals: { photo: photo }
      broadcast_replace_to photo, target: like_count_dom_id, partial: "likes/count", locals: { photo: photo }
    end

    def like_count_dom_id
      ActionView::RecordIdentifier.dom_id(photo, :like_count)
    end
end
