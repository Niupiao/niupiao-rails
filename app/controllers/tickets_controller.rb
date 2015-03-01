class TicketsController < ApplicationController

  before_action :ensure_auth, except: :index
  before_action :ensure_auth_for_index, only: :index

  before_action :get_event, only: [:new, :create, :index]

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = Ticket.create!(ticket_params)
    render :create
  end

  def index
    @tickets = @event.tickets

    respond_to do |format|
      format.json do
        render json: @tickets
      end
    end
  end

  def update
    @ticket = Ticket.find(params[:id])
    @event = Event.find(@ticket.event_id)
  end

  def my_tickets
    respond_to do |format|
      format.json do
        render json: @current_user.my_tickets
      end
    end
  end

  
  private 
  
  def get_event
    @event = Event.find(params[:event_id])
  end
  
  def ticket_params
    params.require(:ticket).permit(:user_id, :event_id, :price, :status)
  end
  
  
  
end
