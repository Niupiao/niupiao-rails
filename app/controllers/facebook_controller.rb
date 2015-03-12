class FacebookController < ApplicationController

  def create

    email = params[:email]
    first_name = params[:first_name] 
    last_name = params[:last_name]
    username = params[:username]
    
    respond_to do |format|
      format.json do

        if email
          user = User.find_by(email: email)
          if user
            # A user exists with that email. Let's link their account to their Facebook account!
            create_or_update_facebook_identity(user)
            render json: {
                     success: true,
                     status: :user_exists,
                     user: user,
                     api_key: user.api_key,
                     facebook_identity: user.facebook_identity }
          else
            # Create a new account from the Facebook params
            user = User.create(email: email, password: SecureRandom.hex(12)) do |u|
              u.name = "#{first_name} #{last_name}" if first_name && last_name
              u.first_name = first_name
              u.last_name = last_name
              u.username = username
            end
            create_or_update_facebook_identity(user)
            render json: {
                     success: true,
                     status: :user_created,
                     message: 'user created from facebook',
                     user: user,
                     api_key: user.api_key,
                     facebook_identity: user.facebook_identity
                   }
          end
        else
          render json: { success: false, message: 'must supply email' }
        end
      end
    end
  end
  
  private
  def create_or_update_facebook_identity(user)
    i = user.facebook_identity || FacebookIdentity.new
    i.birthday = params[:birthday]
    i.first_name = params[:first_name]
    i.middle_name = params[:middle_name]
    i.last_name = params[:last_name]
    i.name = params[:name]
    i.username = params[:username]
    i.location = params[:location]
    i.link = params[:link]
    i.facebook_id = params[:facebook_id]
    user.facebook_identity = i
    user.save
  end
end
