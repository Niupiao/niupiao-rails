class TicketsController < ApplicationController

  before_action :ensure_auth, except: :index
  before_action :ensure_auth_for_index, only: :index

  def new
    @ticket = Ticket.new
  end

  def index
    event = Event.find_by(id: params[:event_id])
    @tickets = event.tickets

    respond_to do |format|
      format.json do
        render json: @tickets
      end
    end
  end

  def my_tickets
    respond_to do |format|
      format.json do
        render json: @current_user.my_tickets
      end
    end
  end
  
  
end
