module Lang
  class Token
    attr_accessor :type, :value

    def initialize(type:, value:)
      @type = type
      @value = value
      @info = {}
      @info[:LT] = [5, 1]
      @info[:GT] = [5, 1]
      @info[:PLUS] = [10, 1]
      @info[:DASH] = [10, 1]
      @info[:STAR] = [20, 1]
      @info[:SLASH] = [20, 1]
      @info[:CARET] = [30, 0]
    end

    def info
      @info[type]
    end
  end
end
