# Schedule example

# ATOME.schedule(Time.now+3) do
#   i=image({ content: :boat , drag: :true, x: 99, y:99 })
#   i.touch do
#     i.delete(true)
#   end
# end
#
# ATOME.schedule('2021 05 04 22 41 30') do
#   alert :kool
# end
#
# ATOME.schedule('10') do
#   alert :goodgood
# end

text(" date can be entered in  several ways , 2 digit it'll be the next time the seconds match ,
if 2 digits the minutes and seconds and so on, you can also enter Time.now+3 (not a,string) for schedule in 3 sec ")
t=text({ content: "3", y: 90 ,x: 150, edit: true})

c=circle({ size: 33, x: 66, y: 99})

c.touch do
  time=t.content
  time=time.q_read
  if time.instance_of?(Hash)
    time=time[grab(:view).language]
  end
  time=time.to_i
  time_to_run= Time.now+time.to_i
  ATOME.schedule(time_to_run) do
    i=image({ content: :boat , drag: :true, x: 99, y:99 })
    wait 2 do
      i.delete(true)
    end
  end
  t.content("countdown started")
end