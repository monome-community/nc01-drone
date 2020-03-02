-- Eclipse (nc01-drone)
-- @wheelersounds
--
-- E1 volume
-- E2 brightness 
--    (levels of top buffers)
-- E3 density
-- K2 evolve (change mix of 
--    octaves, position in files)
-- K3 change worlds



-- TODO --
-- implement params?



function init()
	
	re=metro.init()
	re.time = 1.0/15
	re.event = function()
	  redraw()
	end
	re:start()
	
	file1 = _path.code .. "nc01-drone/lib/dd.wav" -- notes, buff pos: 0
	file2 = _path.code .. "nc01-drone/lib/bc.wav" -- wind noise, buf_pos: 10
	file3 = _path.code .. "nc01-drone/lib/eb.wav" -- cello drone, buf_pos: 20
	
  softcut.buffer_clear()
  softcut.buffer_read_mono(file1,0,0,-1,1,1) -- file,file_start,buf_pos,dur,file_ch,buf_num
  softcut.buffer_read_mono(file2,0,20,-1,1,1)
  softcut.buffer_read_mono(file3,0,40,-1,1,1)
  
  mode_number = 1
  
  mode_buff_offset = {0, 20, 40}
  rates = {0.5, 1, 4, 8}
  levels = {0.4, 0.4, 0.4, 0.4}
  master_volume = 1
  
  brightness = 1.
  density = 1.
  filter_freq = 12000.0
  fadetime = 0.1
  
-- ### softcut init
  for i=1,4 do
    softcut.enable(i,1)
    softcut.buffer(i,1)
    softcut.level(i,math.random()*0.5+0.2)
    softcut.level_slew_time(i, 1)
    softcut.fade_time(i,fadetime)
    softcut.loop(i,1)
    softcut.loop_start(i,1)
    softcut.loop_end(i,1.1)
    softcut.position(i,1)
    softcut.rate(i,rates[i])
    softcut.play(i,1)
    
    softcut.post_filter_dry(i,0.0)
    softcut.post_filter_lp(i,1.0)
    softcut.post_filter_fc(i,filter_freq)
    softcut.post_filter_rq(i,5)
  end

-- ### screen init
  screen_x=128
  screen_y=64
  -- print("approaching...")
end

function enc(n,d)
  if n == 1 then
    -- volume
    for i=1,4 do
      master_volume = util.clamp(master_volume + d/100, 0, 1)
      softcut.level(i, levels[i] * master_volume)
    end
    
  elseif n == 2 then
    --"brightness"
    
    for i=1,4 do
      brightness = util.clamp(brightness + (d/100), 0., 1.)
      filter_freq = brightness * 11500 + 500 --
      -- print(filter_freq)
      softcut.post_filter_fc(i,filter_freq)
    end

  elseif n == 3 then
    --"density"
    for i=1,4 do
      density = util.clamp(density + (d/100), 0., 1.)
      fadetime = density * 0.75 + 0.01 --
      softcut.fade_time(i,fadetime)
    end
  end
  
end

function key(n,z)
    if n == 2 then
      -- evolve
      if z == 1 then
        for i=1,4 do
          levels[i] = math.random()*0.5 + 0.2
          softcut.level(i, levels[i] * master_volume)
          -- also rand positions
          local new_pos=math.random()*20
          softcut.loop_start(i,new_pos + mode_buff_offset[mode_number] + 1)
          softcut.loop_end(i,new_pos + mode_buff_offset[mode_number] + 1.1)
        end
      end
      
    elseif n == 3 then
      -- new world (mode_number from 1..3)
      if z == 1 then
        mode_number = (mode_number %3) + 1
        -- mode_number = mode_number + 1
        for i=1,4 do
        local new_pos=math.random()*20
        softcut.loop_start(i,new_pos + mode_buff_offset[mode_number] + 1)
        softcut.loop_end(i,new_pos + mode_buff_offset[mode_number] + 1.1)
        end
      end
    end
    redraw()
end

  

function redraw()
  screen.clear()
  screen.aa(1)
  if mode_number == 1 then
    for i=1,10 do
      local bright = math.random(10)
      screen.level(math.floor(util.clamp(density * 15 - bright,3,15))) --density
      local coin = math.random(2)
      screen.move(screen_x * (1/i), screen_y * (1/i))
      if coin == 1 then
        screen.line(screen_x * (1/i), 0)
      else
        screen.line(0, screen_y * (1/i))
      end
      screen.stroke()
    end
    screen.level(math.floor(brightness * 15)) --brightness
    screen.circle(screen_x * 0.15, screen_y * 0.15, 10)
    screen.fill()
    screen.stroke()
    screen.level(5)
    screen.circle(screen_x * 0.15, screen_y * 0.15, 10)
    screen.stroke()
  elseif mode_number==2 then
    for i=1,(math.floor(density*100)+20) do --density
      local rand_x=math.random(128)
      local rand_y=math.random(64)
      local bright=math.random(15)
      screen.level(bright)
      screen.pixel(rand_x,rand_y)
      screen.fill()
      screen.stroke()
    end
    screen.level(util.clamp(math.floor(brightness*15),0,15)) --brightness
    screen.circle(screen_x*0.5, 1, 30)
    screen.fill()
    screen.stroke()
    screen.level(15)
    screen.circle(screen_x*0.5, 1, 30)
    screen.stroke()
  --  screen.display_png(png2,0,0)
  elseif mode_number==3 then
    screen.level(util.clamp(math.floor(brightness*15),1,13))
    screen.circle(screen_x*0.5, screen_y*0.5, 20)
    screen.fill()
    screen.stroke()
    screen.level(0)
    screen.circle(screen_x*0.5-(density*15), screen_y*0.5, 20)
    screen.fill()
    screen.stroke()
    screen.level(util.clamp(math.floor(filter_freq/1000) + 2,5,15))
    screen.circle(screen_x*0.5+(density*15), screen_y*0.5, 20)
    screen.stroke()
  --  screen.display_png(png3,0,0)
  end

  

  
  screen.font_face(1)
  screen.font_size(8)
  screen.move(screen_x*0.9,screen_y*0.9)
  screen.level(0)
  screen.text_center('vol')
  screen.move(screen_x*0.91,screen_y*0.9)
  screen.level(10)
  screen.text_center('vol')
  screen.move(screen_x*0.92,screen_y*0.9)
  screen.level(15)
  screen.text_center('vol')
  
  screen.line_width(1)
  screen.move(screen_x*0.89 + 1, screen_y*0.8)
  screen.level(0)
  screen.line_rel(0,master_volume * -50)
  screen.stroke()
  screen.move(screen_x*0.9, screen_y*0.8)
  screen.level(5)
  screen.line_rel(0,master_volume * -50)
  screen.stroke()
  screen.move(screen_x*0.91, screen_y*0.8)
  screen.level(15)
  screen.line_rel(0,master_volume * -50)
  screen.stroke()
  screen.update()
end
