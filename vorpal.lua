-- vorpal (nc01-drone
-- @zebra
--
-- E1 feed
-- E2 bright
-- E3 dense
-- K2 evo
-- K3 world

which_world = 1

-- order of includes matters in this case

include ('lib/vorpal/util')  -- extra utilities
include ('lib/vorpal/worlds') -- world data
include ('lib/vorpal/cuts')  -- softcut meta

function set_world(ix)
   which_world = ix
   cut_set_world(ix)
end

include ('lib/vorpal/moves') -- sequence
include ('lib/vorpal/hands')  -- logic

function init()
   begin_cuts()
   begin_moves()
   begin_hands()
   
   params:add({type="number", id="bps", name="BPS", 
     min=1, max=256, default=88,
     action = function(bps)
       set_tick_base(1/bps)
   end})

   screen_tick = metro.init(function() redraw() end, 1/30, -1)
   screen_tick:start()
end

function enc(n,z) 
  if n == 1 then delta_volume(z) end
  if n == 2 then delta_bright(z) end
  if n == 3 then delta_dense(z) end
end

function key(n,z) 
  if n == 2 then press_evolve(z) end
  if n == 3 then press_world(z) end
end



function redraw()
   screen.clear()
   -- feedback in background
   screen.level(math.floor(params:get("feed") /feed_max *16))
   screen.rect(0, 0, 128, 64)
   screen.fill()

   -- draw things for positions
   --- brightness == brightness
   screen.level(math.floor(params:get("bright") /bright_max *12 +4))
   for i,v in ipairs(voice_pos) do
      w = v*126
      x = (64-w)/2
      h = 64/5
      y = h*i
      screen.rect(x, y, w, h)
      screen.fill()
   end
   for i,v in ipairs(voice_loop_len_ratio) do
      h = math.floor(v)
      if h > 62 then h = 62 end
      y = (64-h)/2
      w = 128/7
      x = w*(i+1)
      screen.rect(x, y, w, h)
      screen.level(1)
      screen.fill()
   end
   
   screen.update()
end

