def code(value = {atome_id: identity, content: ""})
  JSUtils.load_opal_parser
  container_id = value[:atome_id]
  ide_atome_id = container_id.to_s + "_code_editor"
  content = value[:content]
  container_preset = value.merge({atome_id: container_id, parent: :intuition,
                                   width: 500, height: 300,
                                  shadow: {x: 0, y: 0, blur: 6, thickness: 0,
                                           color: {red: 0, green: 0, blue: 0, alpha: 0.6}, invert: false}})
  editor_value = {atome_id: ide_atome_id, width: 500, height: 300, y: 24}

  # we create the code editor container
  container = box(container_preset)
  handle=container.box({x:0, x: 0, width: "100%", height: 24, color: :black, atome_id: "handler_"+ide_atome_id})
  code_editor = container.box(editor_value)
  code_editor.type(:machine)
  #code_editor.selector({machine: :code_editor})
  code_editor.touch({option: :stop}) do |evt|
    evt
    #evt.stop_immediate_propagation
  end
  code_editor.size({value: 500, option: {'nw': '#nwgrip'}}) do |evt_size|
    evt_size
    container.width = code_editor.width
    container.height = code_editor.height
  end
  ATOME.load_codemirror(ide_atome_id, content)
  run = container.circle({width: 20, height: 20, x: 3, y: 3})
  close = container.box({width: 20, height: 20, x: 30, y: 3, color: :gray})
  run.touch do
    clear(:view)
    #the line below store the current state in the buffer object
    grab(:buffer).content=grab(:buffer).content.merge(code_editor: {content: ATOME.get_ide_content(ide_atome_id), x: grab(container_id).x, y: grab(container_id).y})
    compile(ATOME.get_ide_content(ide_atome_id))
  end
  close.touch do
    #the line below store the current state in the buffer object
    grab(:buffer).content=grab(:buffer).content.merge(code_editor: {content: ATOME.get_ide_content(ide_atome_id), x: grab(container_id).x, y: grab(container_id).y})
    grab(container_id).delete
  end
  container.drag({handle: "handler_"+ide_atome_id})
  code_editor

end