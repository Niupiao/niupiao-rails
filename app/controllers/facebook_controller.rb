class FacebookController < ApplicationController

  def create
    respond_to do |format|
      format.json do
        user_id = params[:user_id]

        if user_id
          user = User.find_by(id: params[:user_id])
          if user
            # A user exists with that user_id. Let's link their account to their Facebook account!
            # TODO update facebook params - create_facebook_identity
            render json: { success: true, user: user, api_key: user.api_key }
          else
            # No user exists with that user_id.
            # TODO create a new account from the Facebook params,
            # as long as the Facebook account is not linked to an extant account
            # u = User.makeFromFacebookParams(params)
            render json: { success: true, message: 'user created from facebook' }
          end
        else
          render json: { success: false, message: 'must supply user_id' }
        end
      end
    end
  end
  
  private
  def create_facebook_identity
    user = User.find_by(id: params[:user_id])
    if user
      i = user.facebook_identity || FacebookIdentity.new
      i.birthday = params[:birthday]
      i.first_name = params[:first_name]
      i.middle_name = params[:middle_name]
      i.last_name = params[:last_name]
      i.name = params[:name]
      i.username = params[:username]
      i.location = params[:location]
      i.link = params[:facebook_id]
      user.facebook_identity = i
      user.save
    end
  end
end
