#bin/class/Driver.rb

require_relative "User.rb"

class Driver

	attr_accessor :name
	attr_accessor :x
	attr_accessor :y
	attr_accessor :unit_cost

	def initialize (name, x, y, unit_cost)
		@name = name
		@x = x
		@y = y
		@unit_cost = unit_cost
	end
	
	def moveX (dest)
		dx = @x - dest
		if (dx > 0) 	#above
			@x -= 1
		elsif (dx < 0)	#below
			@x += 1
		end		
	end
	
	def moveY (dest)
		dy = @y - dest
		if (dy > 0) 	#above
			@y -= 1
		elsif (dy < 0)	#below
			@y += 1
		end
	end
	
	def generate_price (unit_distance)
		price = unit_cost * unit_distance
	end

end
