# extract attach example

b=box({ drag: true, atome_id: :the_box })
c=circle({x: 99, drag: true, atome_id: :the_circle })
b.text("drag me")
c.text("drag me")
t=text({ content: "touch me to extract me from the box,\nand attach me to the circle ",y: 99, atome_id: :the_text  })
grab(:the_box).attach(:the_text)
t.set({ width: 999, height: :auto })
t.touch do
  grab(:the_box).extract(:the_text)
  grab(:the_circle).attach(:the_text)
end
