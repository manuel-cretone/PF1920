-- debug variables
visited = {
  ["1|1|1"] = {"", 0 },
  ["2|2|1"] = {"R", 1 },
  ["1|2|2"] = {"D", -1 },
}

tab = {{"m", "m", "m", "m", "m", "m", "m"},
{"m", 3, 1, 7, "m", "p","m"},
{"m", "m", 3, "m", 8, 1, "m"},
{"m", 2, 1, "p", "m", "u", "m"},
{"m", "i", 3, "m", "m", "m", "m"},
{"m", 2, "m", 9, "m", "m", "m"}}

t  = {life = 3, x = 1, y = 2}
-------------------------------------------------


-- input: two dimensional table
-- output: none
function print_table(tab)
  for i,v in ipairs(tab) do
    for j, w in ipairs(v) do
      io.write(w)
    end
    io.write("\n")
  end
end

-- input: life, x, y as numbers
-- output: string representing the state
function encode(life, x, y)
  return life .. "|" .. x .. "|" .. y 
end

-- input: string representing the state
-- output: life, x, y as numbers
function decode(str)
  local values = {}
  for i in string.gmatch(str, "%d+") do
    table.insert(values, tonumber(i))
  end
  return table.unpack(values)
end

-- input: two dimensional table representing the maze
-- output: x, y of the square marked as "i"
function find_initial(maze)
  for i,v in ipairs(maze) do
    for j,w in ipairs(v) do
      if w == "i" then
        return j,i
        end
      end
  end
end

-- input: character D, U, L or R
-- output: delta_x, delta_y representing the change in x and y
function move_vector(move)
  local delta_x, delta_y
    if move == "D" then
      delta_x, delta_y = 0, 1
    elseif move == "U" then
      delta_x, delta_y = 0, -1
    elseif move == "L" then
      delta_x, delta_y = -1, 0
    elseif move == "R" then
      delta_x, delta_y = 1, 0
    else 
      print("Error")
    end
    return delta_x, delta_y
  end


-- input: state string final, hash table tree
-- output: string representing the steps taken in the path using DULR
function gen_path(final, tree)
  -- input: state string final, path string path
  -- output: string representing the steps taken in the path using DULR
  function _gen_path(final, path)
    path = tree[final][1] .. path
    if tree[final][1] == "" then
      return path
    else
      return _gen_path(invert_move(final, tree[final][1], tree[final][2]), path)
    end
  end
  -- input: state string, move used to get to state, life_chance applied after getting to state
  -- output: string representing previous state
  function invert_move(state, move, life_change)
    local life, x, y = decode(state)
    local delta_x, delta_y = move_vector(move)
    return encode(life - life_change, x - delta_x, y - delta_y)
  end
  
  return _gen_path(final, "")
  end

-- input: path string composed by DULR characters, two dimensional table representing maze
-- output: None (Maze modified by side effect)
function write_path(path, maze)
  -- input: path string composed by DULR characters, x coordinate, y coordinate of current position in maze
  -- output: None (Maze modified by side effect)
  function _write_path(path, x, y)
    local move = string.sub(path,1,1)
    if move ~= "" then
      local delta_x, delta_y = move_vector(move)
      x = x + delta_x
      y = y + delta_y
      maze[y][x] = "*"
      _write_path(string.sub(path, 2), x, y)
    end
  end
  
  local x,y = find_initial(maze)
  maze[y][x] = "*"
  _write_path(path, x, y)
end

print(gen_path("1|2|2", visited))
write_path(gen_path("1|2|2", visited), tab)
print_table(tab)
