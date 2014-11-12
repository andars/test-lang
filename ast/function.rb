module Lang::AST
	class Function < Base
		attr_accessor :name, :arity, :arguments, :body	
		
		def initialize(name:, arguments:, body:)
			@name = name
			@arguments = arguments
			@body = body
		end
		def eval(context)
			context.set(name.to_sym, ->(x){
				arguments.each_with_index do |arg, i|
					context.set(arg.to_sym, x[i].eval(context))
				end
				val = self.body.eval(context)
				arguments.each do |arg|
					context.remove(arg.to_sym)
				end
				val
			})
		end

	end
end
