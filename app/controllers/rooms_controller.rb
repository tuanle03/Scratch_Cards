class RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def create
    loop do
      # Generate a random code for the new room
      code = SecureRandom.hex(3)

      # Check if the code already exists in the database
      if !Room.exists?(code: code)
        @room = Room.new(room_params.merge(code: code))
        break
      end
    end

    if @room.save
      redirect_to room_path(@room), notice: "Room created successfully"
    else
      render :new
    end
  end

  def join
    @room = Room.find_by(code: params[:code], password: params[:password])

    if @room
      redirect_to room_path(@room), notice: "You have joined the room successfully"
    else
      redirect_to root_path, alert: "Invalid code or password"
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def leave
    @room = Room.find(params[:id])
    redirect_to root_path
  end

  private

  def room_params
    params.require(:room).permit(:name, :code, :password, :bets)
    end
end
