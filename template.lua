-- 01-drone template
-- @tehn
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

function init()
	file = _path.code .. "01-drone/lib/bc.wav"
  softcut.buffer_read_mono(file,0,0,-1,1,1)
  softcut.enable(1,1)
  softcut.buffer(1,1)
  softcut.level(1,1.0)
  softcut.loop(1,1)
  softcut.loop_start(1,1)
  softcut.loop_end(1,2)
  softcut.position(1,1)
  softcut.rate(1,1.0)
  softcut.play(1,1)

  print("approaching...")
end

function enc(n,d)
    
end

function key(n,z)

end

function redraw()
  screen.clear()
  screen.move(64,50)
  screen.aa(1)
  screen.font_face(4)
  screen.font_size(50)
  screen.text_center("3")
  screen.update()
end
