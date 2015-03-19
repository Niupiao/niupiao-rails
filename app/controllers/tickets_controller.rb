class TicketsController < ApplicationController

  before_action :ensure_auth, except: :index
  before_action :ensure_auth_for_index, only: :index

  before_action :get_event, only: [:new, :create, :index]

  def buy
    puts "PAARAMS: #{params.inspect}"
    # TODO finish method
    # TODO ensure auth
    render json: params
  end
  
  def new
    @event = Event.find(params[:event_id])
    @ticket = Ticket.new
    @ticket.event = @event
  end

  def create
    @ticket = Ticket.create!(ticket_params)
    respond_to do |format|
      format.html { render :create } 
      format.json { render json: @ticket }
    end
  end

  def index
    @tickets = @event.tickets

    respond_to do |format|
      format.html { render plain: @tickets.as_json.inspect }
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
        render_json(@current_user.my_tickets)
      end
    end
  end

  
  private 
  
  def get_event
    @event = Event.find(params[:event_id])
  end
  
  def ticket_params
    params.require(:ticket).permit(:user_id, :event_id, :ticket_status_id)
  end
  
  
  
end
