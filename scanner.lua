-- scanner (nc01-drone)
-- @markel_m
--
-- E1 volume          
--    change voice volume
-- E2 brightness      
--    change loop start pos
-- E3 density         
--    change loop length
-- K2 evolve          
--    change rate
-- K3 change worlds   
--    change voice to edit

sc = softcut -- typing shortcut
length = 0

fade_time = 0.1
loop_length = 2.0
loop_lengths = {2.0,2.0,2.0}

edit = 1
--cutoffs = {1000,10000,5000}
levels = {0.0,0.0,0.0} -- start at 0 maybe?
loop_starts = {1,1,1}
rates = {1.0,1.0,2.0}

positions = {0,0,0}

-- update positions in position list
function update_positions(i,pos)
  positions[i] = pos - 1
  redraw()
end

-- change rate for use with key 2
function next_rate(edit)
  if rates[edit] == 1.0 then rates[edit] = 2.0
  elseif rates[edit] == 2.0 then rates[edit] = -2.0
  elseif rates[edit] == -2.0 then rates[edit] = -1.0
  elseif rates[edit] == -1.0 then rates[edit] = 1.0
  end
end
    
function init()
  file = _path.code .. "nc01-drone/lib/dd.wav"
  sc.buffer_read_mono(file,0,0,-1,1,1)
  _,length,sr = audio.file_info(file)
  length = length/sr
  print(audio.file_info(file))

  for i=1,3 do
    sc.enable(i,1)
    sc.buffer(i,1)
    sc.level(i,levels[i])
    sc.loop(i,1)
    sc.loop_start(i,1)
    sc.loop_end(i,loop_length)
    sc.position(i,1)
    sc.play(i,1)
    softcut.fade_time(i,fade_time)
    softcut.level_slew_time(i,2)
    softcut.rate_slew_time(i,2)
    softcut.phase_quant(i,0.125)          -- quantize how often position is updated
    softcut.event_phase(update_positions) -- update the positions
    softcut.poll_start_phase()            -- start polling
    
    sc.rate(i,rates[i])
  end

  print("approaching...")
end

function redraw()
  screen.clear()
  
  for i=1,3 do
    -- before start point, bright line
    cursor = {['x']=positions[i]/length*115,['y']=i*16}
    if positions[i] < length then
      screen.level(15)
      screen.move(5,i*16)
      screen.line_rel(cursor.x,0)
    -- vertical start point indicator
      screen.move(5+cursor.x,cursor.y-3)
      screen.line_rel(0,5)
      screen.stroke()
    -- after start point, gray bar
      screen.level(2)
      screen.move(6+cursor.x,cursor.y)
      screen.line(120,i*16)
      screen.stroke()
    else
      screen.level(15)
      screen.move(5,i*16)
      screen.line_rel(115,0)
      screen.stroke()
    end
    -- print volume text
    if i == edit then screen.level(15) else screen.level(1) end
    screen.move(5,cursor.y+10)
    screen.text(string.format("%.1f",levels[i]))
    -- print rate
    screen.move(60,cursor.y+10)
    screen.text_center("x" .. string.format("%.1f",rates[i]))    
    -- print loop length
    screen.move(118,cursor.y+10)
    screen.text_right(string.format("%.2f",loop_lengths[i]))
  end

  screen.update()
end

function enc(n,d)
  -- enc 3 adjusts loop length
  if n==3 then
    loop_lengths[edit] = util.clamp(loop_lengths[edit]+d/4,0.5,10)
    sc.loop_end(edit,loop_starts[edit]+loop_lengths[edit])
  end
  -- enc 2 adjusts loop start point
  if n==2 then
    loop_starts[edit] = util.clamp(loop_starts[edit]+d,0,length-loop_lengths[edit])
    sc.loop_start(edit,loop_starts[edit])
    sc.loop_end(edit,loop_starts[edit]+loop_lengths[edit])
    if rates[edit] < 0 then
      sc.position(edit,loop_starts[edit]+loop_lengths[edit])
    else
      sc.position(edit,loop_starts[edit])
    end  
  end
  -- enc 1 sets volume of voice
  if n==1 then
    levels[edit] = util.clamp(levels[edit]+d/10,0.0,1.0)
    sc.level(edit,levels[edit])
  end
  redraw()
end

function key(n,z)
  -- key 2 changes playback direction (maybe rate too?)
  if n==2 and z==1 then
    next_rate(edit)
    sc.rate(edit,rates[edit])
  end
  if n==3 and z==1 then
    edit = edit % 3 + 1
  end
  redraw()
end

