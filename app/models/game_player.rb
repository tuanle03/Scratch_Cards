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

  def max_value
    get_values.max
  end

  def min_value
    get_values.min
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

  def process_coins!
    case self.status
    when 'win'
      transfer_from_bookmaker!
    when 'lose'
      transfer_to_bookmaker!
    when 'draw'
      return
    end
  end

  private

  def get_values
    return [0, 0] if invalid_cards?

    left_value = self.game_player_cards.where(option: :left).sum(&:value)
    right_value = self.game_player_cards.where(option: :right).sum(&:value)

    left_is_king = self.game_player_cards.where(option: :left).all?{|i| i.card.point >= 11 }
    right_is_king = self.game_player_cards.where(option: :right).all?{|i| i.card.point >= 11 }

    left_value = left_is_king ? 11 : (left_value % 10)
    right_value = right_is_king ? 11 : (right_value % 10)

    return [left_value, right_value]
  end

  def invalid_cards?
    self.game_player_cards.group(:option).count.values != [3, 3]
  end

  def transfer_from_bookmaker!
    self.player.update!(coins: self.player.coins.to_i + self.game.current_bets.to_i)
    self.game.bookmaker.update!(coins: self.game.bookmaker.coins.to_i - self.game.current_bets.to_i)
  end

  def transfer_to_bookmaker!
    self.player.update!(coins: self.player.coins.to_i - self.game.current_bets.to_i)
    self.game.bookmaker.update!(coins: self.game.bookmaker.coins.to_i + self.game.current_bets.to_i)
  end

end
