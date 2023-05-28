class Card < ApplicationRecord

  def image_name
    "cards/#{self.name}.png"
  end

end
