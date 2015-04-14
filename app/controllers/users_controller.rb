class UsersController < ApplicationController

  # GET /users/new
  def new
  end

  # POST /users
  def create
  end

  # GET /users
  def index
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /users/:id/edit
  def edit
  end

  # PATCH/PUT /users/:id
  def update
  end

  # DELETE /users/:id
  def destroy
  end

end
