class Games::SubmitGameService

  def initialize(game, player, left_card_ids, right_card_ids)
    @game = game
    @player = player
    @left_card_ids = left_card_ids.map(&:to_i)
    @right_card_ids = right_card_ids.map(&:to_i)
  end

  def call
    game_player = GamePlayer.find_by(game: game, player: player)
    game_player.game_player_cards.each do |game_player_card|
      option = game_player_card.card_id.in?(left_card_ids) ? :left : :right
      game_player_card.update!(option: option)
    end
  end

  private

  attr_reader :game, :player, :left_card_ids, :right_card_ids

end
