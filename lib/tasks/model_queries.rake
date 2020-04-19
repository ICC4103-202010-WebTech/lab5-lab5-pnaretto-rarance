namespace :db do
  task :populate_fake_data => :environment do
    # If you are curious, you may check out the file
    # RAILS_ROOT/test/factories.rb to see how fake
    # model data is created using the Faker and
    # FactoryBot gems.
    puts "Populating database"
    # 10 event venues is reasonable...
    create_list(:event_venue, 10)
    # 50 customers with orders should be alright
    create_list(:customer_with_orders, 50)
    # You may try increasing the number of events:
    create_list(:event_with_ticket_types_and_tickets, 3)
  end
  task :model_queries => :environment do
    # Sample query: Get the names of the events available and print them out.
    # Always print out a title for your query
    puts("Query 0: Sample query; show the names of the events available")
    result = Event.select(:name).distinct.map { |x| x.name }
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("\r")
    id=1 #Customer id
    name="ESL Cologne" #search by name
    Numb= 1 #Event id
    puts("Quary 1: Report the total number of tickets bought by a given customer")
    result = Customer.find(id).tickets.count
    puts(result)
    puts("EOQ")
    puts("\r")
    puts("Query 2: Number of total different events a specified user has attended.")
    result = Event.joins(ticket_types:{ tickets: :order}).where(orders:{customer_id:id}).select(:name).distinct.count #In this case it was used the customer number 1, to change it you may change the customer_id value
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("\r")
    puts("Query 3: Names of the events attended by a given customer.")
    result = Event.joins(ticket_types: {tickets: :order}).where(orders:{customer_id: id}).group(:name).map {|x| x.name} #In this case it was used the customer number 1, to change it you may change the customer_id value
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("\r")
    puts("Query 4: Total number of tickets sold for an event.")
    puts("looking by the name: ")
    puts(name)
    result = TicketType.joins(:tickets).joins(:event).where( events: {name:name}).select("ticket_types.ticket_price").count() #change the value of name to look for another event
    puts(result)
    puts("looking by event id: ")
    puts(Numb)
    result = TicketType.joins(:tickets).joins(:event).where( events: {id:Numb}).select("ticket_types.ticket_price").count() #change the value of event to look for another event
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("\r")
    puts("Query 5: Total sales of an specific event.")
    puts("looking by the name: ")
    puts(name)
    result = TicketType.joins(:tickets).joins(:event).where( events: {name:name}).select("ticket_types.ticket_price").sum("ticket_price") #change the value of name to look for another event
    puts(result)
    puts("looking by event id: ")
    puts(Numb)
    result = TicketType.joins(:tickets).joins(:event).where(event: Numb).select("ticket_types.ticket_price").sum("ticket_price")#change the value of event to look for another event
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("\r")
    puts("Query 6: Event with more attendance of females.")
    result= Event.joins(ticket_types: {tickets: {order: :customer}}).where(customers: {gender:"f"}).group(:name).order(2).count.first()
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.
    puts("\r")
    puts("Query 7: The event that has been most attended by men ages 18 to 30.")
    result= Event.joins(ticket_types: {tickets: {order: :customer}}).where("customers.gender='m' and customers.age>=18 and customers.age<=30").group(:name).order(2).count.first()
    puts(result)
    puts("EOQ") # End Of Query -- always add this line after a query.

  end
end