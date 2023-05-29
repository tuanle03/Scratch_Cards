class Game < ApplicationRecord

  WAITING_TIME = 30.seconds
  PLAY_TIME = 30.seconds

  has_many :game_players
  has_many :players, through: :game_players

  belongs_to :room, optional: true
  belongs_to :bookmaker, class_name: 'User', optional: true

  def waiting?
    end_of_waiting_at.future?
  end

  def playable?
    end_of_waiting_at.past? && end_of_playing_at.future?
  end

  def playing?
    Time.now.between?(end_of_waiting_at, end_of_playing_at)
  end

  def finished?
    end_of_playing_at.past?
  end

  def end_of_waiting_at
    self.created_at + WAITING_TIME
  end

  def end_of_playing_at
    self.created_at + WAITING_TIME + PLAY_TIME
  end

end
