class ApplicationController < ActionController::Base
  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

    def require_signin
      unless current_user
        flash[:warning] = "Please sign in first."
        redirect_to signin_url
      end
    end
end
