require_relative("models/Customer")
require_relative("models/Film")
require_relative("models/Ticket")
require_relative("models/Screening")

require("pry")

customer1 = Customer.new({
  "name" => "Robert",
  "funds" => "120"
  })

customer2 = Customer.new({
  "name" => "Claire",
  "funds" => "90"
  })

customer1.save()
customer2.save()

film1 = Film.new({
  "title" => "Guardians of the Galaxy",
  "price" => "12"
  })

film2 = Film.new({
  "title" => "Avengers Assemble",
  "price" => "10"
  })

film1.save()
film2.save()


screening1 = Screening.new({
  "show_time" => "17:30",
  "film_id" => film1.id,
  "capacity" => "20"
  })

screening2 = Screening.new({
  "show_time" => "22:30",
  "film_id" => film1.id,
  "capacity" => "20"
  })

screening3 = Screening.new({
  "show_time" => "19:20",
  "film_id" => film2.id,
  "capacity" => "20"
  })

screening4 = Screening.new({
  "show_time" => "12:45",
  "film_id" => film2.id,
  "capacity" => "20"
  })

  screening1.save()
  screening2.save()
  screening3.save()
  screening4.save()

  ticket1 = Ticket.new({
    "customer_id" => customer1.id,
    "film_id" => film2.id,
    "screening_id" => screening3.id
    })

  ticket2 = Ticket.new({
    "customer_id" => customer1.id,
    "film_id" => film1.id,
    "screening_id" => screening1.id
    })

  ticket3 = Ticket.new({
    "customer_id" => customer2.id,
    "film_id" => film2.id,
    "screening_id" => screening3.id
    })

  ticket4 = Ticket.new({
    "customer_id" => customer2.id,
    "film_id" => film2.id,
    "screening_id" => screening4.id
    })

  ticket1.save()
  ticket2.save()
  ticket3.save()
  ticket4.save()


























# screening3.check_if_enough_space?()

# film1.most_popular_show_time()
# #
binding.pry
nil
