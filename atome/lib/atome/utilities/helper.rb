# here stand some atome's function to allow atome's objects manipulation


def batch(*params)
  collector=[]
  params.each do |atome|
    collector <<  atome
  end
  collector({content: collector})
end

# def select selector
#   grab(:view).child.each do |atome|
#     collected_atomes = []
#     if atome.selector && atome.selector.include?(:validated)
#       collected_atomes << atome
#     end
#   end
# end

#def selected params
#  #Atomes.atomes
#end

def get(params)
  # alert "helper.rb line 52, params : #{params}"
  #get atome in view from it's id
  #todo get should allow to get object by its property/value (ex : get(color: :red) => return all atome with the property color set to red)
  atomes = Atome.atomes
  if params.class == Hash
    collected_atomes = []
    params.keys.each do |property|
      case property
      when :selector
        value = params[:selector]
        atomes.each do |atome|
          if atome.selector.class == Array && atome.selector.include?(value.to_s)
            collected_atomes << atome
          end
        end
      else
        collected_atomes = []
        get(:view).child.each do |atome|
          if atome.send(params.keys[0].to_sym) && (atome.send(params.keys[0].to_sym).to_sym == params.values[0].to_sym)
            collected_atomes << atome
          end
        end
        return collected_atomes
      end
    end
     collected_atomes
  elsif (params.class == String || params.class == Symbol) && params.to_sym == :all
    #alert "message :\n#{"we slected all children view"}\n from : electron.rb : 80"
  elsif params.class == String || params.class == Symbol
    atomes.each do |atome|
      # alert("atome.id #{atome.id} params #{params}")
      if atome.id[:content].to_s == params.to_s
        return atome
      end
    end

    return false
  end
end

def grab(atome_id)
  #grab atome in view from it's atome_id
  atomes = Atome.atomes
  atomes.each do |atome|
    if atome.atome_id[:value] == atome_id
      return atome
    end
  end
   nil
end

# def scour(params)
#   #search everywhere
#   fiind({value: params, scope: :all})
# end
#
# def dig(params)
#   #search in the trash
#   fiind({value: params, scope: :blackhole})
# end

def filter_system_object
  atomes = Atome.atomes
  filtered_atomes = []
  atomes.each do |atome|
    if atome.id != :dark_matter  && atome.id != :device && atome.id != :intuition && atome.id != :view && atome.id != :actions
      filtered_atomes << atome
    end
  end
   filtered_atomes
end

def found_child_recursively(params)
  params.each do |child_found|
    if child_found.class == Atome
      @childs_found << child_found
      if child_found.child && child_found.child.length > 0
        found_child_recursively child_found.child
      end
    end
  end
end

def filter_atome
  @childs_found = []
  found_child_recursively(self.child)
  @childs_found
end

def find_atome_from_params(params)
  # this function all to return the atome either send and is an atome_id or the atome itself
  if params.class == Atome
    supposed_atome = params
  else
    if   params.class == Hash
      params=params[:content]
    end
    supposed_atome = grab(params) if params.class == String || params.class == Symbol
    #if the first condition return nil now we check if an id exist
    supposed_atome = get(params) unless supposed_atome
  end
  # we return the atome itself
  supposed_atome
end

def find params
  if params == :all
    formated_params={}
    formated_params[:scope]=:all
    params=formated_params
  end
  unless params[:property]
    params[:property]=:all
  end
  if params[:scope] == :all
    filtered_atomes = filter_system_object
  elsif params[:recursive]
    filtered_atomes = self.filter_atome
  else
    filtered_atomes = []
    self.child.each do |atome|
      if atome.class == Atome
        filtered_atomes << atome
      end
    end
  end
  if params[:itself]
    filtered_atomes << self
  end
  atomes_found = []
  if params[:property] == :all
    atomes_found = filtered_atomes
  else
    filtered_atomes.each do |atome|
      if params[:value]
        if atome && atome.send(params[:property])[:content] == params[:value]
          atomes_found << atome
        end
      else
        if atome && atome.send(params[:property])
          atomes_found << atome
        end
      end
    end
  end
  atomes_found
end

# def fiind(params, method = nil)
#   if params.class == String || params.class == Symbol || params.class == Boolean
#     params = if params == true || params == :true
#                {scope: :view, value: :all}
#              else
#                {property: :id, scope: :view, value: params}
#              end
#   end
#   unless params[:scope]
#     params[:scope] = :view
#   end
#   unless params[:property]
#     params[:property] = :id
#   end
#   unless params[:format]
#     params[:format] = :atome
#   end
#   unless params[:value]
#     params[:value] = :all
#   end
#   atomes = case params[:scope]
#            when :all || 'all'
#              Atome.atomes + Atome.blackhole
#            when :blackhole
#              Atome.blackhole
#            when :active
#              Atome.atomes
#            when :view
#              grab(:view).child
#            else
#              #when :dark_matter
#              #  atomes=Atome.atomes + Atome.blackhole
#            end
#   # now we treat
#   if params[:value] == :all || params[:value] == 'all'
#     atomes_found = []
#     # allow to retrieve the object based on it's ID it atome_id or obejct itself
#     case params[:format]
#     when :id || 'id'
#       atomes.each do |atome_found|
#         atomes_found << atome_found.id
#       end
#       #filter_atomes(atomes_found)
#       atomes_found
#     when :atome_id || 'atome_id'
#       atomes.each do |atome|
#         atomes_found << atome.atome_id
#       end
#       #filter_atomes(atomes_found)
#       atomes_found
#     when :atome || 'atome'
#       atomes.each do |atome_found|
#         atomes_found << atome_found
#       end
#       #filter_atomes(atomes_found)
#       atomes_found
#     end
#   else
#     case params[:property]
#     when :id || 'id'
#       atomes_found = ''
#       atomes.each do |atome|
#         if atome.id == params[:value]
#           atomes_found = atome
#         end
#       end
#
#     when :atome_id || 'atome_id'
#       atomes_found = ''
#       atomes.each do |atome|
#         if atome.atome_id ==  params[:value]
#           atomes_found = atome
#         end
#       end
#     when :atome || 'atome'
#       atomes_found = ''
#       atomes.each do |atome|
#         if atome == params[:value]
#           atomes_found = atome
#         end
#       end
#     else
#       # here we get any atomes that match the current prop
#       atomes_found = []
#       atomes.each do |atome|
#         # alert("helper.rb line 210 #{atome.id}")
#         params[:value]
#         if atome.send(params[:property]) == params[:value]
#           atomes_found << atome
#         end
#       end
#     end
#
#   end
#   atomes_found
# end

#def delete params, refresh = true
#  alert "message is \n\n#{params} \n\nLocation: electron.rb, line 60"
#end

def clear(params = :console)
  atome = grab(:device)
  # now we call the clear methods in neutron
  atome.clear(params)
end

def http(url)
  Render.render_http(url)
end

def read(filename, action = :run, code = :ruby) #  read local file
  Render.render_reader filename, action, code
end

def lorem
  <<Strdelilm
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum
Strdelilm
end

#fixme : put whole code in Atome context to be able to remove the method below
def to_px (obj = nil, property = :top)
  Atome.to_px(obj, property)
end


################## time operation  ##############

def wait(seconds, &proc)
  Render.render_wait(seconds) do
    yield
  end
end

def every(delay = 3, times = 5, &proc)
  Render.render_every(delay, times, &proc)
end

def stop params
  Render.render_stop(params)
end

