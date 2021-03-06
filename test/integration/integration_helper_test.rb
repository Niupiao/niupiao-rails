module IntegrationHelperTest

  ### AUTHORIZED REQUEST METHODS

  def auth_get(url, token, options=nil)
    get url, options, authorization: "Token token=\"#{token}\""
  end

  def auth_post(url, token, params=nil, options=nil)
    if params
      post url, params, authorization: "Token token=\"#{token}\""
    else
      post url, options, authorization: "Token token=\"#{token}\""
    end
  end

  ### JSON RESPONSE METHODS

  def json
    @json = JSON.parse(response.body)
  end

  def prettify(json)
    JSON.pretty_generate(json)
  end


  ### SESSION METHODS
  
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
