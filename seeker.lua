-- seeker (nc01-drone)
-- @tehn
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

sc = softcut -- typing shortcut
length = 0

function init()
  file = _path.code .. "nc01-drone/lib/dd.wav"
  sc.buffer_read_mono(file,0,0,-1,1,1)
  _,length,sr = audio.file_info(file)
  length = length/sr
  print(audio.file_info(file))

  for i=1,3 do
    sc.enable(i,1)
    sc.buffer(i,1)
    sc.level(i,1.0)
    sc.loop(i,1)
    sc.rate(i,1.0)
    sc.play(i,1)
  end

  sc.loop_start(1,1)
  sc.loop_end(1,2)
  sc.position(1,1)

  sc.loop_start(2,2)
  sc.loop_end(2,3)
  sc.position(2,1)

  sc.loop_start(3,3)
  sc.loop_end(3,4)
  sc.position(3,1)

  print("approaching...")
end

edit = 1
level = {1,1,1}
lst = {1,2,3}
lend = {2,3,4}
scrub = 1

function enc(n,d)
  if n==1 then
    level[edit] = util.clamp(level[edit] + d/10,0,1)
    sc.level(edit, level[edit])
  elseif n==2 then
    lst[edit] = util.clamp(lst[edit] + d*scrub, 0, lend[edit])
    sc.loop_start(edit, lst[edit])
    print(edit,lst[edit],lend[edit])
  elseif n==3 then
    lend[edit] = util.clamp(lend[edit] + d*scrub, lst[edit], length)
    sc.loop_end(edit, lend[edit])
    print(edit,lst[edit],lend[edit])
  end
end

function key(n,z)
  if n==3 and z==1 then
    edit = edit % 3 + 1
  elseif n==2 and z==1 then
    scrub = scrub * 10
    if scrub == 10 then scrub = 0.01 end
  end
  redraw()
end

function redraw()
  screen.clear()
  screen.move(64,50)
  screen.aa(1)
  screen.font_face(4)
  screen.font_size(50)
  screen.text_center(edit)
  screen.update()
end
