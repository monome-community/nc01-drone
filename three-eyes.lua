-- three eyes (nc01-drone)
-- that world in their eyes
-- @2994898
--
-- E1 volume
-- E2 brightness 
--    - playback rate modifier
-- E3 density 
--    - length of each voices
-- K2 evolve 
--    - add voice or replace the
--      oldest voice (long press 
--      *1 sec.* to remove an 
--      oldest voice)
-- K3 change worlds 
--    - rebalance volume of 
--      each voices

local sc = softcut -- hail to Tehn
local file = _path.code .. "nc01-drone/lib/eb.wav"
local length = 0
local voices = {}
local voiceLoopPoints = {}
local voiceIndex = 0
local perspectives = {
  {1, 0.8, 0.7, 0.5, 0.3, 0.1},
  {0.7, 0.8, 0.7, 0.5, 0.3, 0.2},
  {0.2, 0.4, 0.7, 0.1, 0.7, 0.4}
}
local perspectiveIndex = 1
local distances = { 15, 7, 10 }
local volume = 80
local brightness = 50
local density = 80

function setVoiceProps(index, transitionTime, shouldRateTransition)
  presence = perspectives[perspectiveIndex][index]

  local rateFactor = util.linlin(1, 100, -1.5, 0.5, brightness)
  local panValue = util.linlin(0, 1, -1, 0, presence)
  if math.floor(panValue * 10) % 2 == 1 then panValue = -1 * panValue end

  sc.fade_time(index, presence)
  sc.level_slew_time(index, transitionTime)
  sc.pan_slew_time(index, transitionTime)

  if not shouldRateTransition or false then
    sc.rate_slew_time(index, 0.1)
  else
    sc.rate_slew_time(index, transitionTime * 2)
  end

  sc.loop_end(voiceIndex, util.linlin(1, 100, voiceLoopPoints[index][1] + 1, voiceLoopPoints[index][2], density))
  sc.rate(index, util.clamp(presence + rateFactor, -2, 1))
  sc.pan(index, panValue)
  sc.post_filter_fc(index, 10000 * presence)
  sc.post_filter_rq(index, 2 * presence)
  sc.post_filter_bp(index, 1 - presence)
  sc.play(index, 1)
  sc.level(index, util.linexp(1, 100, 0.001, presence, volume))
end

function addVoice()
  voiceIndex = voiceIndex + 1
  if voiceIndex == 7 then voiceIndex = 1 end

  voiceLoopPoints[voiceIndex] = {}
  voiceLoopPoints[voiceIndex][1] = math.random(math.floor(length) - 2)
  voiceLoopPoints[voiceIndex][2] = voiceLoopPoints[voiceIndex][1] + util.clamp(math.random(math.floor(length) - voiceLoopPoints[voiceIndex][1]), 2, 25)

  sc.enable(voiceIndex, 1)
  sc.buffer(voiceIndex, 1)
  sc.level(voiceIndex, 0)
  sc.loop(voiceIndex, 1)
  sc.loop_start(voiceIndex, voiceLoopPoints[voiceIndex][1])
  sc.loop_end(voiceIndex, voiceLoopPoints[voiceIndex][2])
  sc.position(voiceIndex, voiceLoopPoints[voiceIndex][1])

  setVoiceProps(voiceIndex, 7)

  table.insert(voices, #voices + 1)
  end

function removeVoice(transitionTime)
  sc.level_slew_time(voices[1], transitionTime or 3)
  sc.level(voices[1], 0)
  table.remove(voices, 1)
end

-- k2_counter: to detect key press / long press
local k2_isLongPress = false

function handle_k2_counter()
  removeVoice(5)
  k2_isLongPress = true
end

local k2_counter = metro.init(handle_k2_counter, 1, 1)

function fadePerspective()
  perspectiveIndex = perspectiveIndex + 1
  if perspectiveIndex == 4 then perspectiveIndex = 1 end

  local counter = metro.init(function(c) setVoiceProps(c, distances[perspectiveIndex], true) end, distances[perspectiveIndex] / 3, #voices)
  counter:start()

  redraw()
end

function evolve()
  voiceFade_counter = metro.init(addVoice, 0.1, 1)

  if #voices == 6 then
    removeVoice()
    voiceFade_counter.time = 3
  end

  voiceFade_counter:start()
end

function key(n, z)
  if n == 3 and z == 1 then
    fadePerspective()
  elseif n == 2 then
    if z == 0 then
      k2_counter:stop()

      if not k2_isLongPress then evolve() end
    else
      k2_isLongPress = false;

      k2_counter:start()
    end
  end
end

function enc(n, d)
  if n == 1 then
    volume = util.clamp(volume + d, 1, 100)

    for i = 1, #voices do
      setVoiceProps(i, 0.01)
    end

    redraw()

    return
  elseif n == 2 then
    brightness = util.clamp(brightness + d, 1, 100)
    redraw()
  elseif n == 3 then
    density = util.clamp(density + d, 1, 100)
  end

  setVoiceProps(voiceIndex, 0.01)
end

function init()
  sc.buffer_read_mono(file, 0, 0, -1, 1, 1)
  _, length, sr = audio.file_info(file)
  length = length / sr

  addVoice()
end

-- visual stuff
-- coordinates { x, y } and direction
local eyeBases = {
  {
    ltr = true,
    edge = { 40, 40 },
    size = { 72, 31 }
  },
  {
    ltr = false,
    edge = { 84, 32 },
    size = { 82, 34 }
  },
  {
    ltr = true,
    edge = { 40, 24 },
    size = { 62, 32 }
  }
}
local irisX
local irisY
local irisSize = 14
local blinkState = 1

function handle_animate_counter(count)
  local currentEye = eyeBases[perspectiveIndex]
  local x = currentEye.edge[1] + util.round(((currentEye.ltr and 1 or -1) * currentEye.size[1]) / 2 + (irisSize / 1.5))

  irisX = math.random(currentEye.ltr and x - 3 or x - 6, currentEye.ltr and x + 3 or x + 6)

  if blinkState == 3 then
    blinkState = 2
  elseif count % 2 == 0 then
    blinkState = util.clamp(math.random(blinkState - 1, blinkState + 1), 0, 3)
  end

  redraw()
end

local animate_counter = metro.init(handle_animate_counter, 5, -1)
animate_counter:start()

function drawEye()
  local eye = eyeBases[perspectiveIndex]

  irisX = eye.edge[1] + util.round(((eye.ltr and 1 or -1) * eye.size[1]) / 2 + (irisSize / 1.5))
  irisY = eye.edge[2] - util.round(eye.size[2] * 0.6)

  -- NOTE: pls disregard about these magics..
  local magic_four = util.linlin(0, 3, 0, 16, blinkState)
  local magic_six = util.linlin(0, 3, 0, 8, blinkState)

  screen.move(eye.edge[1], eye.edge[2])
  screen.level(util.round(util.linlin(1, 100, 0, 13, volume)))
  screen.curve(
    util.round(eye.edge[1] + ((eye.ltr and 0.3 or -0.3) * eye.size[1])),
    util.round(eye.edge[2] - (eye.size[2] * 0.75) + magic_four),
    util.round(eye.edge[1] + ((eye.ltr and 0.75 or -0.75) * eye.size[1])),
    util.round(eye.edge[2] - (eye.size[2] * 0.65) + magic_four),
    eye.edge[1] + ((eye.ltr and 1 or -1) * eye.size[1]),
    eye.edge[2]
  )
  screen.curve(
    util.round(eye.edge[1] + ((eye.ltr and 1 or -1) * eye.size[1]) + ((eye.ltr and -0.65 or 0.65) * eye.size[1])),
    util.round(eye.edge[2] + (eye.size[2] * 0.5625) - magic_six),
    util.round(eye.edge[1] + ((eye.ltr and 1 or -1) * eye.size[1]) + ((eye.ltr and -0.875 or 0.875) * eye.size[1])),
    util.round(eye.edge[2] - (eye.size[2] * 0.125) + blinkState - magic_six),
    eye.edge[1],
    eye.edge[2]
  )
  screen.stroke()

  screen.level(util.round(util.linlin(1, 100, 0, util.linlin(0, 3, 8, 4, blinkState), volume)))
  screen.arc(
    util.round(irisX - (irisSize * 0.4)) + blinkState,
    util.round(irisY + (irisSize * 0.9)) + blinkState,
    irisSize,
    -1 * math.pi * util.linexp(0, 3, 0.22, 0.01, blinkState),
    math.pi * util.linexp(0, 3, 0.4, 0.15, blinkState)
  )
  screen.move_rel(-1 * util.linlin(0, 3, 0.01, 20, blinkState), 0)
  screen.arc(
    util.round(irisX - (irisSize * 0.4)) + blinkState,
    util.round(irisY + (irisSize * 0.9)) + blinkState,
    irisSize,
    math.pi * util.linexp(0, 3, 0.65, 0.9, blinkState),
    math.pi * util.linexp(0, 3, 1.22, 1.00, blinkState)
  )
  screen.stroke()

  if blinkState ~= 3 then
    screen.circle(
      irisX - util.round(irisSize * 0.4) + blinkState,
      irisY + util.round(irisSize * 0.85) + blinkState,
      util.linexp(0, 3, util.linlin(1, 100, 6, 3, brightness), 3, blinkState)
    )
    screen.fill()
  end
end

function redraw()
  screen.clear()
  screen.aa(1)
  drawEye()

  screen.move(120, 62)
  screen.level(14)
  screen.font_face(10)
  screen.font_size(14)
  screen.text(perspectiveIndex)

  screen.update()
end
