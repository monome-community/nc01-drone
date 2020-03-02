-- three worlds 
-- by @junklight - Feb 2020 
-- as part of an exercise on 
-- lines when I should have been 
-- working on other things
-- 
-- three aleatoric sound worlds
-- and accompanying 
-- visualisations
-- be patient - worlds 2 and 3 
-- take a few seconds for the 
-- sound to find its way 
-- through the system to the
-- output 
-- 
-- yes there are glitches and 
-- distortions! I like them :-)
--
-- each world resets softcut -
-- was easier than tracking down
-- what I'd failed to reset
-- manually 

-- IMPROVEMENTS (things that could be done but won't)
-- file/dir on params menu to open another set of files - would need file length detection 
--  might the worlds have been better as actual classes? possibly 
--  some kind of quantisation of rates into notes/harmonic series may have been interesting 
--  lfo/midi control - beyond the brief but might be nice to have it automatically swell and die back 

-- global variables 
local current_world = math.random(1,3)
local screen_refresh
local ctl_disp = 0
local ctl_name = ""

-- pick a *different* random number than c 
function pick_another(l,h,c)
  local ret = math.random(l,h)
  while true do 
    if ret ~= c then
      break
    end
    ret = math.random(l,h)
  end
  return ret
end

-- src files and buffer lengths - probably could get these accurate or even 
-- get them from the file but sod it - can't be arsed 
local src = { 
  [1] = { ["name"] = _path.code .. "nc01-drone/lib/bc.wav" , ["buflen"] = 148 } , 
  [2] = { ["name"] = _path.code .. "nc01-drone/lib/dd.wav" , ["buflen"] = 130 } , 
  [3] = { ["name"] = _path.code .. "nc01-drone/lib/eb.wav" , ["buflen"] = 300 } , 
  }

-- world one 
-- 
-- play single random sections 
-- through the buffers 
-- at different rates 

-- world one variable
-- store the lengths and buffer numbers 
-- for each voice 
local wo_buflen = { }
local wo_bufnum = { } 
local wo_filenums = { -1 , -1 }
local wov_d = 30 / 6
local wov_voices = { {0,0 ,0 ,0 ,0 } , {0,0 ,0 ,0,0} , {0,0 ,0 ,0,0} , {0,0 ,0 ,0,0} , {0,0 ,0 ,0,0} , {0,0 ,0 ,0,0} }

-- load a random file into each buffer 
-- and assign to a voice 
-- for the moment this is the whole of the "evolve" functionality 
-- world one doesn't use any buffers for playing so we can load 
-- two files 
function world_one_load_files() 
  local lens = {}
  for buf = 1,2 do 
    local fnum = pick_another(1,3,wo_filenums[buf])
    wo_filenums[buf] = fnum
    file = src[fnum].name
    print("loading " .. file)
    lens[buf] = src[fnum].buflen
    softcut.buffer_read_mono(file,0,0,-1,1,buf)
  end
  for idx = 1,6 do 
    local pick = math.random(1,2)
    wo_buflen[idx] = lens[pick]
    wo_bufnum[idx] = pick
  end
end

function world_one_evolve()
  world_one_load_files()
end

-- helper functions 
function world_one_density()
  return math.floor((( params:get("density") / 100.0 ) * 5.0) + 1.0)
end

function world_one_brightness()
    return ( params:get("brightness") / 100.0 ) * 2.0
end

-- use the phase function to see if 
-- a) we've done a single play through of head - if so 
-- send it on its way 
-- b) see if we've changed settings and if so react 
-- this does mean knobs aren't very responsive 
-- but this is slow sound stuff and so not caring 
-- make a metro that goes faster or change phase quantum
-- if you are actually bothered 
function world_one_phase(v,p)
  -- debug 
  -- print("phase " .. v .. " - " .. p .. " (" .. voices[v] .. ")")
  wov_voices[v][1] = p
  if v > world_one_density() then
    softcut.play(v,0)
    voices[v] = -500000
    wov_voices[v] = {0,0 ,0 ,0 ,0 } 
  else
    if voices[v] > 0 then
      if p >= voices[v] then 
        voices[v] = math.floor( start_world_one_voice(v) ) - 1.0
      end
    else 
      if p <= -1 * voices[v] then 
        voices[v] = math.floor( start_world_one_voice(v) ) - 1.0
      end
    end
  end
  -- restart any new voices enabled by density
  for v = 1,world_one_density() do 
    if voices[v] == -500000 then 
      voices[v] = math.floor( start_world_one_voice(v) ) - 1.0
    end
  end
end

-- init our world 
-- enable voices 
-- reset the length tracker 
-- kick all the active voices off 
-- and set the phase poll going 
function world_one_start()
  softcut.reset()
  softcut.buffer_clear()
  world_one_load_files()
  print("Starting world one")
  for idx = 1,6 do 
    softcut.enable(idx,1)
    voices[idx] = -500000
  end
  for idx = 1,world_one_density() do
    voices[idx] = math.floor(start_world_one_voice(idx))  - 1.0
  end
  softcut.event_phase(world_one_phase)
  softcut.poll_start_phase()
end

-- just turn the heads off for now 
function world_one_close() 
  for idx = 1,6 do 
    softcut.play(idx,0)
  end
  softcut.poll_stop_phase()
end

-- world one is just lots of voices running 
-- each one running through start to end and then 
-- moving elsewhere 
-- couldn't get the 1 shot mode working for some reason 
-- so just used the phase function to spot when they complete 
-- and move them on
function start_world_one_voice( n ) 
  local start = math.random() * wo_buflen[n] 
  local rnge = start + math.random() * 10 
  local rate = ( math.random() * world_one_brightness() ) + 0.1
  local pan = ( math.random() * 2.0 ) - 1.0
  local q = (math.random() * 3.0)  + 0.1
  local dir = 1 
  if math.random() > 0.5 then
    dir = -1
  end
  softcut.play(n,0)
  softcut.buffer(n,wo_bufnum[n])
  softcut.level(n,params:get("volume"))
  softcut.loop(n,1)
  softcut.loop_start(n,start)
  softcut.loop_end(n,rnge)
  wov_voices[n] = { start , rnge , dir , start }
  softcut.position(n,start)
  softcut.rate(n,rate * dir )
  softcut.pan(n,pan)
  softcut.post_filter_bp(n,2.0)
  softcut.post_filter_fc(n,rate * 1000)
  softcut.post_filter_rq(n,q)
  softcut.play(n,1)
  -- debug
  --print("Starting voice " .. n .. " start " .. start .. " range " .. rnge .. " rate " .. rate)
  return  rnge * dir
end

function world_one_volume(x)
  for idx = 1,6 do 
    softcut.level(idx,x)
  end
end

function world_one_visualise()
  screen.clear()
  -- the very rough and ready detection 
  -- of end of plays using a low quantum phase 
  -- kind of makes this bit not work as I intended  
  -- but whatever - too much work for too little gain 
  -- to make it accurate 
  -- and it looks ok 
  for idx = 1,6 do
    local a = wov_voices[idx][1]
    local r = wov_voices[idx][2]
    local s = wov_voices[idx][4]
    if r ~= 0 then
      local pos = ((a - s) / (r - s)) * 360 
      screen.level(idx * 2 ) 
      screen.move(64,32)
      screen.arc(64,32,wov_d * (7 - idx ),math.rad(pos),math.rad(360))
      screen.fill()
    end
  end
  for idx = 1,6 do
    local a = wov_voices[idx][1]
    local b = wov_voices[idx][2]
    local ar =  (a/wo_buflen[idx]) * 360
    local br =  (b/wo_buflen[idx]) * 360
    screen.arc(64,32,wov_d * ( 7 - idx ),math.rad(ar),math.rad(br))
    screen.level(15)
    screen.line_width(3)
    screen.stroke()
  end
  screen.update()
end

-- world two 
-- load file into buffer two 
-- first 10 seconds of buffer one are for building up a loop with the output from
-- voices 1 - 4 which do random looping with different rates - very tiny loops 
-- using voices 5/6 for recording/feedback/play of the  output buffer

-- world two variables 
local wtwom
local wt_sixrate 
local wt_density
local wt_buflen
local wt_five_len = 10.0
local wtv_circs = {}
local wtv_clock = 0

-- worlds two and three use a buffer for playback/looping 
-- so just load one file
function world_two_load_files() 
  local fnum = math.random(1,3) 
  file = src[fnum].name
  print("loading " .. file)
  wt_buflen = src[fnum].buflen
  softcut.buffer_read_mono(file,0,0,-1,1,2)
end

-- yeah yeah - evolve just loads a different file
function world_two_evolve()
  world_two_load_files()
end


-- there are 4 voices in world two 
-- all similar to world 1 *except* 
-- they are allowed to loop 
function world_two_voice( n ) 
  local start = 20.0 + math.random() * ( wt_buflen  - 20.0 )
  local rnge = start +  ( math.random() / 20.0 )
  local rate = ( math.random() * world_one_brightness() ) + 0.1
  local pan = ( math.random() * 2.0 ) - 1.0
  local dir = 1 
  if math.random() > 0.5 then
    dir = -1
  end
  softcut.play(n,0)
  softcut.buffer(n,2)
  softcut.level(n,0.0)
  softcut.loop(n,1)
  softcut.loop_start(n,start)
  softcut.loop_end(n,rnge)
  softcut.position(n,start)
  softcut.rate(n,rate * dir )
  softcut.pan(n,pan)
  softcut.fade_time(n,2.0)
  softcut.play(n,1)
end

function world_two_brightness_rate()
    return 0.5 + ( params:get("brightness") / 100.0 ) * 0.5
end

function world_two_density()
    return 0.4 + ( params:get("density") / 100.0 ) * 0.5
end

-- occasionally move voices 1,4 around randomly 
function world_two_tick() 
  if math.random() < world_two_density() then 
    local v = math.random(1,4)
    world_two_voice(v)
  end
  -- brightness alters the playback rate 
  -- look see if we need to change it 
  -- (and do so if necessary)
  if wt_sixrate ~= world_two_brightness_rate() then 
    softcut.rate(6,world_two_brightness_rate())
    wt_sixrate = world_two_brightness_rate()
    softcut.pre_level(6, ( params:get("brightness") / 100.0 ) * 0.8 )
  end
  if wt_density ~= world_two_density() then 
    softcut.level_cut_cut(6,5,world_two_density())
    wt_density = world_two_density()
    softcut.pre_level(5, ( params:get("density") / 100.0 ) * 0.8 )
  end
end

-- the heart of world two is voices 5 and 6 
-- which loop and overdub and build up a dense 
-- sound 
-- this one is the only world which can truly be said 
-- to 'drone'
function world_two_start() 
  softcut.reset()
  world_two_load_files()
  for idx = 1,4 do 
    softcut.enable(idx,1)
    world_two_voice(idx)
    softcut.level_cut_cut(idx,5, 0.8)
    -- start playback voices
  end
  -- whatever I've done to the settings there is the odd 
  -- click/glitch sometimes - but I like them so not trying to fix that 
  -- if there wasn't a 'no engine' restriction I'd be injecting 
  -- some filtered white noise into the proceedings too.....
  softcut.enable(5,1)
  softcut.enable(6,1)
  
  wt_density = world_two_density()
  
  softcut.buffer(5,1)
  softcut.loop(5,1)
  softcut.loop_start(5,0)
  softcut.loop_end(5,10.0 )
  softcut.position(5,2)
  softcut.rate(5,1.0 )
  softcut.pan(5,0)
  softcut.play(5,1)
  softcut.rec(5,1)
  softcut.rec_level(5,0.9)
  softcut.pre_level(5,0.6)
  
  -- this is a slower playback head 
  -- feedsback to 5 and causes pitch shifting 
  -- type loops - especially noticable 
  -- at lower brightness settings 
  softcut.level_cut_cut(6,5,world_two_density())
  softcut.buffer(6,1)
  softcut.level(6,0.8)
  softcut.loop(6,1)
  softcut.loop_start(6,0)
  softcut.loop_end(6, 10.0)
  softcut.position(6,0.0)
  softcut.rate(6,world_two_brightness_rate() )
  wt_sixrate = world_two_brightness_rate()
  softcut.pan(6,0)
  softcut.play(6,1)
  softcut.rec_level(6,0.9)
  softcut.pre_level(6,0.6)
  softcut.rec(6,1)
  
  
  -- setup initial data for the visualisation 
  -- probably could have made the visualise function do this 
  -- and avoided duplication of the data structure 
  -- but not worth the time spent to sort it 
  for idx = 1,15 do 
    local dir = 1
    if math.random() < 0.5 then 
      dir = -1
    end
    wtv_circs[idx] = { math.random(1,128) , math.random(1,64)  , math.random(1,40 ), dir ,  math.random(2,15), math.random(3,9)}
  end
  
  wtwom = metro.init(world_two_tick,5)
  wtwom:start()
end

-- possibly the most dull of the three visualisations 
-- circles that expand and contract 
-- very 'I just got a computer in 1980'
function world_two_visualise()
  wtv_clock = wtv_clock + 1
  screen.clear()
  local slim = math.floor( ( params:get("density") / 100.0 ) * 60 )
  local mult = math.floor( ( params:get("density") / 100.0 ) * 3 ) + 1
  for idx = 1,15 do
    if wtv_clock % ( wtv_circs[idx][6] * mult ) == 0 then 
      wtv_circs[idx][3] = wtv_circs[idx][3] + wtv_circs[idx][4]
      if wtv_circs[idx][3] > slim then
        wtv_circs[idx][3] = slim
        wtv_circs[idx][4] = -1 
      elseif wtv_circs[idx][3] < 1 then
        wtv_circs[idx] = { math.random(1,128) , math.random(1,64)  , 1, 1 ,  math.random(2,15) , math.random(3,9)}
      end
    end
  end
  local numc = math.floor( ( params:get("brightness") / 100.0 ) * 14 ) + 1
  for idx = 1,numc do 
    screen.level(wtv_circs[idx][5])
    screen.circle( wtv_circs[idx][1] , wtv_circs[idx][2] , wtv_circs[idx][3] )
    screen.fill()
  end
  screen.update()
end

function world_two_volume(x)
  softcut.level(5,x)
  softcut.level(6,x)
end

function world_two_close() 
  wtwom:stop()
  metro.free(wtwom.id)
end

-- world three 
-- voices 2 - 6 - series of linked delays 
-- (tried making them into a random network but uncontrollable feedback happened too often)
-- anyway this is nice and meets the "did I get distracted listening it for ages" test
-- voice 1 input source voice - scanning the input buffer 
-- similarly to world one except it's allowed to loop until it gets moved on randomly 

local wthree_levels = {}

function world_three_evolve()
  -- world three uses the second buffer as source 
  -- and first as working space - so just use the same 
  -- file loader 
  world_two_load_files()
end

-- there is one single voice in world three 
-- at the start of the loop chain 
function world_three_voice( n ) 
  local start =  math.random() *  wt_buflen
  local rnge = start +  ( math.random() / 30.0 )
  local rate = ( math.random() * world_one_brightness() ) + 0.1
  local pan = ( math.random() * 2.0 ) - 1.0
  local dir = 1 
  if math.random() > 0.5 then
    dir = -1
  end
  softcut.play(n,0)
  softcut.buffer(n,2)
  softcut.level(n,0.0)
  softcut.loop(n,1)
  softcut.loop_start(n,start)
  softcut.loop_end(n,rnge)
  softcut.position(n,start)
  softcut.rate(n,rate * dir )
  softcut.pan(n,pan)
  softcut.fade_time(n,2.0)
  softcut.play(n,1)
end

function world_three_brightness_rate()
    return 0.5 + ( params:get("brightness") / 100.0 ) * 0.5
end

function world_three_density()
    return 0.4 + ( params:get("density") / 100.0 ) * 0.5
end

-- every so often move voice 1 
-- and change the parameters on the loop chain 
-- I didn't alter the lengths of the playback loops 
-- since I thought it might be more glitchy than 
-- I wanted 
function world_three_tick() 
  if math.random() < ( params:get("density") / 100.0 ) then
    world_three_voice(1)
    for idx = 2,6 do
      softcut.rate(idx,0.1 + math.random() * ( params:get("brightness") / 100.0 )  )
      softcut.pan(idx, -1 + ( math.random() * 2.0) )
      softcut.rec_level(idx,0.6 + (math.random() * 0.4) )
      softcut.pre_level(idx, ( 0.2 + (math.random() * 0.8) ) *  ( params:get("density") / 100.0 ) )  
      softcut.post_filter_fc(idx,( params:get("brightness") / 100 ) * math.random() * 1500 )
    end
  end
end

-- this sets up a chain of loops using voices 2-6 
-- all with different settings 
-- sound goes in one end and out the other (give or take) 
function world_three_start() 
  softcut.reset()
  softcut.buffer_clear()
  -- use same load files as w2
  world_two_load_files()
  softcut.enable(1,1)
  for idx = 2,6 do
    softcut.enable(idx,1)
    softcut.level_cut_cut(idx - 1 ,idx, 0.5)
    softcut.buffer(idx,1)
    wthree_levels[idx] = math.random()
    softcut.level(idx, wthree_levels[idx] * params:get("volume"))
    softcut.loop(idx,1)
    softcut.loop_start(idx,10 * (idx - 2) )
    softcut.loop_end(idx,10.0 * (idx - 2) + (10.0 * math.random() ))
    softcut.position(idx,10 * (idx - 2))
    softcut.rate(idx,0.2 + math.random() )
    softcut.pan(idx, -1 + ( math.random() * 2.0) )
    softcut.play(idx,1)
    softcut.rec(idx,1)
    softcut.rec_level(idx,0.6 + (math.random() * 0.4) )
    softcut.pre_level(idx, ( 0.2 + (math.random() * 0.8) ) *  ( params:get("density") / 100.0 ) )  
    softcut.post_filter_bp(idx,2.0)
    softcut.post_filter_fc(idx,( params:get("brightness") / 100 ) * math.random() * 1500 )
    softcut.post_filter_rq(idx,0.4)
  end
  softcut.level(6,0.5)
  world_three_voice(1)
  
  world_three_init_visualisation()
  
  wtwom = metro.init(world_three_tick,1)
  wtwom:start()
  
end

-- this is my favourite visualisation 
-- a homebrew attempt at 1 dimensional flocking behaviour 
-- plus noise otherwise it gets very boring 
-- like the sound worlds it has been "gardened" to give the results I 
-- imagined rather than being mathematically correct 
-- wish I could use the sound output to influence it too.....
-- guess if I used an engine/poll I might be able to manage something but not for this one 

local wthrv_num_lines = 30
local wthrv_threshold = 0.3
local wthrv_lines = {}
local whrv_clock = 0

function world_three_init_visualisation() 
  for idx = 1,wthrv_num_lines do 
    -- pos  , velocity , level 
    wthrv_lines[idx] = { math.random( 1,128) , -3 + ( math.random() * 6.0) , math.random(1,15)  } 
  end
end

function world_three_visualise()
  whrv_clock = whrv_clock + 1
  screen.clear()
  local mult = math.floor(  (( 100 - params:get("brightness") ) / 100.0 ) * 3 ) + 1
  if whrv_clock % mult == 0 then 
    table.sort(wthrv_lines,function(a,b) return a[1] < b[1] end)
    for idx = 1,wthrv_num_lines do 
      if math.random() < wthrv_threshold then 
        local vavg = 0
        local vcnt = 0
        for lcl = math.max( idx - 3 , 1 ),math.min( idx + 3 , wthrv_num_lines ) do 
          vcnt = vcnt + 1
          vavg = vavg + wthrv_lines[lcl][2]
        end
        wthrv_lines[idx][2] = vavg / vcnt + ( 1 +  math.random() * 1.8 )
      else
        wthrv_lines[idx][2] = wthrv_lines[idx][2] + ((1 - wthrv_lines[idx][1]) / 100)
      end
      wthrv_lines[idx][1] = wthrv_lines[idx][1] + wthrv_lines[idx][2]
      if wthrv_lines[idx][1] > 128 or wthrv_lines[idx][1] < 0 then
        wthrv_lines[idx][2] = -1.0 * wthrv_lines[idx][2]
      end
    end
  end
  for idx = 1, ( params:get("density") / 100 )  * wthrv_num_lines do 
    screen.move(wthrv_lines[idx][1],0)
    screen.line(wthrv_lines[idx][1],64)
    screen.level(wthrv_lines[idx][3] )
    screen.line_width(1)
    screen.stroke()
  end
  screen.update()
end

function world_three_volume(x)
  for idx = 2,6 do 
    softcut.level(idx,wthree_levels[idx] * x)
  end
end

function world_three_close() 
  wtwom:stop()
  metro.free(wtwom.id)
  --softcut.poll_stop_phase()
end

-- shove all the world stuff in a little table 
-- so we can switch easily between them 
-- possibly could have put each world in a class 
-- but classes are more work in lua than they are in other 
-- languages and this table is the exact bit I'm after 
-- a virtual function table that can make the same calls to 
-- different sets of functionality 
voices = { }
worlds = { 
  [1] =  { 
    ["init"] = world_one_start ,
    ["volume"] = world_one_volume,
    ["evolve"] = world_one_evolve,
    ["visualise"] = world_one_visualise,
    ["close"]  = world_one_close
  },
  [2] =  { 
    ["init"] = world_two_start ,
    ["volume"] = world_two_volume,
    ["evolve"] = world_two_evolve,
    ["visualise"] = world_two_visualise,
    ["close"]  = world_two_close
  },
  [3] =  { 
    ["init"] = world_three_start ,
    ["volume"] = world_three_volume,
    ["evolve"] = world_three_evolve,
    ["visualise"] = world_three_visualise,
    ["close"]  = world_three_close
  }
}

-- main script 
-- basically just calls world stuff and alters params 
  
function init()
  -- kick the random number generator 
  math.randomseed(os.time())
  -- we have three params 
  -- probably don't need to be params 
  -- but whatever 
  cs_VOLUME = controlspec.new(0,1,'lin',0,0.2,'')
  params:add{type="control",id="volume",controlspec=cs_VOLUME,
    action=function(x) worlds[current_world].volume(x) end}
  params:add_number("brightness","Brightness",0,100,50)
  params:add_number("density","Density",0,100,50)
  worlds[current_world].init()
  screen_refresh =  metro.init(screen_update,1/25)
  screen_refresh:start()
end

function enc(n,d)
    if n == 1 then 
      params:delta('volume',d)
      ctl_name = "volume"
    elseif n == 2 then 
      params:delta("brightness" , d)
      ctl_name = "brightness"
    elseif n == 3 then 
      params:delta("density" , d)
      ctl_name = "density"
    end
    ctl_disp = 35
end

function key(n,z)
    if n == 2 and z == 1 then 
      worlds[current_world].evolve()
    elseif n == 3 and z == 1 then 
      worlds[current_world].close()
      current_world = pick_another(1,3,current_world)
      worlds[current_world].init()
    end
end

-- popup for controls so you 
-- can see what is going on 
-- yes it just bodges round the different range 
-- of the volume - the payback/effort to make it "nice" programatically 
-- isn't worth it  for a simple thing like this 
function control_overlay()
  if ctl_disp > 0 then 
    ctl_disp = ctl_disp - 1
    screen.rect( 10, 20 , 100 , 30)
    screen.level(0)
    screen.fill()
    screen.line_width(1)
    screen.rect( 10, 20 , 100 , 30)
    screen.level(13)
    screen.stroke()
    screen.move(13,32)
    screen.font_face(5)
    screen.font_size(10)
    screen.text(ctl_name)
    screen.rect( 15, 40 , 80 , 4)
    screen.level(13)
    screen.stroke()
    if ctl_name ~= "volume" then 
      screen.rect( 15, 40 , 80 * ( params:get(ctl_name) / 100 ) , 4)
    else 
      screen.rect( 15, 40 , 80 *  params:get(ctl_name) , 4)
    end
    screen.level(13)
    screen.fill()
  end
end

-- possibly don't need the redraw/screen_update thing 
-- could just have called redraw from the metro - but 
-- this is one of those places that the system calls in to 
-- so staying out of the way "just in case"
function screen_update() 
  redraw()
end

function redraw()
  worlds[current_world].visualise()
  control_overlay()
  screen.update()
end
