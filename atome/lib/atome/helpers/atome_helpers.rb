module AtomeHelpers
  # below we can use this method to set the websocket server
  def websocket(adress = "0.0.0.0:9292", ssl = false)
    ssl = if ssl
            "wss"
          else
            "ws"
          end
    # here we can change the server used to handle websocket
    AtomeHelpers.class_variable_set("@@web_socket", WebSocket.new(adress, ssl))
  end

  def message(data, callback = nil)
    # if an address is supply we create a new websocket to contact the specified server
    if data[:address]
      ssl = if data[:ssl]
              "wss"
            else
              "ws"
            end
      WebSocket.new(data[:address], ssl)
      # AtomeHelpers.class_variable_get("@@web_socket").send(data, callback)
    # else
    end

    AtomeHelpers.class_variable_get("@@web_socket").send(data, callback)

  end

  # def shell(command)
  #   AtomeHelpers.class_variable_get("@@web_socket").send({ type: :command, message: command })
  # end

  def authorization(value = nil, &proc)
    if value.nil? && !proc
      @authorization&.q_read
    else
      value = format_parameters_to_hash(value, &proc)
      @authorization = atomise(:authorization, value)
      self
    end
  end

  def authorization=(value, &proc)
    authorization(value, &proc)
  end

  def delete(val = true, option = { remove_from_parent: true })
    case val
    when nil
      # we get the black_hole's content
      # atome_id_to_get= self.atome_id
    when true
      delete_child({ remove_from_parent: false }) unless child.nil? || child.q_read == []
      remove_from_parent if option[:remove_from_parent] == true
      # the condition below exclude intuition's atomes as they don"t have to be stored in the blackhole
      # grab(:black_hole).content[atome_id] = self unless system
      grab(:black_hole).content[atome_id] = self
      delete_html(true)
      Atome.atomes.delete(atome_id)
    when :atome_id
      puts "forbidden to delete the atome_id"
    else
      # we delete the property found in val
      alert "what is the point of this condition"
      instance_variable_set("@#{val}", nil)
    end
  end

  def resurrect the_atome_id, remove_parent = false
    atome_found = grab(:black_hole).content[the_atome_id]
    # alert atome_found.touch[:proc].to_s
    atome_found&.child&.q_read&.each do |child_found|
      resurrect(child_found, true)
    end
    unless atome_found.nil?
      atome_props = atome_found.properties
      atome_props.delete(:parent) if remove_parent
      Atome.new(atome_props)
    end

  end

  def ping(adress = "https://atome.one/", error = "puts' impossible to connect atome main server'", success = "")
    ping_html(adress, error, success)
  end

  def clear(value = true)
    if value.instance_of?(Hash)
      case value.keys[0]
      when :wait
        clear_wait_html(value[:wait])
      when :repeat
        clear_repeat_html(value[:repeat])
      else
        value
      end
    else
      child&.delete(true)
    end

  end

  @@copy = []

  def copy params = nil
    @@copy << self
  end

  def paste options = nil
    case options
    when :parent
    when :properties
      self.set(@@copy.last.properties)
    when :all
      @@copy.each do |copied_item|
        copied_properties = copied_item.properties.merge({ parent: self.atome_id })
        Atome.new(copied_properties)
      end
    else
      copied_properties = @@copy.last.properties.merge({ parent: self.atome_id })
      Atome.new(copied_properties)
    end
  end

  def duplicate(value)
    value = { x: 0, y: 0, offset: { x: 6, y: 6 } }.merge(value)
    (0..value[:y]).each do |y_val|
      (1..value[:x]).each do |x_val|
        atome_property = self.inspect.merge({ atome_id: self.atome_id.to_s + x_val.to_s,
                                              x: self.x + self.width * x_val + value[:offset][:x] * x_val,
                                              y: self.width * y_val + value[:offset][:y] * y_val })
        Atome.new(atome_property)
      end
    end
  end

  def atomiser(value)
    self.instance_variable_set("@" + value.keys[0], self.atomise(value.keys[0].to_sym, value.values[0]))
  end

  def properties(params = nil)
    if params || params == false
      error("info is read only!! for now")
    else
      properties = {}
      instance_variables.map do |attribute|
        # puts "#{attribute} instance_variables may be changed to atome_methods.each atome_helper.rb line 74\n
        # or try to remove @touch_proc and @dragged and find a solution to replace it"
        properties[attribute.sub("@".to_sym, "")] = if instance_variable_get(attribute).nil?
                                                      nil
                                                      # elsif instance_variable_get(attribute).class == Quark
                                                    else
                                                      instance_variable_get(attribute).q_read
                                                    end
      end
      properties
    end
  end

  def inspect
    properties
  end

  # def play(options = nil, &proc)
  #   if options.nil?
  #     @play
  #   else
  #     options = case options
  #               when true
  #                 { play: :play, status: :playing }
  #               when false
  #                 { play: :stop, status: :stopped }
  #               when :pause
  #                 { play: :pause, status: :paused }
  #               when :stop
  #                 { play: :stop, status: :stopped }
  #               when :play
  #                 { play: :play, status: :playing }
  #               else
  #                 { play: options, status: :playing }
  #               end
  #     # the condition below check we dont specify a play position and if the
  #     # @play contain a play position, if so it resume playback specify in @play
  #     if @play && ((@play[:play].instance_of?(Integer) || @play[:play].instance_of?(Number)) && (options[:play] == true || options[:play] == :play))
  #       options = { play: @play[:play], status: :playing }
  #       # if @play
  #       #   alert @play
  #       #   options = { play: 12 }
  #     end
  #     @play = options
  #     play_html(options[:play], proc)
  #   end
  # end

  def transmit(values)
    case values.keys[0]
    when :midi
      msg = if values[:midi].instance_of?(Hash)
              values[:midi].keys[0]
            else
              values[:midi]
            end
      case msg
      when :play
        note = values[:midi][:play].delete(:note)
        channel = values[:midi][:play].delete(:channel)
        options = values[:midi][:play]
        midi_play(note, channel, options)
      when :control
        controller = values[:midi][:control].delete(:controller)
        value = values[:midi][:control].delete(:value)
        channel = values[:midi][:control].delete(:channel)
        midi_controller(controller, value, channel, channel, channel)
      when :stop
        note = values[:midi][:stop].delete(:note)
        channel = values[:midi][:stop].delete(:channel)
        options = values[:midi][:stop]
        midi_stop(note, channel, options)
      when :inputs
        midi_inputs
      when :outputs
        midi_outputs
      else
        values
      end
    when :beaglebone
      # bbb communication layer
    when :shell
      text("shell value from atome_helpers.rb line 97 : #{values[:shell]}")
    else
      value
    end
  end

  def fixed(value)
    fixed_html(value)
  end

  def convert(property)
    convert_html property
  end

  def insert(children)
    grab(children).parent(self.atome_id)
  end

  def extract(child_to_detach)
    child_to_treat = grab(child_to_detach)

    self.remove_child child_to_detach
    child_to_treat.remove_parent self.atome_id.to_s
    child_to_treat.render(true)
    # FIXME: ugly patch to keep text content find why it's lost
    if child_to_treat.type == :text
      lang = child_to_treat.language || grab(:view).language
      prev_content = child_to_treat.content.q_read
      if prev_content.instance_of?(Hash)
        content_to_refresh = prev_content[lang] || prev_content[:default]
        child_to_treat.content(content_to_refresh)
      else
        child_to_treat.content(child_to_treat.content)
      end
    end
  end

  def attach(children)
    insert(children)
  end

  def detach(child_to_detach)
    extract(child_to_detach)
  end

  def transfer(new_parent)
    grab(new_parent).insert(self.atome_id)
    grab(self.parent[0].q_read).extract(self.atome_id)
  end

  def eden_find(query)
    #FIXME: Universe will be a db that contain users user's media and so on, for now Universe only hold default medias
    case query[:type]
    when :image
      Universe.images[query[:name]]
    when :video
      Universe.videos[query[:name]]
    when :audio
      Universe.audios[query[:name]]
    else
      query
    end
  end

  def child_analysis (collected_child, atome, recursive)
    if recursive == true || recursive > 0
      recursive = recursive - 1 if recursive.instance_of?(Number) || recursive.instance_of?(Integer)
      if atome.child && atome.child.length > 0
        collected_child << atome
        atome.child.each do |baby_child|
          child_analysis collected_child, baby_child, recursive
        end
      else
        collected_child << atome
      end
      collected_child.uniq!
    end
  end

  def find(query)
    unless query[:scope]
      # if there's no scope we assume we need to search amongst the the current atome's children
      query[:scope] = :atome
    end
    unless query[:condition]
      # if there's no condition we assume user want to use the or condition
      query[:condition] = :or
    end
    ##### filtering unnecessary params
    recursive = query.delete(:recursive)
    scope = query.delete(:scope)
    condition = query.delete(:condition)

    case scope
    when :eden
      # we will search in dbs and files
      found = eden_find(query)
      return found
    when :atome
      # we will search amongst current atome's children
      collected_child = []
      child&.each do |child_found|
        collected_child << child_found
        child_analysis collected_child, child_found, recursive if recursive
      end

      match_items = []
      restricted_items = collected_child.clone

      collected_child.each do |child_match_query|
        query.each_key do |method_to_look_at|
          value_to_find = query[method_to_look_at]
          if child_match_query.send(method_to_look_at).instance_of?(Array)
            if child_match_query.send(method_to_look_at).include?(value_to_find)
              match_items << child_match_query
            else
              restricted_items.delete(child_match_query)
            end
          elsif child_match_query.send(method_to_look_at) == value_to_find
            match_items << child_match_query
          else
            restricted_items.delete(child_match_query)
          end
        end
      end
      if condition == :and
        atome_to_treat = batch(restricted_items)
      elsif condition == :or
        atome_to_treat = batch(match_items)
      end

      # grab(:finder).content(atome_to_treat)
      # alert  grab(:finder).content
      return atome_to_treat

    else
      ''
    end

    ########### old below
    # if methods.include?(query.keys[0])
    #   value_to_find = query[query.keys[0]]
    #   method_to_look_at = query.keys[0]
    #   found_items = []
    #
    #   found.each do |found_item|
    #     if found_item.send(method_to_look_at).instance_of?(Array)
    #       if found_item.send(method_to_look_at).include?(value_to_find)
    #         found_items << found_item
    #       end
    #     elsif found_item.send(method_to_look_at) == value_to_find
    #       found_items << found_item
    #     end
    #   end
    #   found = batch(found_items)
    # end
    # found
  end

  # def group(value = nil, &proc)
  #   if value.nil? && !proc
  #     @group&.q_read
  #   else
  #     content = find(value[:condition])
  #     Atome.new({ type: :find, render: false, name: value[:name], content: content, condition: value[:condition], dynamic: value[:dynamic] })
  #     value = properties_common(value, &proc)
  #     @group = atomise(:content, value)
  #     self
  #   end
  # end

  def to_h
    properties
  end

  def each(&proc)
    @property.each do |property|
      proc.call(grab(property)) if proc.is_a?(Proc)
    end
  end

end
