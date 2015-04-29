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
  
  #Allows dynamic addition of fields associated with a ticket status.
  def link_to_add_ticket_status(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields_before(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  
  #Allows signup form to change content based on whether or not user is a Manager or a Fan.
  def link_to_change_form(name, f, is_manager)
    link_to_function(name, "change_signup_form(this, is_manager)")
  end
end
