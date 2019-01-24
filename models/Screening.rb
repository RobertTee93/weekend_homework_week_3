require_relative("../db/sql_runner")

class Screening

  attr_accessor :show_time, :film_id, :id, :capacity

  def initialize(options)
    @show_time = options["show_time"]
    @film_id = options["film_id"].to_i
    @capacity = options["capacity"].to_i
    @id = options["id"] if options["id"]
  end

  def save()
    sql = "INSERT INTO screenings (show_time, capacity, film_id)
           VALUES ($1, $2, $3) RETURNING id"
    values = [@show_time, @capacity, @film_id]
    result = SqlRunner.run(sql, values).first
    @id = result["id"]
  end

  def update()
    sql = "UPDATE screenings
           SET (show_time, capacity, film_id) = ($1, $2)
           WHERE id = $3"
    values = [@show_time, @capacity, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    screenings = SqlRunner.run(sql)
    return screenings.map { |screening| Screening.new(screening)}
  end

  def check_if_enough_space?()
    @capacity > count_tickets_sold()
  end


  def tickets_sold()
    sql = "SELECT tickets.* FROM tickets INNER JOIN screenings
           ON tickets.screening_id = screenings.id
           WHERE screenings.id = $1"
    values = [@id]
    tickets = SqlRunner.run(sql, values)
    return tickets.map { |ticket| Ticket.new(ticket) }
  end

  def count_tickets_sold
    return tickets_sold().length
  end

end
