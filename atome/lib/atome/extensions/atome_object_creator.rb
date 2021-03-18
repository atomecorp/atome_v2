def box(value = {})
  grab(:view).box(value)
end

def circle(value = {})
  grab(:view).circle(value)
end

def text(value = {content: lorem})
  grab(:view).text(value)
end

def image(value = {})
  grab(:view).image(value)
end

def video(value = {})
  grab(:view).video(value)
end

def audio(value = {})
  grab(:view).audio(value)
end

def code(value = {atome_id: identity, content: ""})
  JSUtils.load_opal_parser
  container_id=value[:atome_id]
  ide_atome_id = container_id.to_s+"_code"
  content = value[:content]
  # we create the code editor container
  container=box(drag: true, width: 500, atome_id: container_id)
  #cc=container.circle({x: 300, atome_id: container_id.to_s+"poil"})
  value = value.merge({atome_id: ide_atome_id, y: 33, width: 500, height: 300, shadow: {x: 0, y: 0, blur: 6, thickness: 0, color: {red: 0, green: 0, blue: 0, alpha: 0.6}, invert: false}})
  code_editor = container.box(value)

  code_editor.touch({option: :stop}) do |evt|

    #evt.stop_immediate_propagation
  end
  code_editor.size({value: 500, option: {'nw': '#nwgrip'}}) do |evt_size|
    container.width=code_editor.width
    code_editor.y
  end
  ATOME.load_codemirror(ide_atome_id, content)
  run = container.circle({width: 20, height: 20, x: 3, y: 3})
  close = container.box({width: 20, height: 20, x: 30, y: 3, color: :gray})
  run.touch do
    compile(ATOME.get_ide_content(ide_atome_id))
  end
  close.touch do
    grab(container_id).delete
  end
  code_editor
end