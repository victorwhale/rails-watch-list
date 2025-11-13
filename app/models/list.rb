class List < ApplicationRecord
  COVER_IMAGES = [
    "https://images.unsplash.com/photo-1489599849930-6eafc93422bb?auto=format&fit=crop&w=1200&q=80",
    "https://images.unsplash.com/photo-1524985069026-dd778a71c7b4?auto=format&fit=crop&w=1200&q=80",
    "https://images.unsplash.com/photo-1505685296765-3a2736de412f?auto=format&fit=crop&w=1200&q=80",
    "https://images.unsplash.com/photo-1468078809804-4c7b3e60a478?auto=format&fit=crop&w=1200&q=80",
    "https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&w=1200&q=80",
    "https://images.unsplash.com/photo-1460176449511-ff5fc8e64c35?auto=format&fit=crop&w=1200&q=80"
  ].freeze
  LEGACY_SOURCE_PREFIX = "https://source.unsplash.com/featured/?cinema,movie,film&sig=".freeze

  has_many :bookmarks, dependent: :destroy
  has_many :movies, through: :bookmarks

  before_validation :generate_slug
  before_save :set_default_image

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end

  def card_image_url
    normalized_image_url || cover_image_from_pool
  end

  private

  def generate_slug
    return if name.blank?
    return if slug.present? && !will_save_change_to_name?

    base_slug = name.parameterize(separator: '_')
    candidate = base_slug
    counter = 2

    while slug_taken?(candidate)
      candidate = "#{base_slug}_#{counter}"
      counter += 1
    end

    self.slug = candidate
  end

  def slug_taken?(candidate)
    scope = self.class.where(slug: candidate)
    scope = scope.where.not(id: id) if persisted?
    scope.exists?
  end

  def set_default_image
    return if image_url.present? && !legacy_image?(image_url)

    self.image_url = cover_image_from_pool
  end

  def cover_image_from_pool
    return COVER_IMAGES.first if COVER_IMAGES.empty?

    index = if name.present?
              name.downcase.hash % COVER_IMAGES.length
            else
              0
            end
    COVER_IMAGES[index]
  end

  def normalized_image_url
    return nil if image_url.blank?
    return nil if legacy_image?(image_url)

    image_url
  end

  def legacy_image?(url)
    url.start_with?(LEGACY_SOURCE_PREFIX)
  end
end
