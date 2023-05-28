class RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      redirect_to room_path(@room), notice: "Room created successfully"
      current_user.join_room(@room.id)
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
    @room = Room.find_by(code: params[:code], password: params[:password])

    if @room
      current_user.join_room(@room.id)
      redirect_to room_path(@room), notice: "You have joined the room successfully"
    else
      redirect_to root_path, alert: "Invalid code or password"
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def leave
    current_user.leave_room
    @room = Room.find(params[:id])
    redirect_to root_path
  end

  def ready
    @room = Room.find(params[:id])
    last_game = @room.games.last

    last_game = @room.games.create(status: "waiting") if last_game.nil? || last_game.finished?
    if last_game.playing?
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

    last_game = @room.games.last
    if last_game&.waiting?
      GamePlayer.find_by(game: last_game, player: current_user)&.destroy
    end

    redirect_to room_path(@room)
  end

  def game
    @room = Room.find(params[:id])
    @game = @room.games.find(params[:game_id])
    @game_player = @game.game_players.find_by(player: current_user)

    ::PusherClient.trigger("room-#{@room.id}", "update", { message: 'new player' })
  end

  def game_players
    @players = User.limit(2)
    render layout: false
  end

  private

  def room_params
    params.require(:room).permit(:name, :code, :password, :bets, :players)
  end
end
