
function begin_hands()
   
   ----------------
   ----feed
   feed_max = 128
   params:add_number("feed", "feed", 0, feed_max)
   params:set_action("feed", function(feed)
			local x, rec, pre
			x = feed/feed_max
			pre = (math.cos(x * math.pi) + 1) / 2
			rec = (math.cos((x+1) * math.pi) + 1) / 2
			for i=1,6 do 
			   softcut.rec_level(i,rec)
			   softcut.pre_level(i,pre)
			end
   end)
   
   --------------------
   --- bright
   bright_max = 128
   params:add({type="number", id="bright", name="bright",
	       min=1, max=bright_max, default=0,
	       action = function(bright)
		  local br = 0
		  local bm_2 = bright_max/2
		  local lp = (bright_max - bright)/bright_max
		  local bp = ((bm_2)-math.abs(bright-(bm_2)))/bm_2 + 0.25
		  if bp > (1-lp) then bp = (1-lp) end
		  local dry = 1 - (lp+bp)
		  lp = lp * 0.8
		  bp = bp * 0.8
		  br = br * 0.8
		  rq = math.pow(2, ((1-bright)/bright_max)*4)
		  if rq > 1 then rq = 1 end
		  if rq < 0.041666 then rq = 0.041666 end
		  local w -- width per voice
		  for i=1,3 do
		     w = math.cos((i*0.25 + 1)*math.pi)
		     set_voice_width(i, w)
		  end
		  for i=1,6 do		     
		     softcut.post_filter_dry(i, dry)
		     softcut.post_filter_lp(i, lp)
		     softcut.post_filter_bp(i, bp)
		     softcut.post_filter_br(i, br)
		     softcut.post_filter_rq(i, rq)
		  end
		  
   end})
   
   --------------------
   ---- dense
   -- density affects loop length (as a ratio of key hz)
   ----  with minimum density, all ratios are medium high
   ----- with max density, two voices loop fast (in audio range)
   ------ and one loops very slow..
   
   dense_max = 128
   params:add({type="number", id="dense", name="dense", 
	       min=1, max=dense_max, default=1,
	       action = function(dense)
		  local ridx = { dense % 4, (dense+2) % 4, (dense+5) % 4 }
		  local r = tab_map(ridx, function(idx) 
				       local pair = worlds[world_keys[which_world]].ratios[idx+1]
				       return pair[1] / pair[2]
		  end)

		  local mul = { 
		     math.pow(2, 9 - (dense / dense_max * 6)),
		     math.pow(2, 8 - (dense / dense_max * 6)),
		     math.pow(2, 7 + (dense / dense_max * 4))
		  }
		  
		  for i=1,3 do
		     voice_loop_len_ratio[i] = r[i] * mul[i]
		     update_voice_loop(i)
		  end
   end})
end

delta_volume = function(z)
   params:delta("feed", z)
end

delta_bright = function(z)
   params:delta("bright", z);
end

delta_dense = function(z)   
   params:delta("dense", z);
end

local evolve_count = 1
press_evolve = function(z)
   for i=1,evolve_count do
      cut_advance_voice_rate()
   end
   if evolve_count == 1 then 
      evolve_count = 2
   else evolve_count = 1
   end
end

local world = 1
press_world = function(z)
   if z == 1 then
      world = world + 1
      if world > 3 then world = 1 end
      set_world(world)
   end
end

