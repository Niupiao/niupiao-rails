class SessionsController < ApplicationController

  wrap_parameters format: [:json, :xml, :html]

  def new
    @user = User.new
    render 'sessions/login'
  end

  def create

    username = params[:username] || params[:session][:username]
    email = params[:email] || params[:session][:email]
    password = params[:password] || params[:session][:password]
    name = params[:name] || params[:session][:name]
    first_name = params[:first_name] || params[:session][:first_name]
    last_name = params[:last_name] || params[:session][:last_name]

    respond_to do |format|
      
      # for HTML
      format.html do
        users = User.where(username: username, password: password)
        if users && users.any?
          login(users.first)
          flash[:notice] = "Welcome, #{username}!"
          redirect_to :events
        else
          flash[:notice] = 'Invalid username/password'
          render 'sessions/login'
        end        
      end

      # for JSON
      format.json do
        user = User.find_by(username: username)
        unless user
          render json: { success: false, message: "No user exists with the username: #{username}", status: :invalid_user_name }
          return
        end
        
        if authenticate(username, password)
          if user.api_key
            
            if !user.api_key.expired?
              # user's api key is still good -- no need to make a new one
              render json: { success: true, message: 'user already has api key', api_key: user.api_key, user: user }
              return
              
            else
              # user's api key is stale -- destroy the old one, make a new one
              user.api_key.destroy!
            end
          end
          
          # make a new api key
          api_key = ApiKey.new(user: user)
          if api_key.save && user.save
            render json: { success: true, message: 'created api key', api_key: api_key, user: user }
            return
          else
            render json: { success: false, message: 'could not save api key' }
            return
          end
          
        else
          render json: { success: false, message: 'Invalid password', status: :invalid_password }
          return
        end
        
      end

    end

  end

  def destroy
    logout
    render 'sessions/login'
  end

  def signup_page
  end

  def signup

    # TODO fix param wrapping
    username = params[:username] || params[:session][:username]
    email = params[:email] || params[:session][:email]
    password = params[:password] || params[:session][:password]
    name = params[:name] || params[:session][:name]
    first_name = params[:first_name] || params[:session][:first_name]
    last_name = params[:last_name] || params[:session][:last_name]
    
    respond_to do |format|

      format.json do
        if User.where(username: username).empty?
          user = User.create(email: email, username: username, password: password, name: name, first_name: first_name, last_name: last_name)
          if user.save
            api_key = user.api_key
            render json: { success: true, user: user, api_key: api_key }
          else
            render json: { success: false, message: 'could not save user after creating', status: :creation_fail }
          end
        else
          render json: { success: false, message: 'username taken', status: :username_taken }
        end
      end
      
      format.html do
        if User.where(username: username).empty?
          user = User.create(email: email, username: username, password: password, name: name, first_name: first_name, last_name: last_name)
          flash[:notice] = 'successfully signed up'
        else
          flash[:notice] = 'username taken'
        end
        render 'sessions/login'
      end
      
    end

  end


  private

  def authenticate(username, password)
    users = User.where(username: username, password: password)
    users && users.length == 1
  end
end
