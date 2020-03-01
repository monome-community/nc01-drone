-- Nimbea (nc01-drone)
-- @jaggednz
--

-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

-- black mesa
function world_one()
  screen.level(15)
  reverse_node_idx = #scape.nodes 
  screen.move(0,scape.nodes[1] or 0)
  for p = 1,#scape.nodes do
    offset = ((32-#scape.nodes)*4)-(frame%4)
    screen.line(p*4+offset or 0,scape.nodes[p] or 0)
  end
  screen.stroke()
end

hills = { 27,29,47,43,44,34,56,49,54,63 }

function draw_temple()
  screen.aa(1)

  screen.level(1)
  screen.move(0,64)
  screen.line(0,20)
  screen.line_rel(10,-2)
  screen.line_rel(20,-4)
  screen.line_rel(10,5)
  screen.line_rel(20,5)
  screen.line_rel(10,5)
  screen.line_rel(20,15)
  screen.line_rel(10,3)
  screen.line_rel(20,4)
  screen.line_rel(10,5)
  screen.line_rel(20,-2)
  screen.line_rel(10,5)
  screen.line_rel(20,15)
  screen.line_rel(10,-5)
  screen.line_rel(20,-2)
  
  screen.line(64,128)
  screen.fill()
  
  screen.level(0)
  screen.move(70,46)
  screen.line(70,30)
  screen.line(80,31)
  screen.line(80,47)
  screen.fill()
  
  screen.level(0)
  screen.move(84,46)
  screen.line(84,31)
  screen.line(92,32)
  screen.line(92,47)
  screen.fill()
  
  screen.level(0)
  screen.move(64,29)
  screen.line(64,32)
  screen.stroke()
  screen.level(2)
  screen.curve(64,32, 72,28, 82,16)
  screen.stroke()
  screen.level(3)
  screen.move(82,16)
  screen.curve(82,16, 88,28, 96,34)
  screen.line(96,31)
  screen.stroke()
  
  screen.level(0)
  screen.move(59,49)
  screen.line(59,52)
  screen.stroke()
  
  
  screen.move(59,52)
  screen.curve(59,52, 72,48, 82,36)
  screen.curve(82,36, 88,48, 101,54)
  screen.fill()
  screen.level(2)
  screen.move(82,36)
  screen.curve(82,36, 88,48, 101,54)
  screen.stroke()
  
  screen.level(0)
  screen.move(101,54)
  screen.line(101,51)
  screen.stroke()
  screen.move(63,64)
  screen.line(63,52)
  screen.line(97,54)
  screen.line(97,64)
  screen.fill()
  
  screen.move(0,64)
  screen.line(0,40)
  for p = 1,9 do
    screen.line(p*6,hills[p])
  end
  screen.line(60,64)
  screen.fill()
end
  

-- dancing in the puddles
function world_two()
  draw_temple()
  screen.level(1)
  for p = 1,#scape.nodes do
    rain_falls = (scape.nodes[p] or 0) * math.random()
    rain_falls_down = rain_falls+(32*math.random())
    screen.level(1)
    screen.move(p*4,rain_falls)
    screen.line(p*4+2,rain_falls_down)
    screen.stroke()
  end
end

--[[
var rotateZ3D = function(theta) {
    var sin_t = sin(theta);
    var cos_t = cos(theta);
    
    for (var n = 0; n < nodes.length; n++) {
        var node = nodes[n];
        var x = node[0];
        var y = node[1];
        node[0] = x * cos_t - y * sin_t;
        node[1] = y * cos_t + x * sin_t;
    }
};  
  
]]--

function rotateZ(nodes,theta)
    sin_t = math.sin(theta)
    cos_t = math.cos(theta)
    
    for n = 1,#nodes do
      x = nodes[n].x
      y = nodes[n].y
      nodes[n].x = x * cos_t - y * sin_t;
      nodes[n].y = y * cos_t + x * sin_t;
    end
    return nodes
end

incal_top = { {x=-16,y= 16},{x=-16,y=-16},{x= 16,y=-16},{x= 16,y= 16} }
incal_bottom = { {x=-16,y= 16},{x=-16,y=-16},{x= 16,y=-16},{x= 16,y= 16} }

-- rain drops dancing around the rotating incal ...
function world_three()
  rotateZ(incal_top,0.03)
  rotateZ(incal_bottom,-0.031)
  
  for n = 1,4 do
    screen.level(10+(incal_bottom[n].y//4))
    screen.move(64,59)
    screen.line(incal_bottom[n].x+64,(incal_bottom[n].y/4)+34)
    screen.stroke()
  end
  screen.move(incal_bottom[4].x+64,(incal_bottom[4].y/4)+34)
  for n = 1,4 do
    screen.line(incal_bottom[n].x+64,(incal_bottom[n].y/4)+34)
  end
  screen.fill()
  
  
  screen.level(0)
  screen.move(incal_top[4].x+64,(incal_top[4].y/4)+30)
  for n = 1,4 do
    screen.line(incal_top[n].x+64,(incal_top[n].y/4)+30)
  end
  screen.fill()
  screen.level(10)
  screen.move(incal_top[4].x+64,(incal_top[4].y/4)+30)
  for n = 1,4 do
    screen.line(incal_top[n].x+64,(incal_top[n].y/4)+30)
  end
  screen.stroke()
  
  for n = 1,4 do
    screen.level(10+(incal_top[n].y//4))
    screen.move(64,5)
    screen.line(incal_top[n].x+64,(incal_top[n].y/4)+30)
    screen.stroke()
  end
  
end

worlds = {
  {
    title = '1',
    file  = 'dd.wav',
    length= 136,
    draw  = world_one
  },
  {
    title = '2',
    file  = 'bc.wav',
    length= 166,
    draw  = world_two
  },
  {
    title = '3',
    file  = 'eb.wav',
    length= 128, --Actually 337
    draw  = world_three
  }
}
world = 1
glitch = false
t = 1 --preload time forward, many movements move slowly at the start
title_fade = 15
params_fade = 0

volume = 60
brightness=48
density=100

scape = {
  nodes = {},
  max_nodes = 32,
  offset = 0
}

-- OOP voices
sc_voices = {
  number = 1,
  channel = 1
}
function sc_voices:enable()
end
function sc_voices:init()
end
function sc_voices:set_buffer_ch(ch)
end

movements = {
  function(t) return t*((t>>3|t>>12)*25+(t*4)) end,
  function(t) return t//5|t*2&t//20>>1|45*t*-t//666|t//12|t//666>>2 end,
  function(t) return t*((t>>9|t>>13)&25&t>>6) end,
  function(t) return ((t>>3|t>>12)*25+(t*4)) end
}

function scape.add_node(node)
    table.insert(scape.nodes,node)
    -- remove oldest nodes
    while #scape.nodes > scape.max_nodes do table.remove(scape.nodes,1) end
end

current_movement = 1
current_buffer = 1
voices = 6
current_voice = 1

voice_rate = { 1,1,1,1,1.0,1.0 }
voice_panning = { 0.25, 0.5, -0.5, -0.25,0.75,-0.75 }
voice_pan_rate = { 0.25 , 2, 2, 0.25, 1.5, 1.5 }
voice_lpf_cf = {  }
voice_filter_rate = { 0.25 , 2, 2, 0.25, 1.5, 1.5 }
function load_world_buffer()
  -- dd.wav ~ 136sec - default
  -- bc.wav ~ 166sec - rain
  -- eb.wav ~ 337sec - singing start ~ 240sec
	file = _path.code .. "nc01-drone-jagged/lib/" .. worlds[world].file
	print("opening world of ".. file)
  softcut.buffer_read_mono(file,0,0,-1,1,current_buffer)
end
  

function init()
  print("start")
  math.randomseed(os.time()) -- and the world was born, a rain drops dancing around wheels within wheels ...
  load_world_buffer()
  for v = 1,voices do
    softcut.buffer(v,current_buffer)
    softcut.loop(v,1)
    softcut.loop_start(v,0)
    softcut.loop_end(v,2)
    --softcut.loop_end(v,3)
    softcut.position(v,1)
    softcut.fade_time(v,1.2)
    softcut.level(v,0.0) -- start quiet!
    softcut.level_slew_time(v,40) -- move slowly
    softcut.pan(v,voice_panning[v])
    softcut.pan_slew_time(v,voice_pan_rate[v])
    softcut.rate(v, voice_rate[v] - ((v-1)/500)) --subtle variation in the playback rate per voice TODO add LFO?
    softcut.play(v,1)
  end

  print("approaching...")
  beat = metro.init(world_update, 0.25,-1)
  beat:start()
end

frame=0
function world_update()
  if frame%4==0 then shift() end
  redraw()
  frame=frame+1
end

function shift()
  if frame%(61-brightness)==0 then t = t+brightness end
  new_pos = (movements[current_movement](t) % (worlds[world].length * 10 ))/10 --((t>>3|t>>6)*25+(t*4))
  softcut.buffer(current_voice,current_buffer)
  softcut.position(current_voice,new_pos)
  softcut.level(current_voice,volume/100) -- fade in
  --Flip panning occasionally
  if (t%7 == 1) then 
    glitch=true
    voice_panning[current_voice] = voice_panning[current_voice] * -1 
    print("Pan flip "..current_voice)
  end
  vpan = (density/100) * (voice_panning[current_voice]*math.random())
  softcut.pan(current_voice,vpan)
  print("t=" .. t .. " Assigning voice".. current_voice .." to position "..new_pos .. " panning " .. vpan)
  softcut.enable(current_voice,1)
  
  scape.add_node(new_pos//4)
  
  current_voice = current_voice + 1
  if current_voice > voices then current_voice = 1 end
end
  

function enc(n,d)
    if n == 1 then
      -- E1 volume  
      volume = util.clamp(volume + d,0,100)
    end
    if n == 2 then
      -- E2 brightness 
      brightness = util.clamp(brightness + d,1,60)
    end
    if n == 3 then
      -- E3 density
      density = util.clamp(density + d,0,100)
    end
    params_fade = 15
end

function key(n,z)
  if (n==2 and z==1) then
    -- K2 evolve
    t = t + (2048*math.random())//10
    current_movement = current_movement+1
    if current_movement > #movements then current_movement = 1 end
    print('evolving ...'..current_movement)
  end
  if (n==3 and z==1) then
    -- K3 change worlds
    current_buffer = current_buffer == 1 and 2 or 1
    print("buffer switched to " .. current_buffer)
    softcut.buffer_clear_channel(current_buffer)
    if (world == 3) then 
      world = 1
    else
      world = world+1
    end
    title_fade = 15 -- Show the title fade
    load_world_buffer()
  end
end

function glitchDraw()
  screen.level(3)
  screen.font_face(1)
  screen.font_size(50)
  screen.text_center(""..world)
  screen.move(64,50)
  screen.level(title_fade)
  screen.font_face(2)
  screen.font_size(50)
  screen.text_center(""..world)
  glitch=false  
end
  

function redraw()
  screen.clear()
  screen.aa(1)
  
  worlds[world].draw()
 
  if (params_fade>0) then
    screen.level(params_fade)
    screen.font_face(1)
    screen.font_size(8) 
    screen.move(0,9)
    screen.text("Vol. "..volume)
    screen.move(0,16)
    screen.text("Bri. ".. brightness)
    screen.move(0,24)
    screen.text("Den. "..density)
    params_fade = params_fade -1
  end
  
  screen.move(64,50)
  if (title_fade>0) then
    if glitch == true then
      glitchDraw()
    else
      screen.level(title_fade)
      screen.font_face(5)
      screen.font_size(50)
      screen.text_center(""..world)
      title_fade = title_fade-1
    end
  end
  
  screen.update()
end


