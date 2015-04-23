class ManagersController < ApplicationController
  
  def show
    @manager = Manager.find(params[:id])
  end
  
  def new
    @manager = Manager.new
  end
  
  def create
    @manager = Manager.new(manager_params)
    if @manager.save
      flash[:success] = "Welcome to NiuPiao!"
      redirect_to @manager
    else
      render 'new'
    end
  end
  
  private
  def manager_params
    params.require(:manager).permit(:organization, 
                                  :email,
                                  :password,
                                  :password_confirmation
                                  )
  end
end
