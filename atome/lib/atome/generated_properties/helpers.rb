module Properties
  def tactile(value = nil, &proc)
    if value.nil? && !proc
      @tactile&.read
    else
      value = properties_common(value, &proc)
      @tactile = atomise(:tactile,value)
      tactile_html(@tactile)
      self
    end
  end 
 def tactile=(value, &proc)
  tactile(value, &proc)
 end

  def display(value = nil, &proc)
    if value.nil? && !proc
      @display&.read
    else
      value = properties_common(value, &proc)
      @display = atomise(:display,value)
      display_html(@display)
      self
    end
  end 
 def display=(value, &proc)
  display(value, &proc)
 end

end
