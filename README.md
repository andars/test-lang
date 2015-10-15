# test-lang

Experiment in programming language development.

Pretty massive kludge as of now, but educational so it's chill.

It doesn't have integers per se, but that didn't stop javascript so I'm
fine with it for now. Primitives are borrowed from ruby.

This works:
```
function factorial(n)
  if ( n > 1, n * factorial(n-1), 1)
end
puts(factorial(3))
```

This does too:

```
function f()
  function g(x)
    42+x
  end
end
puts(f()(2))
```
