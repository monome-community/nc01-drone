-- planetary (nc01-drone)
-- @infovore
--
-- with apologies 
-- to michel gondry
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

local utils = include('lib/planetary/utils')
local graphics = include('lib/planetary/graphics')

sc = softcut -- typing shortcut

-- graphics things
horizon_height = 28
world_stars = {}

-- sound things
current_world = 1
level = {1,0,0}
pulse_duration = 2

brightnesses = {1,1,1}
probs = {0.2,0.2,0.2} -- probabilities per world

start_points = {1,181,30}
loop_points = start_points
buffer_indexes = {1,1,2}

events = {} -- ie, things in the landscape.

function init_all_events()
  for world=1,3 do
    events[world] = {}
    init_world_events(world)
  end
end

function init_world_events(world)
  for step = 1,16 do
    event = {}
    event.x = (step-1) * 16
    event.y = utils.random_between(horizon_height+5,64)
    event.seed = math.random()
    events[world][step] = event
  end
end

function init()
  init_all_events()
  graphics.init_all_stars()
  file1 = _path.code .. "nc01-drone/lib/dd.wav"
  file2 = _path.code .. "nc01-drone/lib/bc.wav"
  file3 = _path.code .. "nc01-drone/lib/eb.wav"
  sc.buffer_read_mono(file1,0,0,-1,1,1)
  sc.buffer_read_mono(file2,0,180,-1,1,1)
  sc.buffer_read_mono(file3,0,0,-1,1,2)

  for i=1,3 do
    sc.enable(i,1)
    sc.buffer(i,buffer_indexes[i])

    sc.level(i,level[i])

    sc.loop(i,0)
    sc.rate(i,1.0)
    sc.play(i,0)

    sc.post_filter_dry(i,0)
    sc.post_filter_lp(i,1)
    sc.post_filter_hp(i,0)
    sc.post_filter_bp(i,0)
    sc.post_filter_br(i,0)
    sc.post_filter_rq(i,0.6)

    freq = util.linexp(0, 1, 60, 12000, brightnesses[i])
    sc.post_filter_fc(i,freq)

    sc.loop_start(i,start_points[i])
    sc.loop_end(i,start_points[i]+pulse_duration)
    sc.position(i,start_points[i])

  end

  animation_clock = metro.init(tick, (1.0/60), -1)
  animation_clock:start()

  world1_clock = metro.init(world1_tick, (1.0/40), -1)
  world1_clock:start()

  world2_clock = metro.init(world2_tick, (1.0/30), -1)
  world2_clock:start()

  world3_clock = metro.init(world3_tick, (1.0/20), -1)
  world3_clock:start()
end

function tick(stage)
  redraw(stage)
end

function world1_tick(stage)
  world_tick(1)
end

function world2_tick(stage)
  world_tick(2)
end

function world3_tick(stage)
  world_tick(3)
end

function world_tick(world)
  world_events = events[world]
  utils.dump(world_events)
  for i = 1,#world_events do
    e = world_events[i]
    e.x = e.x - util.linlin(horizon_height+5,64,0.5,1.5,e.y)
    if e.x < 0 then
      e.x = 128
      if e.seed < probs[world] then
        sc.position(world, loop_points[world])
        sc.play(world,1)
      end
    end
  end
end

function enc(n,d)
  if n==1 then
    level[current_world] = util.clamp(level[current_world] + d/100,0,1)
    sc.level(current_world, level[current_world])
  elseif n==2 then
    brightnesses[current_world] = util.clamp(brightnesses[current_world] + d/100,0,1)
    freq = util.linexp(0, 1, 60, 6000, brightnesses[current_world])
    sc.post_filter_fc(current_world,freq)
  elseif n==3 then
    -- adjust world probablity
    prob = probs[current_world] + d/100.0
    probs[current_world] = util.clamp(prob,0,0.9)
  end
end

function key(n,z)
  if n==3 and z==1 then
    current_world = current_world % 3 + 1
  elseif n==2 and z==1 then
    init_world_events(current_world)
    pick_new_loop(current_world)
  end
end

function pick_new_loop(world)
  if world == 1 then
    new_start = utils.random_between(1,60)
  elseif world == 2 then
    new_start = utils.random_between(180,300)
  else
    new_start = utils.random_between(20,400)
  end

  loop_points[world] = new_start
  sc.loop_start(world, new_start)
  sc.loop_end(world, new_start+pulse_duration)
  sc.position(world, new_start)
end

function redraw(stage)
  screen.clear()
  screen.line_width(1)
  screen.line_cap("butt")
  screen.level(16)
  screen.move(0,5)
  screen.aa(1)
  screen.text(current_world)
  graphics.draw_stars()
  graphics.draw_sun(current_world)
  graphics.draw_horizon(current_world)
  graphics.draw_landscape(current_world)
  screen.update()
end
