class GamePlayer < ApplicationRecord

  belongs_to :game
  belongs_to :player, class_name: 'User'

  has_many :game_player_cards, dependent: :destroy
  has_many :cards, through: :game_player_cards

  def get_cards
    ignored_ids = self.game.game_players.map(&:card_ids).flatten
    random_card_ids = Card.where.not(id: ignored_ids).sample(6).pluck :id
    self.card_ids = random_card_ids
  end

  def self.create_game_player(game_player_params)
    GamePlayer.create(game_player_params)
  end

  def self.find_game_player(game_player_id)
    GamePlayer.find(game_player_id)
  end

  def self.update_game_player(game_player_id, game_player_params)
    GamePlayer.find(game_player_id).update(game_player_params)
  end

end
