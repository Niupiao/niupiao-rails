module ApplicationHelper

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete :user_id
    @current_user = nil
  end
  
  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # Methods below for handling Event Management
  
  #Allows removal of fields associated with a ticket status.
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_ticket_status(this)")
  end
  
  #Allows dynamic addition of fields associated with a ticket status.
  def link_to_add_ticket_status(name, f, association)
    status_format = "event_ticket_status_field.html.erb"
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(status_format, :f => builder)
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
end
