-- chambers
-- @dan_derks
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

local which_voice = 0
local which_file = 1
local filepaths = {"nc01-drone/lib/bc.wav","nc01-drone/lib/eb.wav","nc01-drone/lib/dd.wav"}

local level = {}
local brightness = {}
local spectral_density = {}
local overlap_density = {}
for i = 1,3 do
  level[i] = 1
  brightness[i] = 1
  spectral_density[i] = 1
  overlap_density[i] = 0.4
end

function init()
	file = _path.code .. filepaths[1]
  softcut.buffer_read_mono(file,0,1,-1,1,1)
  
  softcut.enable(1,1)
  softcut.buffer(1,1)
  softcut.level(1,0)
  softcut.loop(1,1)
  softcut.loop_start(1,1)
  softcut.loop_end(1,3)
  softcut.fade_time(1,0.4)
  softcut.position(1,1)
  softcut.rate(1,1.0)
  softcut.play(1,1)
  
  for i = 2,4 do
    softcut.level_cut_cut(1,i,1)
    softcut.enable(i,1)
    softcut.buffer(i,2)
    softcut.level(i,1)
    softcut.rec(i,1)
    softcut.loop(i,1)
    softcut.post_filter_lp(i, 1)
    softcut.post_filter_hp(i, 1)
    softcut.post_filter_dry(i, 0)
    softcut.post_filter_rq(i, 0.5)
    softcut.post_filter_fc(i, 10000)
  end

  softcut.rec_level(2,1)
  softcut.pre_level(2,overlap_density[1])
  softcut.rec_level(3,0)
  softcut.pre_level(3,1)
  softcut.rec_level(4,0)
  softcut.pre_level(4,1)  
    
  softcut.loop_start(2,1)
  softcut.loop_end(2,3)
  softcut.fade_time(2,0.4)
  softcut.position(2,1)
  softcut.rate(2,1.0)
  softcut.play(2,1)
  softcut.pan(2,-1)

  softcut.loop_start(3,4)
  softcut.loop_end(3,6.5)
  softcut.fade_time(3,0.4)
  softcut.position(3,4)
  softcut.rate(3,0.25)
  softcut.play(3,1)
  softcut.pan(3,1)
  
  softcut.loop_start(4,8)
  softcut.loop_end(4,15)
  softcut.fade_time(4,0.4)
  softcut.position(4,8)
  softcut.rate(4,2)
  softcut.play(4,1)
  softcut.pan(4,0)
  
  for i = 1,4 do
    softcut.level_slew_time(i,0.5)
    softcut.rec_offset(i,-0.06)
  end
  
  screen.aa(1)
  screen.font_size(8)
  screen.font_face(2)
  
end

function enc(n,d)
  if n == 1 then
    level[which_voice+1] = util.clamp(level[which_voice+1]+d/100,0,1)
    softcut.level(which_voice+2, level[which_voice+1])
  elseif n == 2 then
    brightness[which_voice+1] = util.clamp(brightness[which_voice+1]-d/100,0,1)
    softcut.post_filter_lp(which_voice+2, brightness[which_voice+1])
  elseif n == 3 then
    spectral_density[which_voice+1] = util.clamp(spectral_density[which_voice+1]-d/100,0,1)
    softcut.post_filter_fc(which_voice+2,util.linexp(0,1,10,10000,spectral_density[which_voice+1]))
    softcut.post_filter_hp(which_voice+2, 1+spectral_density[which_voice+1])
    overlap_density[which_voice+1] = util.clamp(overlap_density[which_voice+1]+d/100,0.1,0.9)
    softcut.pre_level(which_voice+2,overlap_density[which_voice+1])
  end
  redraw()
end

function key(n,z)
  if z == 1 then
    if n == 2 then
      local random_start = math.random(1,40)
      local random_end = random_start+(math.random(0,40)/10)
      softcut.loop_start(1,random_start)
      softcut.loop_end(1,random_end)
      which_voice = (which_voice+1)%3
      if which_voice == 0 then
        softcut.rec_level(2,1)
        softcut.pre_level(2,overlap_density[1])
        softcut.rec_level(3,0)
        softcut.pre_level(3,1)
        softcut.rec_level(4,0)
        softcut.pre_level(4,1)
      elseif which_voice == 1 then
        softcut.rec_level(2,0)
        softcut.pre_level(2,1)
        softcut.rec_level(3,1)
        softcut.pre_level(3,overlap_density[2])
        softcut.rec_level(4,0)
        softcut.pre_level(4,1)
      elseif which_voice == 2 then
        softcut.rec_level(2,0)
        softcut.pre_level(2,1)
        softcut.rec_level(3,0)
        softcut.pre_level(3,1)
        softcut.rec_level(4,1)
        softcut.pre_level(4,overlap_density[3])
      end
    elseif n == 3 then
      which_file = ((which_file + 1)%3)+1
      file = _path.code .. filepaths[which_file]
      softcut.buffer_read_mono(file,0,1,-1,1,1)
    end
    redraw()
  end
end

function redraw()
  screen.clear()
  screen.move(64,10)
  screen.text_center(""..filepaths[which_file])
  screen.move(64,15)
  local position_to_line = {10,116,64}
  screen.line_width(0.5)
  screen.line(position_to_line[which_voice + 1],30)
  screen.stroke()
  local voice_to_position = {10,116,64}
  screen.move(voice_to_position[which_voice + 1],40)
  screen.text_center("v: "..string.format("%.2f",level[which_voice+1]))
  screen.move(voice_to_position[which_voice + 1],50)
  screen.text_center("b: "..string.format("%.2f",1-brightness[which_voice+1]))
  screen.move(voice_to_position[which_voice + 1],60)
  screen.text_center("d: "..string.format("%.2f",util.linlin(0.1,0.9,0,1,overlap_density[which_voice+1])))
  screen.update()
end