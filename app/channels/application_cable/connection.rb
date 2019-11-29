module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_connection_user

    def connect
      self.current_connection_user = find_verified_user
    end

    
    protected

      def find_verified_user
        if verified_user = env['warden'].user
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
