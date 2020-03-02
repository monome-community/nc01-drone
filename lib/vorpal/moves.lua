
voice_pos = { 0, 0, 0 } 
voice_step = { 1, 1, 1 }

tick_count_list = {}
tick_count = { 0, 0, 0 }

cur_pos_ratio = { 1, 1, 1 }
cur_pos_ratio_flip = { false, false, false }

for k,z in pairs(worlds) do
  local count
  local r = z['ratios']
  for i,p in ipairs(r) do 
    local q -- next ratio, after wrapping
    if i > 3 then 
      q = r[1]
    else 
      q = r[i+1]
    end
    count = lcm(p[1]+q[1], p[2]+q[2])
    tick_count_list[#tick_count_list + 1] = count
  end
end

local calc_voice_step = function(i)
   local ratios = worlds[world_keys[which_world]].ratios
   local num = ratios[cur_pos_ratio[i]][1]
   local denom = ratios[cur_pos_ratio[i]][2]
  if cur_pos_ratio_flip[i] then
    voice_step[i] = voice_step[i] * num / denom
    cur_pos_ratio_flip[i] = false
  else	  
    voice_step[i] = voice_step[i] * denom / num       
    cur_pos_ratio_flip[i] = true
  end
end

local wrap_voice_step = function(x)
   while x < 0.001953125 do
      x = x * 2
   end
   while x > 0.015625 do
      x = x / 2
   end
   return x
end

local apply_voice_step = function(i)
   local pos =  voice_pos[i] + voice_step[i]
   while pos < 0 do pos = pos + 1 end
   while pos > 1 do pos = pos - 1 end
  --print(i, voice_step[i], voice_pos[i])
   set_voice_pos(i, pos)
   
  voice_pos[i] = pos
end

local handle_tick = function(count)
  for i=1,3 do
    tick_count[i] = tick_count[i] + 1
    --print(i, tick_count[i])
    if tick_count[i] == tick_count_list[i] then
      tick_count[i] = 0
      cur_pos_ratio[i] = cur_pos_ratio[i] + 1
      if cur_pos_ratio[i] > 4 then cur_pos_ratio[i] = 1 end
      calc_voice_step(i)
      voice_step[i] = wrap_voice_step(voice_step[i])
      apply_voice_step(i)
    end  
  end
end


local tick_base = 1/32
begin_moves = function()   
   tick = metro.init(handle_tick, tick_base)
   tick:start()
end

set_tick_base = function(x)
   tick_base = x
   tick.time = tick_base
end
