class Room < ApplicationRecord

  has_secure_password(validations: false)

  belongs_to :bookmaker, class_name: 'User', optional: true

  has_many :users, foreign_key: :current_room_id, dependent: :nullify
  has_many :games, dependent: :destroy

  scope :public_rooms, -> { where(password_digest: [nil, '']).where(id: User.select(:current_room_id)) }

  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :name, presence: true
  validates :code, uniqueness: true
  validates :players, presence: true, numericality: { greater_than_or_equal_to: 2, less_than_or_equal_to: 8 }

  before_create :generate_code

  def is_public?
    !self.is_private?
  end

  def is_private?
    self.password_digest.present?
  end

  def current_players_count
    users.reload.count
  end

  def iam_bookmaker?(user)
    self.bookmaker_id == user.id
  end

  def last_game_waiting_at
    self.games.last&.end_of_waiting_at
  end

  private

  def generate_code
    self.code = SecureRandom.hex(3)
    generate_code if Room.exists?(code: self.code)
  end

end
