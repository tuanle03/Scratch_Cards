class GamePlayerCard < ApplicationRecord
  belongs_to :game_player
  belongs_to :card

  validates :game_player, presence: true
  validates :card, presence: true

  def self.create_from_card(card, game_player)
    GamePlayerCard.create(card: card, game_player: game_player)
  end

  def value
    [self.card.point, 10].min
  end
end
