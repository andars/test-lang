function factorial(n,x)
  if ( gt(n,1), mul(n, factorial(dec(n),0)), 1)
end
puts(factorial(5, 0))
