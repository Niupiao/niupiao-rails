class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  include ApplicationHelper

  def render_json(json)
    puts JSON.pretty_generate(json)
    render json: json
  end
  
  def json_request?
    request.format.json?
  end
  
  def ensure_auth
    logged_in? || ensure_token
  end

  def ensure_auth_for_index
    logged_in? || ensure_token(true)
  end

  def ensure_token(json_array_request=false)
    case request.format
    when Mime::JSON
      unless authenticate_with_http_token { |token, options| @current_user = User.with_access_token(token) }
        if json_array_request
          render json: [{ error: :invalid_token }].to_json
        else
          render json: { error: :invalid_token }.to_json
        end
      end
    end
  end

end
