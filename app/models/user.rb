class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :current_room, class_name: 'Room', optional: true

  attribute :ready, :boolean, default: false

  scope :top_coins, -> { order(coins: :desc).limit(10) }

  before_validation :init_coins, on: :create

  def gavatar
    md5 = Digest::MD5.hexdigest(self.email)
    "https://www.gravatar.com/avatar/#{md5}"
  end

  def display_name
    self.username || self.email.split('@').first
  end

  def join_room(room_id)
    self.update!(current_room_id: room_id)
  end

  def leave_room
    self.update(current_room_id: nil)
  end

  private

  def init_coins
    self.coins = 1_000
  end

end
