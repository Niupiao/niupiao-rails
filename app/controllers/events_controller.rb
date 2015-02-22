class EventsController < ApplicationController

  before_action :ensure_auth, except: :index
  before_action :ensure_auth_for_index, only: :index

  def new
    @event = Event.new
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
    @event = Event.find_by(id: params[:id])
    respond_to do |format|
      format.html
      format.json do
        render json: @event
      end
    end
  end
end
