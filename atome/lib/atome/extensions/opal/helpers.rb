module JSUtils
  def jq_get(atome_id)
    Element.find("##{atome_id}" )
  end

  def self.device
    `window`
  end

  def self.document
    `$(document)`
  end

  # helper to get text or any html element real size
  def self.client_height(atome_requested)
    `(document.getElementById(#{atome_requested}).clientHeight + 1)`
  end

  def self.client_width(atome_requested)
    `(document.getElementById(#{atome_requested}).clientWidth + 1)`
  end

  def self.fit_text_width(atome_id)
    `fitTextWidth(#{atome_id}) `
  end

  def self.fit_text_height(atome_id)
    `fitTextHeight(#{atome_id}) `
  end

  def self.select_text_content(atome_id, selection)
    `atome.select_text_content(#{atome_id}, #{selection})`
  end

  # helper to check if we have a tactile device
  def mobile?
    `atome.jsIsMobile()`
  end

  def self.load_opal_parser
    `$.getScript('js/dynamic_libraries/opal/opal_parser.js', function (data, textStatus, jqxhr) {#{@opal_parser = true}})`
    require "opal-parser"
  end

  def self.opal_parser_ready
    @opal_parser
  end



  def self.get_object_under_pointer(evt)
    ` atome.jsGet_items_under_pointer(#{evt.to_n})`
  end

  def self.ping(adress, error, success)
    `atome.jsPing(#{adress},#{success}, #{error})`
  end

  def self.adress_callback(datas, proc)
    proc.call(datas) if proc.is_a?(Proc)
  end

  def self.on_adress_change(&proc)
    `atome.jsAdress(#{proc})`
  end

  def self.adress(adress)
    `history.pushState({ atome: #{adress} }, "page_label", "../"+#{adress})`
  end

  def self.map(atome_id, longitude, lattitude)
    `atome.jsMap(#{atome_id},#{longitude},#{lattitude})`
  end

  def self.calendar(atome_id, params)
    `new CalendarHelper(#{atome_id}, #{params})`
  end

  def self.meteo_callback(datas, proc)
    proc.call(datas) if proc.is_a?(Proc)
  end

  def self.meteo(location, &proc)
    `new MeteoHelper(#{location}, #{proc})`
  end

  def self.js_fullscreen (element,params)
    `atome.jsFullscreen(#{element},#{params})`
  end

  def self.reboot
    `window.location.reload()`
  end


  def self.slider_callback target, function, value, atome_id=nil
    if atome_id
      slider_value_id ="#{atome_id}_value"
      grab(slider_value_id).content(value.to_s)
      grab(target).send(function, value)
    end

  end

  def self.slider(atome_id, params)
    if params[:type] == :circular
      `
      circular_sliders(
      #{params[:atome_id]},#{params[:target]},
      #{params[:length]}, #{params[:thickness]},
      #{params[:helper_length]},  #{params[:helper_thickness]},
      #{params[:value_size]},
      #{params[:back_color]}, #{params[:range_color]}, #{params[:helper_color]}, #{params[:value_color]},
      #{params[:value]},#{params[:unit]},#{params[:min]},#{params[:max]},  #{params[:smoothing]},#{params[:target]},#{params[:function]});
`
    else
      `
      rectangular_sliders(
      #{params[:atome_id]},#{params[:target]},
      #{params[:length]}, #{params[:thickness]},
      #{params[:helper_length]},  #{params[:helper_thickness]},
      #{params[:value_size]},
      #{params[:back_color]}, #{params[:range_color]}, #{params[:helper_color]}, #{params[:value_color]},
      #{params[:value]},#{params[:unit]},#{params[:min]},#{params[:max]}, #{params[:smoothing]},#{params[:target]},#{params[:function]}, #{params[:type]});
`
    end

  end

end
