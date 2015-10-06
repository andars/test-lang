module Lang
  class Parser
    
    def initialize(str)
      @lexer = Lexer.new(str)
    end
    
    def parse
      body
    end

    def body
      stmts = []
      e = top_level
      while e 
        stmts.push e
        e = top_level
      end
      AST::Body.new(stmts)
    end

    def top_level
      swallow
      return nil if peek.nil? or peek.type == :END
      e = case peek.type
      when :FUNCTION
        function
      when :ID, :NUMBER
        expression 0
      else
        nil
      end
      swallow
      e
    end

    def expression(precedence)
      lhs = atom

      loop do
        curr = peek
        break if curr.nil?

        info = curr.info
        break if info.nil?

        op_prec, op_assoc = info
        break if op_prec < precedence

        next_token #swallow operator
        rhs = expression op_prec+op_assoc
        lhs = operator curr, lhs, rhs
      end
      lhs
    end

    def atom
      if peek.type == :NUMBER
        AST::Number.new(next_token.value)
      else
        call
      end
    end

    def operator(op, lhs, rhs)
      AST::Call.new(function: op.value, args: [lhs, rhs])
    end

    def call
      assert_token next_token, :ID
      id = token.value
      if peek.type != :LPAREN
        return reference(id)
      else
        next_token #swallow LPAREN
      end
      args = []
      while peek.type != :RPAREN
        args.push(expression 0)
        #if peek.type == :ID
        # args.push AST::Variable.new(name: next_token.value)
        #elsif peek.type == :NUMBER
        # args.push AST::Number.new(next_token.value)
        #end
        if peek.nil? or peek.type != :COMMA
          break
        elsif !peek.nil? and peek.type == :COMMA
          next_token
        end
      end
      assert_token next_token, :RPAREN
      AST::Call.new(function: id, args: args) 
    end

    def reference(id)
      AST::Variable.new(name: id)
    end
    
    def function
      assert_token next_token, :FUNCTION
      assert_token next_token, :ID
      name = token.value

      args = []
      assert_token next_token, :LPAREN
      while peek.type == :ID
        args.push next_token.value
        break if peek.type != :COMMA
        next_token #swallow comma
      end
      assert_token next_token, :RPAREN

      assert_token next_token, :NEWLINE
      fun = AST::Function.new(name: name, arguments:args, body: body)
      assert_token next_token, :END
      fun
    end
    
    def swallow
      while !peek.nil? and peek.type == :NEWLINE
        next_token
      end
    end

    def assert_token(token, *types)
      raise Exception, "unexpected type: #{token.type}" unless types.include? token.type
    end

    def token
      @current
    end

    def next_token
      #puts "advancing from #{@current.type}:#{@current.value} to #{peek.value}" unless @current.nil?
      @current = @peeked || @lexer.next_token
      @peeked = nil
      token
    end

    def peek
      @peeked ||= @lexer.next_token
      
    end
  end
end
