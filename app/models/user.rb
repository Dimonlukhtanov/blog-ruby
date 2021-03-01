class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: { user: 0, admin: 1, moderator: 2 }
  has_many :posts, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, presence: true

  def account_active?
    ban.nil?
  end

  def active_for_authentication?
    super && account_active?
  end

  def inactive_message
    account_active? ? super : :locked
  end
end
