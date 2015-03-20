require 'test_helper'

class RegistrationTest < ActionDispatch::IntegrationTest
  include IntegrationHelperTest

  test "should register a user" do
    post '/signup.json', session: {
           email: 'kmc3@williams.edu',
           password: 'foobar',
           first_name: 'kevin',
           last_name: 'chen'
         }
    #puts "JSON: #{prettify(json)}"
    
    
    post '/signup.json', session: {
           email: 'kmc3@williams.edu',
           password: 'foobar',
           first_name: 'kevin',
           last_name: 'chen'
         }
    #puts "JSON: #{prettify(json)}"
    
    
    post '/signup.json', session: {
           email: 'boo@williams.edu',
           password: '',
           first_name: 'kevin',
           last_name: 'chen'
         }
    #puts "JSON: #{prettify(json)}"
  end

  
end
