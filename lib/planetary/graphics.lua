local graphics = {}

graphics.draw_horizon = function(world)
  local horizon_colors = {3,2,1}
  screen.line_width(1)
  screen.move(0,horizon_height)
  screen.line(0,horizon_height,128,horizon_height)
  screen.close()
  screen.stroke()
  screen.rect(0,horizon_height,128,44)
  screen.level(horizon_colors[world])
  screen.fill()
end

graphics.draw_stars = function()
  screen.line_width(1)
  screen.level(math.floor(16.0 * level[current_world]))
  for i = 1,#world_stars[current_world] do
    star = world_stars[current_world][i]
    screen.pixel(star.x,star.y)
    screen.fill()
  end
end

graphics.draw_sun = function(current_world)
  _x = math.floor(128 - (64*brightnesses[current_world]))
  _y = math.floor((horizon_height-20) + (16.0-(16*brightnesses[current_world])))
  screen.move(_x,_y)
  
  if current_world == 1 then
    -- sun
    screen.circle(_x, _y, 10)
    screen.level(math.floor(16.0 * brightnesses[current_world]))
    screen.fill()
  elseif current_world == 2 then
    _x = _x + 16
    _y = _y + 8
    -- rings
    screen.move(_x-12, _y)
    screen.level(16)
    screen.curve_rel(-8,4,0,16,24,0)
    screen.stroke()
    -- planet
    screen.circle(_x, _y, 10)
    screen.level(math.floor(16.0 * brightnesses[current_world] / 2))
    screen.fill()
    screen.level(16)
    screen.move(_x+12, _y)
    screen.curve_rel(8,-4,0,-16,-24,0)
    screen.stroke()
    -- moons
    _x = _x -24
    _y = _y -4
    screen.circle(_x, _y, 2)
    screen.level(math.floor(16.0 * brightnesses[current_world]))
    screen.fill()
    _x = _x -30
    _y = _y + 4
    screen.circle(_x, _y, 3)
    screen.level(math.floor(16.0 * brightnesses[current_world]))
    screen.fill()
  elseif current_world == 3 then
    -- moon
    _x = _x + 12
    screen.circle(_x, _y, 10)
    screen.level(math.floor(16.0 * brightnesses[current_world]))
    screen.fill()
    screen.circle(_x-4, _y-4, 10)
    screen.level(0)
    screen.fill()
  end
end

graphics.draw_landscape = function(current_world)
  world_events = events[current_world]
  for index,event in pairs(world_events) do
    if event.seed < probs[current_world] then
      graphics.draw_world_item(current_world, event.x, event.y)
    end
  end
end

graphics.draw_world_item = function(world,x,y)
  if world == 1 then
    graphics.draw_pole(x,y)
  elseif world == 2 then
    graphics.draw_pyramid(x,y)
  elseif world == 3 then
    graphics.draw_cactus(x,y)
  end
end
    
graphics.draw_pole = function(x,y)
  screen.line_width(1)
  pole_height = 12 
  screen.move(x,y)
  screen.level(16)
  screen.line_rel(0,0-pole_height)
  screen.line_rel(-4,2)
  screen.line_rel(4,-2)
  screen.line_rel(4,-2)
  screen.stroke()
end

graphics.draw_pyramid = function(x,y)
  screen.line_width(1)
  pwidth = 12 
  pheight = 8 
  screen.move(x,y)
  screen.level(16)
  screen.line_rel(-pwidth/2, 0)
  screen.line_rel(pwidth, 0)
  screen.line_rel(-pwidth/2, 0-pheight)
  screen.line_rel(-pwidth/2, pheight)
  screen.line_rel(pwidth,0)
  screen.line_rel(2,-4)
  screen.line_rel(-2-(pwidth/2),4-pheight)
  screen.stroke()
end

graphics.draw_cactus = function(x,y)
  cactus_height =12 
  screen.line_width(3)
  screen.line_cap("round")
  screen.level(11) 
  screen.move(x,y)
  screen.line_rel(0,-cactus_height)
  screen.line_rel(0,math.floor(cactus_height/3))
  screen.line_rel(4,-1)
  screen.line_rel(0,-6)
  screen.line_rel(0,6)
  screen.line_rel(-4,1)
  screen.line_rel(-4,1)
  screen.line_rel(0,-8)
  screen.stroke()
end

graphics.init_all_stars = function()
-- initialize events
  for world=1,3 do
    world_stars[world] = {}
    graphics.init_stars(world)
  end
end

graphics.init_stars = function(world)
  for i=1,10 do
    star = {}
    star.x = math.floor(math.random() * 128)
    star.y = math.floor(math.random() * horizon_height)
    world_stars[world][i] = star
  end
end

return graphics