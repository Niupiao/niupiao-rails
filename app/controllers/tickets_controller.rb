class TicketsController < ApplicationController

  before_action :ensure_auth, except: [:index, :batch_buy]
  before_action :ensure_auth_for_index, only: [:index, :batch_buy]

  before_action :get_event, only: [:new, :create, :index]

  def my_tickets
    respond_to do |format|
      format.json do
        tickets = @current_user.my_tickets
        render json: tickets
      end
    end
  end

  def inform
    respond_to do |format|
      format.json do
        # Informs user of what they can buy for particular event
        event_id = params[:event_id]
        event = Event.find(event_id)

        # The JSONObject response
        res = {}
        
        # All the tickets I own for this event
        my_tickets = @current_user.tickets.for_event(event)

        # Loop through each of the event's statuses to see what can be bought
        event.ticket_statuses.each do |ticket_status|

          # Number of remaining tickets with this status
          in_stock = event.tickets.with_status(ticket_status.name).count

          # Number of tickets with this status that we own
          mine = my_tickets.with_status(ticket_status.name).count

          # Number of tickets I could buy, assuming ample stock
          could_buy = ticket_status.max_purchasable - mine

          # The number of buyable tickets is the 
          res[ticket_status.name] = [in_stock, could_buy].min
          res["#{ticket_status.name}_message"] = "#{in_stock} in stock, #{could_buy} could buy"
        end

        # Render the response
        render json: res
      end
    end
  end
  
  def batch_buy
    respond_to do |format|
      format.json do

        event = Event.find_by(id: params[:event_id])

        unless event
          render(json: {error: :event_not_found}) and return
        end

        # The array of tickets to be rendered
        tickets = {}

        tickets_purchased = params[:tickets_purchased]
        
        if tickets_purchased
          
          tickets_purchased.each do |status, num_purchased|

            # The status they want to purchase
            tickets_with_status = event.tickets.where(status: status.downcase)

            # Check if the status exists
            unless tickets_with_status.any?
              tickets[status] = {event_id: params[:event_id], success: false, message: "No tickets with status: #{status}"}
              next
            end

            ticket_status = tickets_with_status.first.ticket_status

            # MUST BE AN INTEGER: The number of tickets they want to buy 
            number_purchased = 0
            begin
              number_purchased = num_purchased.to_i
            rescue
              tickets[status] = {event_id: params[:event_id], success: false, status: :invalid_json, message: "Number of tickets to purchase must be a number"}
              next
            end

            # The tickets that are remaining / available for purchase
            remaining_tickets = event.tickets.with_status(status).unowned

            # CANNOT BUY MORE THAN EXIST: Cannot buy more tickets than are available
            if number_purchased > remaining_tickets.count
              tickets[status] = {event_id: params[:event_id], success: false, message: "Trying to buy #{number_purchased} '#{status}' tickets when only #{remaining_tickets.count} remain"}
              next
            end
            
            # The tickets I currently own for this EVENT and this STATUS
            currently_owned = @current_user.tickets.where(event_id: params[:event_id]).with_status(status)

            # CANNOT BUY MORE THAN LEGAL LIMIT: Cannot buy more than you're allowed
            if currently_owned.count + number_purchased > ticket_status.max_purchasable
              tickets[status] = {event_id: params[:event_id], success: false, message: "Cannot buy #{number_purchased} tickets with cap of #{ticket_status.max_purchasable}"}
              next
            end

            # Otherwise we can buy the tickets!
            tickets_to_buy = tickets_with_status.take(number_purchased)
            tickets[status] = {
              event_id: params[:event_id],
              success: true
            }
            tickets[status]['tickets'] = []
            tickets_to_buy.each do |ticket|
              ticket.user = @current_user
              ticket.save!
              tickets[status]['tickets'].push({
                ticket: ticket
              })
            end

          end
          
        end

        render json: tickets.merge(event: event) 
      end
    end
  end

  def buy
    ticket = Ticket.find(params[:ticket_id])
    event = Event.find(params[:event_id])
    
    ticket.update!(user_id: @current_user.id)
    ticket.save!

    respond_to do |format|
      format.html
      format.json do
        render json: { 
          token: @token, 
          user: @current_user, 
          ticket: ticket,
          event: event
        }
      end
    end
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
  

  private 
  
  def get_event
    @event = Event.find(params[:event_id])
  end
  
  def ticket_params
    params.require(:ticket).permit(:user_id, :event_id, :ticket_status_id)
  end
  
  
  
end
