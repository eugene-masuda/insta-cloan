class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :favorite_relationships, dependent: :destroy
  has_many :liked_by, through: :favorite_relationships, source: :user
  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) {
    where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  has_many :comments, dependent: :destroy
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
    # 表示用のりサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
