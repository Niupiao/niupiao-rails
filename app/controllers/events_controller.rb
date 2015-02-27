class EventsController < ApplicationController

  before_action :ensure_auth, except: :index
  before_action :ensure_auth_for_index, only: :index

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)
    render :index
  end

  def destroy
    event = Event.find(params[:id])
    event.destroy!
    render :index
  end

  def index
    @events = Event.all
    respond_to do |format|
      format.html
      format.json do
        render json: @events
      end
    end
  end

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.json do
        render json: @event
      end
    end
  end

  
  private
  def event_params
    params.require(:event).permit(:name, 
                                  :organizer,
                                  :date,
                                  :location,
                                  :description,
                                  :image_path,
                                  :link,
                                  :total_tickets,
                                  :tickets_sold
                                  )
  end

end
