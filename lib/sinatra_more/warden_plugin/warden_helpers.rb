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
        return '' unless logged_in?
        authenticated_content = capture_html(&block)
        concat_content(authenticated_content)
      else
        return logged_in?
      end
    end
    
    # If a block is given, only yields the content if the user is unregistered
    # If no block is given, returns true if the user is not logged in
    def unregistered?(&block)
      if block_given?
        return '' if logged_in?
        unregistered_content = capture_html(&block)
        concat_content(unregistered_content)
      else
        return !logged_in?
      end      
    end

    # Forces a user to return to a fail path unless they are authorized
    # Used to require a user be authenticated before routing to an action
    def must_be_authorized!(failure_path=nil)
      redirect(failure_path ? failure_path : '/') unless authenticated?
    end

    # Returns the raw warden authentication handler
    def warden_handler
      request.env['warden']
    end
  end
end