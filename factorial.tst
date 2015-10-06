function factorial(n,x)
  if ( n > 1, n * factorial(n-1,0), 1)
end
puts(factorial(5, 0))
