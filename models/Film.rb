require_relative("../db/sql_runner")

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options["title"]
    @price = options["price"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save()
    sql = "INSERT INTO films (title, price)
           VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values).first
    @id = result["id"]
  end

  def customers_going()
    return customers().length
  end

  def most_popular_show_time()
    sql = "SELECT screenings.* FROM screenings
           INNER JOIN tickets
           ON tickets.screening_id = screenings.id
           WHERE tickets.film_id = $1"
    values = [@id]
    show_times = SqlRunner.run(sql, values).map { |show_time| show_time["show_time"] }
    freq = show_times.inject(Hash.new(0)) { |hash, show_time| hash[show_time] += 1; hash}
    return show_times.max_by { |show_time| freq[show_time]}
  end

  def self.all()
    sql = "SELECT * FROM films"
    films = SqlRunner.run(sql)
    return films.map { |film| Film.new(film) }
  end

  def update()
    sql = "UPDATE films
           SET (title, price) = ($1, $2)
           WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets
           ON tickets.customer_id = customers.id
           WHERE film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    return customers.map { |customer| Customer.new(customer) }
  end

end
