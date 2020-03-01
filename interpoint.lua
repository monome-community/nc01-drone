-- interpoint (nc01-drone)
-- @autreland
--
--"'we call that the winding way,'"
--
-- E1 volume, in a sense, almost
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

sc = softcut -- typing shortcut

bctune = 1.1224
ddtune = 1.059
pitch = 1
world = 3
sky = 1
moon = 2
conductor = 1
play_mode = 0
cutoff = 5000
tick = 2
record = 0.66

lyd = {1, 1.1224, 1.2599, 1.4142, 1.4983, 1.6817, 1.8877, 2}
dor = {1, 1.1224, 1.1892, 1.3348, 1.4983, 1.6817, 1.7817, 2}
mixo = {1, 1.1224, 1.2599, 1.3348, 1.4983, 1.6817, 1.7817, 2}
transpose = {1, 1.1224, 1.059}
counterpoint = {8, 7, 5, 6, 7, 4, 2, 1}
--note = {1, 0, 2, 3, 4, 2, 0, 0, 3, 6, 5, 0, 7, 4, 0, 3}
note = {1, 2, 3, 4, 5, 6, 7, 8, 7, 6, 5, 4, 3, 2, 1, 2, 5}
--beat = {1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1}
beat = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}



function init()
  
  file = _path.code .. "nc01-drone/lib/eb.wav"
  sc.buffer_read_mono(file,3,0,8,1,1)
  _,length,sr = audio.file_info(file)
  length = length/sr
  print(audio.file_info(file))

  file = _path.code .. "nc01-drone/lib/bc.wav"
  sc.buffer_read_mono(file,26,30,2,1,1)
  _,length,sr = audio.file_info(file)
  length = length/sr
  print(audio.file_info(file))
  
  file = _path.code .. "nc01-drone/lib/dd.wav"
  sc.buffer_read_mono(file,74,60,3,1,1)
  _,length,sr = audio.file_info(file)
  length = length/sr
  print(audio.file_info(file))

  for i=1,3 do
    sc.enable(i,1)
    sc.buffer(i,1)
    sc.level(i,1.0)
    sc.loop(i,1)
    sc.post_filter_dry(i,0.0)
    sc.post_filter_lp(i,1)
    sc.level_cut_cut(i,4,1)
  end
  
  softcut.enable(4,1)
  softcut.buffer(4,2)
  softcut.level_input_cut(2,4,1)

  sc.loop_start(1,1)
  sc.loop_end(1,8)
  sc.position(1,1)
  sc.rate(1,1.0)
  sc.play(1,1)

  sc.loop_start(2,30)
  sc.loop_end(2,32)
  sc.position(2,30)
  sc.rate(2,(bctune * 0.5))
  --sc.play(2,1)

  sc.loop_start(3,60)
  sc.loop_end(3,63)
  sc.position(3,60)
  sc.rate(3,ddtune)
  sc.play(3,1)
  
  m = metro.init()
  m.time = tick
  m.count = -1
  m.event = harmony
  m:start()
  
  stars()
  
end

function enc(n,d)
  if n==1 then
    tick = util.clamp(tick + (d/100), .01, 3.99)
    m.time = tick
    m:start()
  elseif n==2 then
      cutoff = util.clamp(cutoff + (d*100),100,20000)
    for i = 1,3 do
      sc.post_filter_fc(i,cutoff)
      sc.post_filter_rq(i,(cutoff/1000))
    end
  elseif n==3 then
    record = util.clamp(record+d/100,0,1)
    sc.rec_level(4,record)
    delay()
  end
end

function key(n,z)
  
  if n == 3 and z == 1 then
      rift()
  elseif n == 2 and z == 1 then
   for i = 1,16 do
      note[i] = (math.random(8))
      beat[i] = (math.random(2) - 1)
    end
    if world == 1 then
      clouds()
    elseif world == 2 then
      dawn()
    elseif world == 3 then
      stars()
    end
  end
  
  --redraw()

end

function rift()
  
  if world == 1 then
      world = 2
      sky = 3
      moon = 1
      dawn()
  elseif world == 2 then
      world = 3
      sky = 1
      moon = 2
      stars()
  elseif world == 3 then
      world = 1
      sky = 2
      moon = 3
      clouds()
  end
    
    sc.play(moon,0)
    sc.level(moon, 1)
    
    sc.play(world,1)
    sc.level(world, 1)
    
    sc.play(sky,1)
    sc.level(sky, 1)
    
end

function harmony()
  
  if play_mode == 1 then
    pitch = note[(math.random(16))]
  elseif play_mode == 0 then
    pitch = note[conductor]
    if conductor < 17 then
      conductor = conductor + 1
    else
      conductor = 1
    end
  end
  
  if beat[conductor] > 0 then
    if world == 1 then
      sc.rate(world,(transpose[world] * dor[pitch]))
      sc.rate(sky,(transpose[sky] * lyd[counterpoint[pitch]]))
    elseif world == 2 then
      sc.rate(world,(transpose[world] * lyd[pitch]))
      sc.rate(sky,(transpose[sky] * dor[counterpoint[pitch]]))
    elseif world == 3 then
      sc.rate(world,(transpose[world] * mixo[pitch]))
      sc.rate(sky,(transpose[sky] * mixo[counterpoint[pitch]]))
    end
    
  delay()
  
  end
  
  redraw()
  
end

function delay()
  
  sc.buffer(4,2)
  sc.rate(4,0.5)
  sc.loop(4,1)
  sc.loop_start(4,1)
  sc.loop_end(4,tick)
  sc.position(4,1)
  sc.play(4,1)
  sc.rec(4,1)
  sc.rec_level(4,record)
  sc.pre_level(4,0.5)
  sc.level(4,1)
  sc.fade_time(2,0.02)

end

galaxy = 0
chart = {}

function stars()
  galaxy = math.random(128) + 72
  screen.clear()
  for i = 1, galaxy do
    chart[i] = math.random(72)
    screen.pixel(i, chart[i])
    screen.fill()
    screen.level(math.random(16) - 1)
  end
  screen.update()
end

bank = 0
striations = {}


function clouds()
  bank = math.random(128) + 72
  screen.clear()
  for i = 1, bank do
    striations[i] = math.random(72)
    screen.circle(i, striations[i], (striations[i] / 9))
    screen.fill()
    screen.level(math.random(16) - 1)
  end
  screen.update()
end

rays = 0

function dawn()
  rays = math.random(128)
  screen.clear()
  for i = 1, rays do
    screen.circle(64, 64, i)
    screen.fill()
    screen.level(math.random(16) - 1)
  end
  screen.circle(64, 64, 32)
  screen.fill()
  screen.level(15)
  screen.update()
end

function redraw()
  screen.clear()
  
  if world == 3 then
  for i = 1, galaxy do
    screen.pixel(i, chart[i])
    screen.fill()
    screen.level(math.random(16) - 1)
  end
  elseif world == 2 then
    for i = 1, rays do
      screen.circle(64, 64, i)
      screen.fill()
      screen.level(math.random(16) - 1)
    end
    screen.circle(64, 64, 32)
    screen.fill()
    screen.level(15)
  elseif world == 1 then
    for i = 1, bank do
      screen.circle(i, striations[i], (striations[i] / 9))
      screen.fill()
      screen.level(math.random(16) - 1)
    end
  end
  
  screen.update()
end
