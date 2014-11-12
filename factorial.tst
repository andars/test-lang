function factorial n begin
  if ( gt(n,1), mul(n, factorial(dec(n))), 1)
end
puts(factorial(3))
