#!/usr/bin/env ruby
require_relative '../config/environment'

# prints a sick ASCII image
puts `clear`
puts " ========================="
puts " = WELCOME TO LEE-TRADE! ="
puts " ========================="
puts "         ___       "
puts "       _|___|_     "   
puts "      　( "+"$".colorize(:green)+"_"+"$".colorize(:green)+")"
puts "     　┌/つ /￣￣￣/   "
puts "     ￣￣＼/＿＿＿/￣  "
puts "     "

# calls the #user_cli method in 'methods.rb'
user_cli