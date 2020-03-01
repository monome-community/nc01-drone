-- seeker (nc01-drone)
-- @tehn
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

-- invisible cities:
txt = [[
You walk for days among trees and among stones. Rarely does the eye light on a thing, and then only when it has recognized that thing as the sign of another thing: a print in the sand indicates the tiger's passage; a marsh announces a vein of water; the hibiscus flower, the end of winter. All the rest is silent and interchangeable; trees and stones are only what they are. Finally the journey leads to the city of Tamara. You penetrate it along streets thick with signboards jutting from the walls. The eye does not see things but images of things that mean other things: pincers point out the tooth-drawer's house; a  tankard, the tavern; halberds, the barracks; scales, the grocer's. Statues and shields depict lions, dolphins, towers, stars: a sign that something-who knows what?-has as its sign a lion or a dolphin or a tower or a star. Other signals warn of what is forbidden in a  given place (to enter the alley with wagons, to urinate behind the kiosk, to fish with your pole from the bridge) and what is allowed (watering zebras, play-ing bowls, burning relatives' corpses). From the doors of the temples the gods' statues are seen, each por-trayed with his attributes-the cornucopia, the hour-glass, the medusa-so that the worshiper can recog-nize them and address his prayers correctly. If a bUilding has no signboard or figure, its very form 13 and the position it occupies in the city's order suffice to indicate its function: the palace, the prison, the mint, the Pythagorean school, the brothel. The wares, too, which the vendors display on their stalls are valuable not in themselves but as signs of other things: the embroidered headband stands for ele-gance; the gilded palanquin, power; the volumes of Averroes, learning; the ankle bracelet, voluptuous-ness. Your gaze scans the streets as if they were writ-ten pages: the city says everything you must think, makes you repeat her discourse, and while you be-lieve you are visiting Tamara you are only recording the names with which she defines herself and all her parts. However the city may really be, beneath this thick coating of signs, whatever it may contain or conceal, you leave Tamara without having discovered it. Out-side, the land stretches, empty, to the horizon; the sky opens, with speeding clouds. In the shape that chance and wind give the clouds, you are already in-tent on recognizing figures: a sailing ship, a hand, an elephant.
]]

sc = softcut -- typing shortcut
length = 0

world = 1

low = false

files = {"bc.wav","dd.wav","eb.wav"}

w_loop_start = {
  {108, 111.6, 28.42 },
  {57, 67, 13.3},
  {20, 21, 29} }

w_loop_end = {
  {132, 120, 30.42},
  {65, 74, 18.5},
  {39, 32, 30} }

w_rate = {
  {0.5, 1.0, -0.25},
  {-2, 1, 1},
  {1, -1, 0.5} }

w_pan = {
  {0.25,-0.25,0},
  {0,0,0},
  {0.25, -0.25, 0} }

a = {}
v = {}

for i=1,15 do
  a[i] = math.random()*2*math.pi
  v[i] = math.random()*90 + 1
end



function load_file(w)
  file = _path.code .. "nc01-drone/lib/"..files[w]
  sc.buffer_read_mono(file,0,0,-1,1,1)
  _,length,sr = audio.file_info(file)
  length = length/sr
  print(audio.file_info(file))
end

function init_world(w)
  load_file(w)
  for i=1,3 do
    sc.rate(i,w_rate[w][i])
    sc.loop_start(i,w_loop_start[w][i])
    sc.loop_end(i,w_loop_end[w][i])
    sc.position(i,w_loop_start[w][i])
    sc.pan(i,w_pan[w][i])
  end
end

function set_density(x)
  sc.level(2,math.min(1,x*2))
  sc.level(3,math.max(0,x*2-1))
end

function set_brightness(x)
  for i=1,3 do
    sc.post_filter_lp(i,(1-x)*0.5)
    sc.post_filter_hp(i,x*0.5)
  end
end


function init()
  cs_AMP = controlspec.new(0,1,'lin',0,1.0,'')
  params:add{type="control",id="volume",controlspec=cs_AMP,
    action=audio.level_dac}
  params:add{type="control",id="density",controlspec=cs_AMP,
    action=set_density}
  params:add{type="control",id="brightness",controlspec=cs_AMP,
    action=set_brightness}

  params:bang()

  for i=1,3 do
    sc.enable(i,1)
    sc.buffer(i,1)
    sc.level(i,1.0)
    sc.loop(i,1)
    sc.play(i,1)
    sc.rate_slew_time(i,0.1)
    sc.pan_slew_time(i,2)
    sc.post_filter_dry(i,0.2)
    sc.post_filter_fc(i,800)
    sc.post_filter_rq(i,10)
  end

  init_world(world)
end


function enc(n,d)
  if n==1 then
    params:delta("volume",d*4)
  elseif n==2 then
    params:delta("density",d*4)
  elseif n==3 then
    params:delta("brightness",d*4)
  end
end


function key(n,z)
  -- WORLD
  if n==3 and z==1 then
    world = (world%3)+1
    init_world(world)

    if world==2 then
      for i=1,15 do
        a[i] = math.random()*2*math.pi
        v[i] = math.random()*90 + 1
      end
    end
    redraw()

  -- EVOLVE
  elseif n==2 and z==1 then
    if world==1 then
      low = not low
      sc.rate(2,low and -1 or 1)
    elseif world==2 then
      for i=1,15 do
        a[i] = a[i] * (0.95 + math.random()*0.1)
        v[i] = v[i] * (0.95 + math.random()*0.1)
      end
      for i=1,3 do
        w_loop_start[2][i] = w_loop_start[2][i]+math.random()*2-1
        w_loop_end[2][i] = w_loop_end[2][i]+math.random()*2-1
        sc.loop_start(i,w_loop_start[2][i])
        sc.loop_end(i,w_loop_end[2][i])
      end

    elseif world==3 then
      low = not low
      sc.pan(1,low==false and 0.5 or -0.5)
      sc.pan(2,low==true and 0.5 or -0.5)
      sc.rate(3,low==false and 0.5 or 0.25)
      sc.rate_slew_time(3,low==false and 0.01 or 5)
    end
  redraw()

  end
end


function redraw()
  screen.clear()
  if world==1 then
    s = math.floor(math.random() * (txt:len()-75))
    screen.aa(0)
    screen.level(15)
    screen.move(62,32)
    screen.text_center(string.upper(txt:sub(s,s+25)))
    screen.move(62,40)
    screen.text_center(string.upper(txt:sub(s+26,s+50)))
    screen.move(62,48)
    screen.text_center(string.upper(txt:sub(s+51,s+75)))
  elseif world==2 then
    screen.aa(1)
    for i=1,15 do
      screen.move(30,30)
      screen.line_rel(math.cos(a[i])*v[i],math.sin(a[i])*v[i])
      screen.level(i)
      screen.stroke()
    end
  elseif world==3 then
    screen.aa(0)
    screen.rect(54,22,20,20)
    screen.level(2)
    screen.stroke()
  end

  screen.update()
end
