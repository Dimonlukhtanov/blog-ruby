class Post < ApplicationRecord
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :comments, dependent: :restrict_with_exception
  validates :title, :summary, :body, presence: true
end
