class EventsController < ApplicationController

  before_action :ensure_auth, except: :index
  before_action :ensure_auth_for_index, only: :index

  def new
    @event = Event.new
  end

  def create
    @event = Event.create(event_params)
    respond_to do |format|
      format.html { render :index }
      format.json do
        if @event.valid?
          render json: @event
        else
          render json: @event.errors.as_json(full_messages: true)
        end
      end
    end
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
                                  :image,
                                  :ticket_statuses_attributes => [:event_id, :name, :max_purchasable, :price],
                                  :link,
                                  :total_tickets
                                  )
  end

end
