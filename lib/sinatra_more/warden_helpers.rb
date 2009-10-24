module SinatraMore
  module WardenHelpers
    # Returns the current authenticated user
    def current_user
      warden_handler.user
    end
    
    # Login the user through the specified warden strategy
    def authenticate_user!
      warden_handler.authenticate!
    end
    
    # Signs out the user
    def logout_user!
      warden_handler.logout
    end
    
    # Returns true if the user has authenticated
    def logged_in?
      warden_handler.authenticated?
    end
    
    # If a block is given, only yields the content if the user is authenticated
    # If no block is given, returns true if the user is logged in
    def authenticated?(&block)
      if block_given?
        authenticated_content = capture_haml(&block)
        logged_in? ? haml_concat(authenticated_content) : ''
      else
        return logged_in?
      end
    end
    
    # Forces a user to return to a fail path unless they are authorized
    # Used to require a user be authenticated before routing to an action
    def must_be_authorized!(failure_path=nil)
      redirect_to(failure_path ? failure_path : '/') unless authenticated?
    end
   
    # Returns the raw warden authentication handler
    def warden_handler
      request.env['warden']
    end
  end

  def self.registered(app)
    app.helpers WardenInitializer::Helpers

    # TODO Improve serializing
    Warden::Manager.serialize_into_session{ |user| user.nil? ? nil : user.id }
    Warden::Manager.serialize_from_session{ |id|   id.nil? ? nil : User.find(id) }

    Warden::Strategies.add(:password) do
      def valid?
        params['username'] || params['password']
      end

      def authenticate!
        u = User.authenticate(params['username'], params['password'])
        u.nil? ? fail!("Could not log in") : success!(u)
      end
    end
  end
end
