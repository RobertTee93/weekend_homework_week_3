require_relative("../db/sql_runner")

class Ticket

  attr_accessor :customer_id, :film_id, :screening_id, :id

  def initialize(options)
    @customer_id = options["customer_id"]
    @film_id = options["film_id"]
    @screening_id = options["screening_id"].to_i
    @id = options["id"].to_i if options["id"]
  end

  def save()
    sql = "INSERT INTO tickets (customer_id, screening_id, film_id)
           VALUES ($1, $2, $3) RETURNING id"
    values = [@customer_id, @screening_id, @film_id]
    result = SqlRunner.run(sql, values).first
    @id = result["id"]
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    tickets = SqlRunner.run(sql)
    return tickets.map { |ticket| Ticket.new(ticket) }
  end

  def update()
    sql = "UPDATE tickets
           SET (customer_id, screening_id, film_id) = ($1, $2)
           WHERE id = $3"
    values = [@customer_id, @screening_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end



end
