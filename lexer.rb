module Lang
  class Lexer
    def initialize(str)
      @str = str
      @offset = 0
    end

    def next_token
      TOKENS.each do |token|
        match = token[1].match @str, @offset
        if match
          value = token[2].(match) if token[2]  
          tok = Token.new(type: token[0], value: value)
          @offset += match[0].size
          if [:COMMENT, :WHITESPACE].include? token[0]
            return next_token
          else
            return tok
          end
        end
      end
      return nil if @offset >= @str.size
      raise Exception, "unexpected symbol #{@str[@offset]}"
    end

    TOKENS = [
      [:WHITESPACE, /[ \t\f]+/m ],
      [:NEWLINE, /[\n\r]/m],
      [:NUMBER, /-?(([1-9]\d*)|0)(.[0-9]([0-9])*)?/m, ->(match){match[0].to_f}],
      [:CALL, /call/m],
      [:FUNCTION, /function/m],
      [:BEGIN, /begin/m],
      [:END, /end/m],
#     [:IF, /if/m],
      [:ID, /[a-zA-Z_\$][\$a-zA-Z_0-9]*/, ->m { m[0] } ],
      [:PLUS, /\+/m],
      [:MINUS, /-/m],
      [:LPAREN, /\(/m],
      [:RPAREN, /\)/m],
      [:STAR, /\*/m],
      [:SLASH, /\//m],
      [:COMMA, /,/m]
    ].map do |rule|
      [rule[0], /\G#{rule[1].source}/m, rule[2]]
    end
  end
end
