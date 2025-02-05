class ApplicationController < ActionController::Base
  private
    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

    def current_user?(user)
      current_user == user
    end

    helper_method :current_user?

    def require_signin
      unless current_user
        session[:intended_url] = request.url
        flash[:warning] = "Please sign in first."
        redirect_to signin_url
      end
    end
end
