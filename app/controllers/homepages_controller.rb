class HomepagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @public_rooms = Room.public_rooms
    @top_players = User.top_coins
  end
end
