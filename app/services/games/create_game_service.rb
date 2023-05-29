class Games::CreateGameService

  def initialize(room)
    @room = room
  end

  def call
    @game = room.games.create(bookmaker_id: room.bookmaker_id, current_bets: room.bets)
    notify_to_all_players
    @game
  end

  private

  attr_reader :room

  def notify_to_all_players
    ::PusherClient.trigger("room-#{room.id}", "new_game", { game_id: @game.id })
  end

end
