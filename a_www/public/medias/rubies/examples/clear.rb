#clear

# box({atome_id: :the_box})
c=circle(x: 96)
t=text({content: "click tme to clear the screen", atome_id: :the_text})
text({content: "hello", x: 96, y: 96})
image({content: :boat, size: 96, x: 96, y: 96})
image({content: :moto, size: 96, y: 96})


b=box({x: 96, y: 96})
b.circle(true)
b.text("touch the box to clear it's content")
b.attach(c.atome_id)
b.touch do
  b.clear(true)
end

t.touch do
  grab(:view).clear(:true)
end