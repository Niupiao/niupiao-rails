class SessionsController < ApplicationController

  wrap_parameters format: [:json, :xml, :html]

  def new
    @user = User.new
    render 'sessions/login'
  end

  def create
    email = params[:email] || params[:session][:email]
    password = params[:password] || params[:session][:password]

    respond_to do |format|
      
      # for HTML
      format.html do
        user = authenticate(email, password)
        if user
          login(user)
          flash[:notice] = "Welcome, #{user.first_name}!"
          redirect_to :events
        else
          flash[:notice] = 'Invalid login credentials'
          render 'sessions/login'
        end        
      end

      # for JSON
      format.json do
        user = User.find_by(email: email)
        unless user
          render json: { 
            success: false, 
            message: "No user exists with the email: #{email}", 
            status: :invalid_user_name,
            full_messages: user.errors.as_json(full_messages: true)
          }
          return
        end

        user = authenticate(email, password)
        if user
          if user.api_key
            
            if !user.api_key.expired?
              # user's api key is still good -- no need to make a new one
              render json: { 
                success: true, 
                message: 'user already has api key', 
                api_key: user.api_key, 
                user: user 
              }
              return
              
            else
              # user's api key is stale -- destroy the old one, make a new one
              user.api_key.destroy!
            end
          end
          
          # make a new api key
          api_key = ApiKey.new(user: user)
          if api_key.save && user.save
            render json: { 
              success: true, 
              message: 'created api key', 
              api_key: api_key, 
              user: user 
            }
            return
          else
            render json: { 
              success: false, 
              message: 'could not save api key' 
            }
            return
          end
          
        else
          render json: { 
            success: false, 
            message: 'Invalid password', 
            status: :invalid_password 
          }
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
    email = params[:email] || params[:session][:email]
    password = params[:password] || params[:session][:password]
    first_name = params[:first_name] || params[:session][:first_name]
    last_name = params[:last_name] || params[:session][:last_name]
    
    respond_to do |format|

      format.json do
        
          user = User.create(email: email, password: password, first_name: first_name, last_name: last_name)
          if user.save
            # USER SAVED!
            render json: {
                     success: true,
                     user: user,
                     api_key: user.api_key
                   }
          else
            # USER DID NOT SAVE!
            render json: {
                     success: false,
                     message: 'Could not save user after creating',
                     status: :creation_fail,
                     full_messages: user.errors.as_json(full_messages: true),
                     messages: user.errors.as_json
                   }
          end
      end
      
      format.html do
        if User.where(email: email).empty?
          # TODO check for missing fields
          user = User.create(
                             email: email,
                             password: password,
                             first_name: first_name,
                             last_name: last_name)
          flash.now[:notice] = 'successfully signed up'
        else
          flash.now[:notice] = "You've already signed up with us!"
        end
        render 'sessions/login'
      end
      
    end

  end


  private

  def authenticate(email, password)
    User.find_by(email: email, password: password)
  end
end
