class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :favorite_relationships, dependent: :destroy
  has_many :likes, through: :favorite_relationships, source: :micropost
  has_many :comments, dependent: :destroy
  attr_accessor :remember_token
  before_save :downcase_email 
  validates :full_name, presence: true, length: { maximum:  50 }
  validates :user_name, presence: true, length: { maximum:  50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,     presence: true, length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                        uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
   # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end
  

  # マイクロポストをお気に入りに登録する
  def like(micropost)
    Like.create!(user_id: self.id, micropost_id: micropost.id)
  end

  # マイクロポストをお気に入り解除する
  def unlike(micropost)
    Like.find_by(user_id: self.id, micropost_id: micropost.id).destroy
  end

  # 現在のユーザーがお気に入り登録してたらtrueを返す
  def like?(micropost)
    !Like.find_by(user_id: self.id, micropost_id: micropost.id).nil?
  end
   # マイクロポストをライクする
  def like(micropost)
    likes << micropost
  end

  # マイクロポストをライク解除する
  def unlike(micropost)
    favorite_relationships.find_by(micropost_id: micropost.id).destroy
  end

  # 現在のユーザーがライクしていたらtrueを返す
  def likes?(micropost)
    likes.include?(micropost)

  end
  
  # フォロー通知のメソッド
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",
                              current_user.id, self.id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.build(
                     visited_id: self.id, action: 'follow')
      notification.save if notification.valid?
    end
  end
  
  def self.from_omniauth(auth)
    user = User.where('email = ?', auth.info.email).first
    if user.blank?
       user = User.new
    end
    user.uid = auth.uid
    user.user_name = auth.info.name
    user.email = auth.info.email
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user
  end
  
  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email = email.downcase
  end
end
