class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo, counter_cache: true

  validates :body, presence: true, length: { maximum: 1_000 }
end
