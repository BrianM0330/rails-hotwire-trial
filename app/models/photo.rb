class Photo < ApplicationRecord
  IMAGE_BASE_OPTIONS = { auto: "compress", cs: "tinysrgb" }.freeze

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  validates :pexels_id, presence: true, uniqueness: true
  validates :width, :height, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :url, :photographer, :photographer_url, :photographer_id, :avg_color, :alt, presence: true

  # might get used if i make a feed section
  scope :portrait, -> { where("height > width") }
  scope :landscape, -> { where("width > height") }
  scope :square, -> { where("width = height") }
  scope :by_photographer, ->(photographer_id) { where(photographer_id:) }

  def src_original
    pexels_image_url
  end

  def src_large2x
    pexels_image_url(**IMAGE_BASE_OPTIONS, dpr: 2, h: 650, w: 940)
  end

  def src_large
    pexels_image_url(**IMAGE_BASE_OPTIONS, h: 650, w: 940)
  end

  def src_medium
    pexels_image_url(**IMAGE_BASE_OPTIONS, h: 350)
  end

  def src_small
    pexels_image_url(**IMAGE_BASE_OPTIONS, h: 130)
  end

  def src_portrait
    pexels_image_url(**IMAGE_BASE_OPTIONS, fit: "crop", h: 1200, w: 800)
  end

  def src_landscape
    pexels_image_url(**IMAGE_BASE_OPTIONS, fit: "crop", h: 627, w: 1200)
  end

  def src_tiny
    pexels_image_url(**IMAGE_BASE_OPTIONS, dpr: 1, fit: "crop", h: 200, w: 280)
  end

  def srcset
    {
      src_medium => "350w",
      src_large => "940w",
      src_large2x => "1880w"
    }
  end

  private

  def pexels_image_url(**query)
    url = "https://images.pexels.com/photos/#{pexels_id}/pexels-photo-#{pexels_id}.jpeg"
    query.empty? ? url : "#{url}?#{query.to_query}"
  end
end
