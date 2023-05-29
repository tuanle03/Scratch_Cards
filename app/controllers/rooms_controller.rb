class RoomsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:submit_game]

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.bookmaker = current_user

    if @room.save
      session[:authorized_ids] ||= []
      session[:authorized_ids] << @room.id
      current_user.join_room(@room.id)
      redirect_to room_path(@room), notice: "Room created successfully"
    else
     render(action: :new)
    end
  end

  def join
    @room = Room.find(params[:id])
    current_user.join_room(@room.id)
    redirect_to room_path(@room), notice: "You have joined the room successfully"
  end

  def join_private
    @room = Room.find_by(code: params[:code])

    if @room.authenticate(params[:password])
      session[:authorized_ids] ||= []
      session[:authorized_ids] << @room.id
      redirect_to room_path(@room), notice: "You have joined the room successfully"
    else
      redirect_to root_path, alert: "Invalid code or password"
    end
  end

  def show
    @room = Room.find(params[:id])

    if @room.is_public? || session[:authorized_ids].to_a.include?(@room.id)
      @players = @room.users
      current_user.join_room(@room.id)
      PusherClient.trigger("room-#{params[:id]}", "room_members_change", {
        html: render_to_string(partial: 'game_players', layout: false),
        players_count: "Players: #{@room.users.count} / #{@room.players}",
      })
    elsif @room.is_private? && @room.authenticate(params[:password])
      session[:authorized_ids] ||= []
      session[:authorized_ids] << @room.id
    else
      redirect_to root_path, alert: "Invalid code or password"
    end
  end

  def leave
    if current_user.current_room
      room = current_user.current_room
      current_user.leave_room

      @players = room.users
      PusherClient.trigger("room-#{room.id}", "room_members_change", {
        html: render_to_string(partial: 'game_players', layout: false),
        players_count: "Players: #{room.users.count} / #{room.players}",
      })
    end
    redirect_to root_path
  end

  def ready
    @room = Room.find(params[:id])

    if last_game.nil?
      flash[:alert] = "Game is already started, wait for the next round"
      return redirect_to room_path(@room)
    end

    # Join new Game
    game_player = GamePlayer.find_or_create_by(game: last_game, player: current_user)
    game_player.get_cards

    redirect_to game_room_path(@room, last_game)
  end

  def unready
    @room = Room.find(params[:id])

    if last_game&.waiting?
      GamePlayer.find_by(game: last_game, player: current_user)&.destroy
    end

    redirect_to room_path(@room)
  end

  def game
    @room = Room.find(params[:id])
    @game = @room.games.find(params[:game_id])
    @game_player = @game.game_players.find_by(player: current_user)

    @players = @game.players
    players_html = render_to_string(partial: 'game_players', layout: false)
    ::PusherClient.trigger("room-#{@room.id}", "new-player", { html: players_html })
  end

  def cards
    @room = Room.find(params[:id])
    @game = @room.games.find(params[:game_id])
    @game_player = @game.game_players.find_by(player: current_user)
    render layout: false
  end

  def submit_game
    @room = Room.find(params[:id])
    @game = @room.games.find(params[:game_id])

    left_card_ids = params[:left_ids]
    right_card_ids = params[:right_ids]
    Games::SubmitGameService.new(@game, current_user, left_card_ids, right_card_ids).call
  end

  def result
    @room = Room.find(params[:id])
    @game = @room.games.find(params[:game_id])
    Games::GetResultService.new(@game).call
    @bookmaker_player = @game.game_players.find_by(player: @game.bookmaker)
  end

  private

  def room_params
    params.require(:room).permit(:name, :code, :password, :bets, :players)
  end

  def last_game
    @last_game = @room.games.last

    if @room.iam_bookmaker?(current_user)
      @last_game = Games::CreateGameService.new(@room).call if @last_game.nil? || @last_game.finished?
    else # Players only
      @last_game = nil unless @last_game.waiting?
    end

    @last_game
  end
end
