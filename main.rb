#bin/main.rb

require_relative "class/World.rb"

#data input method interface
loop do 
	puts "GO-CLI: Online Ojek Application"
	puts "-------------------------------"
	puts "Choose your settings:"
	puts "    1. Default"
	puts "    2. Custom"
	puts "    3. From files"
	print "Setting: "
	@_load = gets.to_i
	if ((@_load >= 1)&&(@_load <= 3))
		break
	else
		puts ""
		puts "invalid input, please choose between 1, 2, or 3"
		sleep(0.5)
	end	
end

world = World.new(@_load)
world.start
