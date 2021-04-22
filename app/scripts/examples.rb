def run_demo(path)
  clear(:view)
  read(path) do |data|
    compile data
  end
end

def demo_navigator(demo_list, index)
  text({ content: "#{index} : " + demo_list.keys[index], color: :white, fixed: true, yy: 3, x: 3 })
  next_example = demo_list.keys[index + 1]
  previous_example = demo_list.keys[index - 1]
  back = text({ content: :demos, xx: 20, z: 300, parent: :intuition })
  back.touch do
    # we clear the buffer to avoid treatment on no more existent atome
    grab(:buffer).content[:resize]=[]
    demo_reel(demo_list)
  end

  unless index == 0
    index = index - 1
    previous_demo = text(content: :previous, y: 33, xx: 20, z: 300, parent: :intuition )
    previous_demo.touch do
      # we clear the buffer to avoid treatment on no more existent atome
      grab(:buffer).content[:resize]=[]
      path = demo_list[previous_example]
      run_demo(path)
      demo_navigator(demo_list, index - 1)
    end
  end

  unless demo_list.length == index + 1
    index = index + 1
    next_demo = text({ content: :next, y: 69, xx: 20, parent: :intuition  })
    next_demo.touch do
      # we clear the buffer to avoid treatment on no more existent atome
      grab(:buffer).content[:resize]=[]
      path = demo_list[next_example]
      run_demo(path)
      demo_navigator(demo_list, index + 1)
    end
  end
  text({ content: demo_list[index], color: :white })
end

def demo_reel(demo_list)
  require './app/scripts/background.rb'
  bluegreen_gradient=[ { red: 0.3, green: 0.1, blue: 0.9 },{ red: 0.3, green: 0.1, blue: 0.6 }]
  Background.theme(bluegreen_gradient)
  clear(:view)
  demo_list.each_with_index do |demo, index|
    the_code = text({ content: "#{index} : " + demo[0], y: 20 * index, size: 16 })
    the_code.touch do
      run_demo(demo[1])
      demo_navigator(demo_list, index)
    end
  end
end

JSUtils.load_opal_parser

  read("./medias/rubies/examples/!demos.rb") do |data|
    demos = compile(data)
    demo_reel(demos)
  end