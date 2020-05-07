-- get all lines from a file
function lines_from(file)
  assert(io.open(file, "rb"))
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- builds a maze from the table containing lines of the file
function build_maze(lines_table)
  local maze = {}
  for i=1,#lines-1 do
    row = {}
    -- need to skip first row: reserved for vitality
    for cell in string.gmatch(lines[i + 1], "%S+") do
      row[#row + 1] = cell
    end
    maze[i] = row
  end
  return maze
end

-- finds points of a maze with a specific symbol (Ex: entry points with symbol "i")
function find_points(maze, symbol)
  local points = {}
  for row_key, row_table in pairs(maze) do
    for col_key, element in pairs(row_table) do
      if element == symbol and col == nil then
        local points_index = #points + 1
        points[points_index] = {}
        points[points_index].x = col_key
        points[points_index].y = row_key
      end
    end
  end
  return points
end 

-- checks length of entry points list: it must be 1
function check_entry_point_validity(points)
  if #points == 1 then return true else return false end
end

-- checks if maze is correct must have rows with all same lenght
function check_maze_validity(maze)
  local n_cols = #maze[1]
  for key, row in pairs(maze) do
    if #row ~= n_cols then do return false end end
  end
  return true
end

-- builds the start table: it contains vitality of the player, entry point and exit points
function build_start_table(lines_table, maze)
  start = {}
  start.vitality = lines[1]
  local entry_points = find_points(maze, "i")
  assert(check_entry_point_validity(entry_points), "The maze file must contain only one entry point.")
  start.entry_point = {}
  start.entry_point.x = entry_points[1].x
  start.entry_point.y = entry_points[1].y
  start.exit_points = find_points(maze, "u")
  return start
end

-- builds maze table and start table and checks for input errors
function init_game_data(filename)
  local lines = lines_from(filename)
  local maze = build_maze(lines)
  assert(check_maze_validity(maze), "Maze format is not correct: rows have not the same number of columns.")
  local start = build_start_table(lines, maze)
  return start, maze
end

-- start, maze = init_game_data("maze.txt")
