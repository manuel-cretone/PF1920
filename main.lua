--TODO: life update bug
io.stdout:setvbuf("no")
table.unpack = unpack
require "converter"
-- https://sheepolution.com/learn/book/18
TILESET = "scifitiles-sheet.png"
NOWALL = 21
WALL = 5
PIT = 18
ENTRANCE = 4
EXIT = 59
width = 32
height = 32

function draw_arrowhead(x, y, orientation)
  if orientation == "SOUTH" then
    love.graphics.polygon('fill', x + width/2, y + height, x + 10, y + height - 10, x + width - 10, y + height - 10)
  elseif orientation == "NORTH" then
    love.graphics.polygon('fill', x + width/2, y, x + 10, y + 10, x + width - 10, y + 10)
  elseif orientation == "EAST" then
    love.graphics.polygon('fill', x + width, y + height/2, x + width - 10, y + 10, x + width - 10, y + height - 10)
  elseif orientation == "WEST" then
    love.graphics.polygon('fill', x, y + height/2, x + 10, y + 10, x + 10, y + height - 10)
  end
end

function draw_line(x, y, orientation, offset)
  offset = offset or 0
  if orientation == "SOUTH" then
    love.graphics.line(x + width/2, y, x+ width/2, y + height - offset)
  elseif orientation == "NORTH" then
    love.graphics.line(x + width/2, y + offset, x+ width/2, y + height)
  elseif orientation == "EAST" then
    love.graphics.line(x, y + height/2, x+ width - offset, y + height/2)
  elseif orientation == "WEST" then
    love.graphics.line(x + offset, y + height/2, x+ width, y + height/2)
  elseif orientation == "SOUTHEAST" then
    love.graphics.line(x + width/2, y, x+ width/2, y + height/2)
    love.graphics.line(x + width/2 - love.graphics.getLineWidth() / 2, y + height/2, x+ width - offset, y + height/2)
  elseif orientation == "SOUTHWEST" then
    love.graphics.line(x + width/2, y, x+ width/2, y + height/2)
    love.graphics.line(x + width/2 + love.graphics.getLineWidth() / 2, y + height/2, x + offset, y + height/2)
  elseif orientation == "NORTHEAST" then
    love.graphics.line(x + width/2, y + height, x+ width/2, y + height/2) 
    love.graphics.line(x + width/2 - love.graphics.getLineWidth() / 2, y + height/2, x+ width - offset, y + height/2)
  elseif orientation == "NORTHWEST" then
    love.graphics.line(x + width/2, y + height, x+ width/2, y + height/2)
    love.graphics.line(x + width/2 + love.graphics.getLineWidth() / 2, y + height/2, x + offset, y + height/2)
  end 
end


function draw_arrow(x, y, orientation)
  if orientation == "SOUTH" then
    draw_line(x, y, orientation, 10)
    draw_arrowhead(x, y, "SOUTH")
  elseif orientation == "NORTH" then
    draw_line(x, y, orientation, 10)
    draw_arrowhead(x, y, "NORTH")
  elseif orientation == "EAST" or orientation == "SOUTHEAST" or orientation == "NORTHEAST"then
    draw_line(x, y, orientation, 10)
    draw_arrowhead(x, y, "EAST")
  elseif orientation == "WEST" or orientation == "SOUTHWEST" or orientation == "NORTHWEST" then
    draw_line(x, y, orientation, 10)
    draw_arrowhead(x, y, "WEST")
  end  
end


function draw_origin(x, y, orientation, with_arrow)
  love.graphics.circle("fill", x + width/2, y + height/2, 5)
  
  if(with_arrow) then
    offset = 10
    draw_arrowhead(x, y, orientation)
  else
    offset = 0
  end
  
  if orientation == "SOUTH" then
    love.graphics.line(x + width/2, y + height/2, x+ width/2, y + height - offset)
  elseif orientation == "NORTH" then
    love.graphics.line(x + width/2, y + height/2, x+ width/2, y + offset)
  elseif orientation == "EAST" then
    love.graphics.line(x + width/2, y + height/2, x+ width - offset, y + height/2)
  elseif orientation == "WEST" then
    love.graphics.line(x + width/2, y + height/2, x+ offset, y + height/2)
  end  

end


--punta a
function draw_destination(x, y, orientation)
  draw_line(x, y, orientation, width-10)
  if orientation == "SOUTH" then
    love.graphics.polygon('fill', x + width/2, y + height/2, x + 10, y + height/2 - 10, x + width - 10, y + height/2 - 10)
  elseif orientation == "NORTH" then
    love.graphics.polygon('fill', x + width/2, y + height/2, x + 10, y + height/2 + 10, x + width - 10, y + height/2 + 10)
  elseif orientation == "EAST" then
    love.graphics.polygon('fill', x + width/2, y + height/2, x + width/2 - 10, y + 10, x + width/2 - 10, y + height - 10)
  elseif orientation == "WEST" then
    love.graphics.polygon('fill', x + width/2, y + height/2, x + width/2 + 10, y + 10, x + width/2 + 10, y + height - 10)
  end
end


function draw_moves(history, current_move)
  local i = 0
  local current_x, current_y = find_initial(maze)
  while i < current_move do
    i = i + 1
    if i == 1 then
      move = history[i][1]
      delta_x, delta_y = move_vector(move)
      if delta_x == 1 then
        draw_origin(current_x*width, current_y*height, "EAST", false)
      elseif delta_x == -1 then
        draw_origin(current_x*width, current_y*height, "WEST", false)
      elseif delta_y == 1 then
        draw_origin(current_x*width, current_y*height, "SOUTH", false)
      elseif delta_y == -1 then
        draw_origin(current_x*width, current_y*height, "NORTH", false)
      end
      current_x, current_y = current_x + delta_x, current_y + delta_y
      prev_delta_x, prev_delta_y = delta_x, delta_y
    elseif i <= current_move then
      move = history[i][1]
      delta_x, delta_y = move_vector(move)
      if prev_delta_x ~= 0 and delta_x ~= 0 then
        draw_line(current_x*width, current_y*height, "EAST")
      elseif prev_delta_y ~= 0 and delta_y ~= 0 then
        draw_line(current_x*width, current_y*height, "SOUTH")
      elseif (prev_delta_y == 1 and delta_x == -1) or (prev_delta_x == 1 and delta_y == -1) then
        draw_line(current_x*width, current_y*height, "SOUTHWEST")
      elseif (prev_delta_y == 1 and delta_x == 1) or (prev_delta_x == -1 and delta_y == -1) then
        draw_line(current_x*width, current_y*height, "SOUTHEAST")
      elseif (prev_delta_y == -1 and delta_x == -1) or (prev_delta_x == 1 and delta_y == 1) then
        draw_line(current_x*width, current_y*height, "NORTHWEST")
      elseif (prev_delta_y == -1 and delta_x == 1) or (prev_delta_x == -1 and delta_y == 1) then
        draw_line(current_x*width, current_y*height, "NORTHEAST")
      end
      current_x, current_y = current_x + delta_x, current_y + delta_y
      prev_delta_x, prev_delta_y = delta_x, delta_y
    end
    if i == current_move then
      move = history[i][1]
      delta_x, delta_y = move_vector(move)
      if delta_x == 1 then
        draw_destination(current_x*width, current_y*height, "EAST")
      elseif delta_x == -1 then
        draw_destination(current_x*width, current_y*height, "WEST")
      elseif delta_y == 1 then
        draw_destination(current_x*width, current_y*height, "SOUTH")
      elseif delta_y == -1 then
        draw_destination(current_x*width, current_y*height, "NORTH")
      end
    end
  end



    
  
--  local i = 2
--  while i < current_move do
--    i = i + 1
--    draw_move(x, y, history[i][1])
--  end
end

function generate_tilemap(maze)
  local tilemap = {}
  
  
  for i,row in ipairs(maze) do
    table.insert(tilemap, {})
    for j,tile in ipairs(row) do
      if tile == "p" then
        table.insert(tilemap[i], PIT)
      elseif tile == "u" then
        table.insert(tilemap[i], EXIT)
      elseif tile == "i" then
        table.insert(tilemap[i], ENTRANCE)
      elseif tile ~= "m" then
        table.insert(tilemap[i], NOWALL)
      else
        table.insert(tilemap[i], WALL)
      end
    end
  end

  return tilemap
  
end




function love.load()
    --tick = require "tick"
    life = 5
    maze = {{"m", "m", "m", "m", "m", "m", "m"},
            {"m", 3, 1, 7, "m", "p","m"},
            {"m", "m", 3, 0, 8, 1, "m"},
            {"m", 2, 1, "p", "m", "u", "m"},
            {"m", "i", 3, "m", "m", "m", "m"},
            {"m", 2, "m", 9, "m", "m", "m"}}
    history = {{"U", 2},{"R", 1},{"U", 3},{"R", 0},{"R", -4},{"R", 1},{"D", 0}}
    current_move = 0
    index = 0
    
    
    
    
    image = love.graphics.newImage(TILESET)
    local image_width = image:getWidth()
    local image_height = image:getHeight()

  --TODO: generalize indexes
    quads = {}
    for i=0,5 do
      for j=0,13 do
        table.insert(quads, love.graphics.newQuad(j * width, i * height, width, height, image_width, image_height))
      end
    end
    
    
  tilemap = generate_tilemap(maze)
    
  love.graphics.setFont(love.graphics.newFont(12))
  love.graphics.setLineWidth(5)
  love.graphics.setLineStyle("rough")
  love.window.maximize()
end

function love.update(dt)
  --tick.update(dt)
  while index < current_move do
    index = index + 1
    life = life + history[index][2]
  end
end

function love.draw()
  
  love.graphics.print("Life: " .. life, width, height/2)
  
  love.graphics.print("Keys: [SPACE] -> Execute one step \t [ENTER] -> Execute full path \t [BACKSPACE] -> Backtrack one step \t [DELETE] -> Backtrack all steps", width*3, height/2)
  
  for i,row in ipairs(tilemap) do
    for j,tile in ipairs(row) do
      --Draw the image with the correct quad
      love.graphics.draw(image, quads[tile], j * width, i * height)
      if type(maze[i][j]) == "number" or maze[i][j] == "f" then
          love.graphics.setColor(0,0,0,1)
          love.graphics.print(maze[i][j], j * width, i * height)
          love.graphics.setColor(1,1,1,1)
      end
    end
  end
  
  draw_moves(history, current_move)
  
end


function love.keypressed(key, scancode, isrepeat)
   if key == "space" and current_move < #history then
      current_move = current_move + 1
    elseif key == "return" then
      current_move = #history
    elseif key == "backspace" then
      current_move = current_move - 1
    elseif key == "delete" then
      current_move = 0
   end
end
