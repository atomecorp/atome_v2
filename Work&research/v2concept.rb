class Universe
  def self.creator(user)
    @user = user
    @atomes=[]
    Atome.new({ universe: :universe })
  end
  def self.atomes_add(new_atome)
    @atomes << new_atome
  end

  def self.atomes
    @atomes
  end
  def self.active_creator
    @user
  end

  def self.current_machine
    platform = RUBY_PLATFORM.downcase
    output = `#{(platform =~ /win32/) ? 'ipconfig /all' : 'ifconfig'}`
    case platform
    when /darwin/
      $1 if output =~ /en1.*?(([A-F0-9]{2}:){5}[A-F0-9]{2})/im
    when /win32/
      $1 if output =~ /Physical Address.*?(([A-F0-9]{2}-){5}[A-F0-9]{2})/im
      # Cases for other platforms...
    else
      nil
    end
  end

  def self.location
    :clermont
  end

  def self.identity_generator
    "#{@user}_#{current_machine}_#{location}_#{(Time.now.to_f * 1000).to_i}"
  end
end

class Atome
  def initialize(params)
    @atome = {}
    params.each do |property, value|
      @atome[property] = Particle.new(property, value)
    end
    Universe.atomes_add(@atome)
    @atome
  end

  def type
    @atome[:type]
  end

  def property_common(property, value, dynamic)
    if value.nil?
      @atome[property]
    elsif value.instance_of?(Particle) && dynamic
      @atome[property] = value
    elsif value.instance_of?(Particle)
      value.value.each do |value_found|
        @atome[property] = Particle.new(property, value_found)
      end
    else
      # send "set_#{property}_value", value
      @atome[property] = Particle.new(property, value)
    end
  end

  def atome_router(property, value, options, stack_property)
    value = send("#{property}_pre_processor", value) if options[:pre_process]
    # if the pre_processor decide that the value shouldn't be store and render it must return nil
    atome_creation(property, value, stack_property) if options[:store_property] != false
    send_to_render_engine(property, value) if options[:render_property] != false
    value = send("#{property}_post_processor", value) if options[:post_process]
    method_return value
    @atome[property]
  end

  ########## solution

  # def set_preset_value(value)
  #   @atome[:preset] = Particle.new(:preset, value)
  # end
  #
  # def set_preset_particle(value)
  #   @atome[:preset] = value
  # end
  #
  # def get_preset
  #   @atome[:preset]
  # end

  def preset(value = nil, dynamic = false)
    property_common(:preset, value, dynamic)
  end

  def preset=(value)
    preset(value)
  end

  ##########

  def add(params)
    params.each do |property, value|
      @atome[property] << { property => value }
    end
  end

  ###### solution 2
  def put(property, value)
    @atome[property] = Particle.new(property, value)
  end

  def read(property)
    @atome[property].value
  end

  #######
  def adds(params)
    params.each do |param|
      param.each do |property, value|
        @atome[property] << { property => value }
      end
    end
  end

end

class Particle
  def initialize(param, value)
    instance_variable_set("@#{param}", [{ value: value, id: Universe.identity_generator }])
  end

  def value
    values = []
    instance_variable_get(self.instance_variables[0]).each do |val|
      values << val[:value]
    end
    values
  end

  def <<(val)
    property_we_wil_add_into = instance_variable_get(self.instance_variables[0])
    property_we_wil_add_into << { value: val.values[0], id: Universe.identity_generator }
  end

end

Universe.creator(:eVe)
a = Atome.new({ type: :shape, preset: :box, id: :the_box,
                atome: { type: :child, id: Universe.identity_generator, dynamic: true },
                # atome: {type: :top, id: :a_09865653 } ,
                color: :red })
# puts a.inspect
# puts a.type.inspect

a.add({ preset: :circle })
a.adds([{ preset: :triangle }, { preset: :image }])
# puts a.read(:preset)
a.preset(:toto)
# a.put(:preset, :cube)
# puts a.read(:preset)
# puts a.preset.class
# puts a.preset.value
a.preset(a.type) #dynamic
# a.preset(a.type, :dynamic) # static
puts a.preset.inspect
puts Universe.atomes.length