# Forked from ChadiEM's original work: https://gist.github.com/ChadiEM/bc4014fa61f08b31f3d42a5e78c49d9b
# TODO: 
# x add current stop's station name
# - add line status to table
# - add estimated arrival of 3rd bus

require_relative 'ratp_utils'

# Uncomment and define transports below
# (or alternatively, define them in config/settings.rb)

TRANSPORTS = [
  Transport.new(Type::BUS, '258', 'Les Fontenelles', 'La Defense-Metro-RER-Tramway'),
  Transport.new(Type::BUS, '158', 'Les Fontenelles', 'Pont de Neuilly-Metro'),
  Transport.new(Type::METRO, '1', 'La Defense (Grande Arche)', 'Chateau de Vincennes'),
  Transport.new(Type::METRO, '1', 'Charles de Gaulle-Etoile', 'La Defense (Grande Arche)'),
  Transport.new(Type::BUS, '22', 'Scheffer', 'Opera')
]

# Init and Validate stations and destinations
stations = {}
directions = {}

TRANSPORTS.each do |transport|
  key = line_key(transport)
  if stations[key].nil?
    stations[key] = read_stations(transport.type[:api], transport.number)
  end

  if stations[key][transport.stop].nil?
    raise ArgumentError, "Unknown stop #{transport.stop}, possible values are #{stations[key].keys}"
  end

  if directions[key].nil?
    directions[key] = read_directions(transport.type[:api], transport.number, stations[key])
  end

  if directions[key][transport.destination].nil?
    raise ArgumentError, "Unknown destination #{transport.destination}, possible values are #{directions[key].keys}"
  end
end

SCHEDULER.every '10s', first_in: 0 do
  results = []

  TRANSPORTS.each do |transport|
    line_key = line_key(transport)
    type = transport.type[:api]
    id = transport.number
	stop_name = transport.stop
    stop = stations[line_key][transport.stop]
    dir = directions[line_key][transport.destination]

    first_destination, first_time, second_destination, second_time = read_timings(type, id, stop, dir)

    first_time_parsed, second_time_parsed = reword(first_time, second_time)
    first_destination_parsed, second_destination_parsed = reword_destination(first_destination, second_destination)

    ui_type = transport.type[:ui]

    stop_escaped = stop.tr('()+', '')
    key = "#{ui_type}-#{id}-#{stop_escaped}-#{dir}"

    status = "\u2713"

    results.push(
      key => {
        type: ui_type,
        id: id,
		stop: stop_name,
        d1: first_destination_parsed, t1: first_time_parsed,
        d2: second_destination_parsed, t2: second_time_parsed,
        status: status
      }
    )
  end

  send_event('ratp', results: results)
end
