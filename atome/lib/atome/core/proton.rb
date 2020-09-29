# here the methods to create default values, properties and presets to atome objects
module Nucleon
  module Core

    module Proton

      #We use call variable here so user can change default value using Proton.presets method
      @@visual = {}
      @@shape = @@visual.merge({})
      @@box = @@visual.merge(@@shape)
      @@circle = @@visual.merge(@@shape).merge({})
      @@text = @@visual.merge({})
      @@image = @@visual.merge({})
      @@video = @@visual.merge({})
      @@audio = @@visual.merge({})
      @@particle = {}
      @@tool = @@visual.merge({})
      @@web = @@visual.merge({})
      @@user = @@visual.merge({})
      @@color = {}
      @@shadow = {}
      @@border = {}
      @@blur = {}

      def self.types
        visual = {color: :lightgray, center: {y: 43, x: 16, dynamic: false}, z: 0, overflow: :visible, parent: :view}.merge(@@visual)
        shape = visual.merge({type: :shape, width: 70, height: 70, content: {points: 4}}).merge(@@shape)
        box = visual.merge(shape).merge(@@box)
        circle = visual.merge(shape).merge({color: :red, content: {points: 4, tension: "100%"}}).merge(@@circle)
        text = visual.merge({type: :text, color: 'rgb(7,7,7)', size: 25, content: lorem}).merge(@@text)
        image = visual.merge({type: :image, color: :transparent}).merge(@@image)
        video = visual.merge({type: :video, color: :transparent}).merge(@@video)
        audio = visual.merge({type: :audio, color: :transparent}).merge(@@audio)
        particle = {type: :particle}.merge(@@particle)
        tool = visual.merge({type: :tool, width: 52, height: 50, parent: :intuition}).merge(@@tool)
        web = visual.merge({type: :web, color: :transparent}).merge(@@web)
        user = visual.merge({type: :user, color: :transparent, name: :anonymous, pass: :none}).merge(@@user)
        color = {content: :black}.merge(@@color)
        shadow = {x: 0, y: 0, blur: 7, thickness: 0, color: 'rgba(0,0,0,0.3)', invert: false}.merge(@@shadow)
        border = {default: {thickness: 1, pattern: :dotted, color: :black}}.merge(@@border)
        blur = {default: 5}.merge(@@blur)

        types = {
            shape: shape,
            box: box,
            circle: circle,
            text: text,
            image: image,
            video: video,
            audio: audio,
            particle: particle,
            tool: tool,
            web: web,
            user: user,
            color: color,
            shadow: shadow,
            border: border,
            blur: blur,
        }
        return types
      end

      def self.presets params = nil
        if params
          key_found = params.keys[0].to_s
          values_found = params.values[0]
          new_value = class_variable_get("@@#{key_found}").merge(values_found)
          class_variable_set("@@#{key_found}", new_value)
        else
          return types
        end
      end
    end
  end
end


