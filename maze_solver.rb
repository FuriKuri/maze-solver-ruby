require 'maze/client/maze_client'

class MazeSolver
  def initialize(hostname, port, playername)
    @client = MazeClient.new(hostname, port, playername)
    @field = {}
    @current_position = [0, 0]
  end

  def start
    @client.connect
    @field[@current_position] = 1
    while @client.player_moves == nil || @client.player_moves.empty?
      puts 'get moves'
      do_next_move(@client.next_moves)
      puts 'did move'
    end
    puts @client.player_moves
    @client.say_goodbye
  end

  private
  def do_next_move(next_moves)
    puts next_moves
    move = get_next_move next_moves
    puts move
    case move
      when 'bottom'
        @client.move_bottom
        @current_position = [@current_position[0], @current_position[1] - 1]
      when 'top'
        @client.move_top
        @current_position = [@current_position[0], @current_position[1] + 1]
      when 'left'
        @client.move_left
        @current_position = [@current_position[0] - 1, @current_position[1]]
      when 'right'
        @client.move_right
        @current_position = [@current_position[0] + 1, @current_position[1]]
    end
    increase_field
    sleep 1.0 / 4.0
  end

  def increase_field
    if @field[@current_position] == nil
      @field[@current_position] = 0
    end
    @field[@current_position] += 1
  end

  def get_next_move(next_moves)
    next_move_value = 999999
    next_move = nil
    next_moves.each do |move|
      value = get_field_value move
      if value < next_move_value
        next_move = move
        next_move_value = value
      end
    end
    next_move
  end

  def get_field_value(type)
    case type
      when 'bottom'
        get_field_value_for_pos [@current_position[0], @current_position[1] - 1]
      when 'top'
        get_field_value_for_pos [@current_position[0], @current_position[1] + 1]
      when 'left'
        get_field_value_for_pos [@current_position[0] - 1, @current_position[1]]
      when 'right'
        get_field_value_for_pos [@current_position[0] + 1, @current_position[1]]
    end
  end

  def get_field_value_for_pos pos
    if @field[pos] == nil
      return 0
    end
    @field[pos]
  end
end