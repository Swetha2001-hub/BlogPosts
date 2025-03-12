class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true 
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :image  
  validates :title, presence: true
  validates :content, presence: true
 
end
