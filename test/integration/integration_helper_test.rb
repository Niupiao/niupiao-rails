module IntegrationHelperTest

  def json
    @json = JSON.parse(response.body)
  end

  def prettify(json)
    JSON.pretty_generate(json)
  end
  
  def logged_in?
    !session[:user_id].nil?
  end

  def login(user)
    post '/login', session: {
      email: user.email,
      password: user.password
    }
  end

  def logout
    delete '/logout'
  end

end
