module Sockets
  class EventController < WebsocketRails::BaseController
    def send_invitation
      new_message = {:message => 'this is a message'}
      broadcast_message :invitation_message, new_message
    end
  end
end
