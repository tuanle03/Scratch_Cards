class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many  :user_rooms
  has_many  :rooms, through: :user_rooms

  attribute :ready, :boolean, default: false

  scope :top_coins, -> { order(coins: :desc).limit(10) }

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

end
