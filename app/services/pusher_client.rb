require 'pusher'

class PusherClient

  def self.trigger(channel, event, data)
    client.trigger(channel, event, data)
  end

  private

  def self.client
    Pusher::Client.new({
      app_id: '1608753',
      key: '6a99040438a45cf9bf25',
      secret: '9e89e1143f962fcc5751',
      cluster: 'ap1',
      encrypted: true
    })
  end

end
