class Board

  # Store our board characters for reference using meaningful names
  PLACEHOLDER = '.'.freeze
  PLAYER_X = 'X'.freeze
  PLAYER_O = 'O'.freeze

  # I had to lookup how to determine the position in a 2d array for a hex visually shifted grid
  # These positions essentially determine where each of the 6 cells that connect to each cell are located
  # Each are offsets to apply to the current cells row/col position held in [delta_row, delta_col] pairings
  NEIGHBORS = [
    [-1, 0], # Top-Left     (row above)
    [-1, 1], # Top-Right    (row above)
    [0, -1], # Left         (same row)
    [0, 1], # Right        (same row)
    [1, -1], # Bottom-Left  (row below)
    [1, 0]  # Bottom-Right (row below)
  ].freeze

  def initialize(board)
    @board = board.map { |row| row.split }
    # now transpose the board so we can write one winning algorithm which works for both players
    @transposed_board = @board.transpose
  end

  def winner
    return '' if empty?
    return PLAYER_X if single_place_board?(PLAYER_X)
    return PLAYER_O if single_place_board?(PLAYER_O)

    # player 0 moves top to bottom
    # Find all the initial player O positions from the first row
    locations_to_check = find_initial_positions(PLAYER_O, @board[0])
    # player O wins if they get from top to bottom so winning row index is last row index
    player_o_win_index = @board.size - 1
    # process recursively the locations to check
    # note the initially empty hash is used to remember which locations we have already processed
    return PLAYER_O if player_won?(locations_to_check, {}, PLAYER_O, player_o_win_index, @board)

    # player X moves left to right - but this is top to bottom on our transposed board
    # Find all the initial player X positions from the first column (which is row on transposed board)
    locations_to_check = find_initial_positions(PLAYER_X, @transposed_board[0])
    # player X wins if they get from left to right so winning column index is last column index
    player_x_win_index = @transposed_board.size - 1
    # process recursively the locations to check
    # note the initially empty hash is used to remember which locations we have already processed
    return PLAYER_X if player_won?(locations_to_check, {}, PLAYER_X, player_x_win_index, @transposed_board)

    ''
  end

  private

  def player_won?(locations_to_check, visited_already, player_character, winning_index, board)
    # the player cannot have won if we have no locations left to check
    return false if locations_to_check.empty?

    # treat the locations_to_check as a queue
    current_location = locations_to_check.shift
    # memoize that we have visited this location already, we can skip it if another cell has this as a valid neighbour
    visited_already[current_location] = true

    # Find all valid next positions from current_location and add these to locations_to_check
    # unless locations_to_check has it or visited_already has it
    return true if add_valid_locations(current_location, locations_to_check, visited_already, player_character, board, winning_index)

    # call ourselves again to process the next in the queue (repeat until a call results in a true or false)
    player_won?(locations_to_check, visited_already, player_character, winning_index, board)
  end

  def player_reached_winning_position?(row_index, player_win_index)
    row_index == player_win_index
  end

  def find_initial_positions(player_character, row)
    # Each location will have an x/y or column/row pairing (0,0 is top left)
    row.each_with_index.select { |char, _| char == player_character }.map { |selected| [selected[1], 0] }
  end

  def add_valid_locations(current_location, locations_to_check, visited_already, player_character, board, winning_index)
    #note we would also need this if we didnt have the earlier guards that confirm we are not dealing with a single row game board
    #return true if player_reached_winning_position?(current_location[1], winning_index)

    NEIGHBORS.each do |(row_adjustment, col_adjustment)|
      nx = current_location[0] + row_adjustment
      ny = current_location[1] + col_adjustment
      new_location = [nx, ny]
      if nx.between?(0, board[0].size) && ny.between?(0, board.size ) &&
         board[ny][nx] == player_character && !locations_to_check.include?(new_location) && !visited_already.include?(new_location)
        # return true if the player has won by arriving at a winning location
        return true if player_reached_winning_position?(new_location[1], winning_index)
        # otherwise add the location to the queue to be processed later via recursion
        locations_to_check << new_location
      end
    end
    false
  end

  def empty?
    @board.all? { |row| row.all? { |char| char == PLACEHOLDER } }
  end

  def single_place_board?(player_character)
    @board.size == 1 && @board[0].size == 1 && @board[0][0] == player_character
  end

end
