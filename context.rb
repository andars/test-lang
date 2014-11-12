module Lang
  class Context

    def initialize
      @env = {
        puts: ->(x){puts x[0].eval(self)},
        inc: ->(x){
            puts "incrementing #{x[0].eval(self)}"
            x[0].eval(self)+1
           },
        dec: ->(args) {
          args[0].eval(self)-1
        },
        mul: ->(args) {
          args[0].eval(self) * args[1].eval(self)
        },
        if: ->(args) {
          if args[0].eval(self) 
            args[1].eval(self)
          else
            args[2].eval(self)
          end
        },
        gt: ->(args) {
          #puts "#{args[0].eval(self)} > #{args[1].eval(self)}?"
          args[0].eval(self) > args[1].eval(self)
        }
      }
    end

    def get(name)
      if name.is_a? String
        name = name.to_sym
      end
      value = @env[name]
      if value.nil?
        raise Exception, "undefined variable #{name} in current scope"
      end
      value
    end

    def set(name, val)
      @env[name] = val
    end

    def remove(name)
      @env.delete name
    end
  end
end
