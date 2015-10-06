module Lang
  module Builtins
    def puts(x)
      p x[0].eval(self)
    end

    def inc(x)
      p "incrementing #{x[0].eval(self)}"
      x[0].eval(self)+1
    end

    def dec(x)
      x[0].eval(self)-1
    end

    def mul(args)
      args[0].eval(self) * args[1].eval(self)
    end

    def if(args)
      if args[0].eval(self)
        args[1].eval(self)
      else
        args[2].eval(self)
      end
    end

    [:+, :-, :*, :/, :>, :<].each do |sym|
      define_method(sym) do |args|
        operator(args, sym)
      end
    end

    def ^(args)
      operator(args, :**)
    end

  private
    def evaluate(args)
      args.map{|x| x.eval(self)}
    end

    def operator(args,sym)
      evaluate(args).inject(sym)
    end
  end
end
