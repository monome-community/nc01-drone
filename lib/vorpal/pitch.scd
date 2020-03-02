(
b = Bus.control(s);
x = {
	var p, c;
	# p, c = Pitch.kr(SoundIn.ar(0), clar:1);
	Out.kr(b.index, p);
	Out.kr(b.index+1,  c);
}.play(s);

t = 0.1;
r = Routine { inf.do {
	b.getn(2, { arg vals;
		if (vals[1] > 0.6, {
			postln([vals, vals[0].cpsmidi]);
		});
	});
	t.wait;
}}.play;


SynthDef.new(\sine,{ arg hz=60, amp=0.2; Out.ar(0,SinOsc.ar(hz).dup*amp)}).send(s);

)

/*
r.stop;
r.start;
*/

/* dd
h = 136 * 2
y = Synth.new(\sine, [\hz, h * 2]);
z.free;
z = Synth.new(\sine, [\hz, h*3/2]);
w = Synth.new(\sine, [\hz, h*4/5]);
q = Synth.new(\sine, [\hz, h*2*15/16 * 4]);
v = Synth.new(\sine, [\hz, h*6/5]);
y.set(\hz, 36.midicps * 2);
z.set(\hz,
*/

/* bc
h = 492;
m = h.cpsmidi;

y = Synth.new(\sine, [\hz, h]);
z = Synth.new(\sine, [\hz, h*3/4]);
w = Synth.new(\sine, [\hz, h*4/5]);
w.free;
*/



/* eb
h = 281;
m = h.cpsmidi;

SynthDef.new(\sine,{ arg hz=60, amp=0.2; Out.ar(0,SinOsc.ar(hz).dup*amp)}).send(s);
y = Synth.new(\sine, [\hz, h]);
z = Synth.new(\sine, [\hz, h*]);
w = Synth.new(\sine, [\hz, h*4/5]);
w.free;
*/
