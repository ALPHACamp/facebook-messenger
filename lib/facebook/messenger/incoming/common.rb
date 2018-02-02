module Facebook
  module Messenger
    module Incoming
      # Common attributes for all incoming data from Facebook.
      module Common
        attr_reader :messaging

        def initialize(messaging)
          @messaging = messaging
        end

        def sender
          @messaging['sender']
        end

        def recipient
          @messaging['recipient']
        end

        # https://developers.facebook.com/docs/messenger-platform/discovery/checkbox-plugin
        # If the user responds to your message, the appropriate event (messages, messaging_postbacks, etc.) 
        # will be sent to your webhook, with a prior_message object appended. The prior_message object includes 
        # the source of the message the user is responding to, as well as the user_ref used for the 
        # original message send.
        def prior_message
          @messaging['prior_message']
        end

        def sent_at
          Time.at(@messaging['timestamp'] / 1000)
        end

        def typing_on
          payload = {
            recipient: sender,
            sender_action: 'typing_on'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def typing_off
          payload = {
            recipient: sender,
            sender_action: 'typing_off'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def mark_seen
          payload = {
            recipient: sender,
            sender_action: 'mark_seen'
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def reply(message)
          payload = {
            recipient: sender,
            message: message,
            message_type: Facebook::Messenger::Bot::MessageType::RESPONSE
          }

          Facebook::Messenger::Bot.deliver(payload, access_token: access_token)
        end

        def access_token
          Facebook::Messenger.config.provider.access_token_for(recipient)
        end
      end
    end
  end
end
