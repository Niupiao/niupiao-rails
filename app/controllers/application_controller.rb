class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  def ensure_auth
    logged_in? || ensure_token
  end

  def ensure_auth_for_index
    logged_in? || ensure_token(true)
  end

  def ensure_token(json_array_request=false)
    case request.format
    when Mime::JSON
      unless authenticate_with_http_token { |token, options| User.with_access_token(token) }
        if json_array_request
          render json: [{ error: :invalid_token }].to_json
        else
          render json: { error: :invalid_token }.to_json
        end
      end
    end
  end

end
