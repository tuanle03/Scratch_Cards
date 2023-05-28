class Room < ApplicationRecord
  has_many :users, foreign_key: :current_room_id, dependent: :nullify
  has_many :games, dependent: :destroy

  scope :public_rooms, -> { where(password: [nil, ""]) }

  validates :name, presence: true
  validates :code, uniqueness: true
  validates :players, presence: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 8 }

  before_create :generate_code

  def current_players_count
    users.reload.count
  end

  private

  def generate_code
    self.code = SecureRandom.hex(3)
    generate_code if Room.exists?(code: self.code)
  end

end
