class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :favorite_relationships, dependent: :destroy
  has_many :liked_by, through: :favorite_relationships, source: :user
  has_many :comments, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) {
    where("microposts.content LIKE :keyword", keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :image, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message: "should be less than 5MB" }
    # 表示用のりサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [200, 200])
  end
  
  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      micropost_id: id,
      visited_id: user.id,
      action: "like"
      )
    notification.save if notification.valid?
  end    
end
