# synth

c=circle({width: 69, height: 69, y: 66, x: 69})
c.touch(option: :down) do
  c.audio_dsp("dspcheck")
end