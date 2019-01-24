require_relative("../db/sql_runner")

class Customer

  attr_accessor :name
  attr_reader :funds, :id

  def initialize(options)
    @name = options["name"]
    @funds = options["funds"].to_i
    @id = options["id"] if options["id"]
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    result = SqlRunner.run(sql, values).first
    @id = result["id"]
  end

  def buy_ticket(film)
    @funds -= film.price
    update()
  end

  def tickets_bought()
    return films().length
  end

  def self.all()
    sql = "SELECT * FROM customers"
    customers = SqlRunner.run(sql)
    return customers.map { |customer| Customer.new(customer) }
  end

  def update()
    sql = "UPDATE customers
           SET (name, funds) = ($1, $2)
           WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets
           ON tickets.film_id = films.id
           WHERE customer_id = $1
           ORDER BY films.title"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map { |film| Film.new(film) }
  end
end
