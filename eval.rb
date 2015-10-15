#!/usr/bin/env ruby
require_relative 'ast'
require_relative 'token'
require_relative 'lexer'
require_relative 'parser'
require_relative 'context'

parser = Lang::Parser.new(STDIN.read)
ast = parser.parse
#puts ast.statements
puts "-"*10
ast.eval(Lang::Context.new)
