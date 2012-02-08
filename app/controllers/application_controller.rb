class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def authenticate
    authenticate_or_request_with_http_digest do |username|
      Auth::ADMIN[username]
    end
  end
end
