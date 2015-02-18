module ApplicationHelper
  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end
end
