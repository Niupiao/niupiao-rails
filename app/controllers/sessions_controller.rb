class SessionsController < ApplicationController

  wrap_parameters format: [:json, :xml, :html]

  def new
    @user = User.new
    render 'sessions/login'
  end

  def create
    puts "params: #{params}"
    username = params[:username] || params[:session][:username]
    password = params[:password] || params[:session][:password]

    respond_to do |format|
      
      # for HTML
      format.html do
        puts "Looking for user with username (#{username}) and password (#{password})"
        users = User.where(name: username, password: password)
        puts "Found: #{users.inspect}"
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
        user = User.find_by(name: username)
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
    name = params[:username] || params[:session][:username]
    unix = params[:unix] || params[:session][:unix]
    password = params[:password] || params[:session][:password]

    respond_to do |format|

      format.json do
        if User.where(name: name).empty?
          user = User.create(name: name, unix: unix, password: password)
          if user.save
            api_key = user.api_key
            render json: { user: user, api_key: api_key }
          else
            render json: { error: :creation_fail, message: 'could not save user after creating' }
          end
        else
          render json: { error: :username_taken, message: 'username taken' }
        end
      end
      
      format.html do
        if User.where(name: params[:session][:username]).empty?
          User.create(name: name, unix: unix, password: password)
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
    users = User.where(name: username, password: password)
    users && users.length == 1
  end
end
