class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  has_many :comments
  validates :title, :summary, :body, presence: true
end
