class SessionsController < ApplicationController
  def login_page
    @user = User.new
    render 'sessions/login'
  end

  def login
    username = params[:session][:username]
    password = params[:session][:password]
    if User.where(name: username, password: password).any?
      flash[:notice] = "Welcome, #{username}!"
      redirect_to :events
    else
      flash[:notice] = 'Invalid username/password'
      render 'sessions/login'
    end
  end

  def logout
  end

  def signup_page
  end

  def signup
    if User.where(name: params[:session][:username]).empty?
      User.create(name: params[:session][:username], unix: params[:session][:unix], password: params[:session][:password])
      flash[:notice] = 'successfully signed up'
    else
      flash[:notice] = 'username taken'
    end
    render 'sessions/login'
  end
end
