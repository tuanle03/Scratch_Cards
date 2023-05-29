class Games::GetResultService

  def initialize(game)
    @game = game
  end

  def call
    game_players.each do |game_player|
      status = compare_cards(game_player, game_bookmaker)
      game_player.update!(status: status)
      game_player.process_coins!
    end
  end

  private

  attr_reader :game

  def game_bookmaker
    @game_bookmaker ||= game.game_players.find_by(player: game.bookmaker)
  end

  def game_players
    game.game_players.where.not(player: game.bookmaker)
  end

  def compare_cards(player, bookmaker)
    return 'draw' if is_draw?(player, bookmaker)
    return is_win?(player, bookmaker) ? 'win' : 'lose'
  end

  def is_draw?(player, bookmaker)
    return true if [player.max_value, player.min_value] == [bookmaker.max_value, bookmaker.min_value]
    return true if player.max_value > bookmaker.max_value && player.min_value < bookmaker.min_value
    return true if player.max_value < bookmaker.max_value && player.min_value > bookmaker.min_value

    return false
  end

  def is_win?(player, bookmaker)
    player.max_value >= bookmaker.max_value && player.min_value >= bookmaker.min_value
  end
end
