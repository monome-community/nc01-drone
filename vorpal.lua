---
-- ?
---

which_world = 1

-- order of includes matters in this case

include ('lib/vorpal/util')  -- extra utilities
include ('lib/vorpal/worlds') -- world data
include ('lib/vorpal/cuts')  -- softcut setup

function set_world(ix)
   print('setting world: ' .. ix)
   which_world = ix
   cut_set_world(ix)
end

include ('lib/vorpal/moves') -- sequence
include ('lib/vorpal/eyes')  -- visuals
--include ('lib/vorpal/maps')  -- mappings
include ('lib/vorpal/hands')  -- logic

function init()
   begin_cuts()
   begin_moves()
   --begin_eyes()
   begin_hands()
   
   params:add({type="number", id="bps", name="BPS", 
     min=1, max=256, default=88,
     action = function(bps)
       set_tick_base(1/bps)
    end})
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
