module IntegrationHelperTest

  def logged_in?
    !session[:user_id].nil?
  end

  def login(user)
    post '/login', session: {
      username: user.name,
      password: user.password
    }
  end

  def logout
    delete '/logout'
  end

end
