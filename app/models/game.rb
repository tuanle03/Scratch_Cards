class Game < ApplicationRecord
  has_many :game_players
  has_many :players, through: :game_players

  belongs_to :room, optional: true

  enum status: {
    waiting: 'waiting',
    playing: 'playing',
    finished: 'finished'
  }

end
