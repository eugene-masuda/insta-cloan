class Notification < ApplicationRecord
  belongs_to :visiter, class_name: "User"
  belongs_to :visited, class_name: "User"
  belongs_to :micropost, optional: true
  validates :visiter_id, presence: true
  validates :visited_id, presence: true 
  default_scope -> { order(created_at: :desc) }    
end
