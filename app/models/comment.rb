class Comment < ApplicationRecord
  belongs_to :micropost
  validates :micropost_id, presence: true
  validates :user_id,      presence: true
  validates :content,      presence: true
end
