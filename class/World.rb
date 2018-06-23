#bin/class/World.rb

require_relative "Driver.rb"
require_relative "User.rb"

class World

	attr_accessor :n
	attr_accessor :board
	attr_accessor :arr_driver
	attr_accessor :assigned_driver
	attr_accessor :user
	attr_accessor :distance
	
	def initialize (_load)
		@assigned_driver = nil
		@distance = 0
		@arr_driver = Array.new(0)
		
		if (_load == 1 )
			@n = 20
			print " Input unit rates : "
			unit_cost = gets.to_i
			generate(@n, Random.rand(20), Random.rand(20), unit_cost)
		elsif (_load == 2)
			puts " The map size would be = n*n"
			print " Input map dimension (n) : "
			@n = gets.to_i
			while (@n<3)
				puts "Map too small! Input map size bigger than 2"
				@n = gets.to_i
			end
			print " Input user coordinates (x) : "
			x = gets.to_i
			print " Input user coordinates (y) : "
			y = gets.to_i
			print " Input unit rates : "
			unit_cost = gets.to_i
			generate(@n, x, y, unit_cost)
		elsif (_load == 3)
			Dir.chdir("C:/Users/user/Desktop/gocli")
			arr = IO.readlines('world_data.txt')
			#generating boards
			@n = arr[0].slice(3..arr[0].length-1).to_i
			if (@n<3)
				puts "Map too small! Map size resized to 5*5"
				@n = 5
			end
			@board = init_board(@n, ' ')
			
			#generating user
			un = arr[1].slice(3..arr[0].length-1)
			ux = arr[2].slice(3..arr[0].length-1).to_i
			uy = arr[3].slice(3..arr[0].length-1).to_i
			@user = User.new(un, ux, uy)
			
			#generating drivers
			nd = arr[4].slice(3..arr[0].length-1).to_i
			uc = arr[5].slice(3..arr[0].length-1).to_i
			@arr_driver = Array.new(0)
			for i in 1..nd do
				name = arr[(i+1)*3].slice(3..arr[0].length-1)
				dx = arr[(i+1)*3+1].slice(3..arr[0].length-1)
				dy = arr[(i+1)*3+2].slice(3..arr[0].length-1)
				driver = Driver.new(name, dx, dy, uc)
				@arr_driver.push(driver)
			end
		end
		
		#map tagging
		@board[user.x][user.y] = "$"
		@arr_driver.each do |d|
			@board[d.x][d.y] = "@"
		end
	end

	def generate(n, x, y, unit_cost)
		#generate plain board filled with spaces
		@board = init_board(n, ' ')
		
		#generating 5 drivers
		@driver1 = Driver.new("Andi", Random.rand(@n), Random.rand(@n), unit_cost)
		@driver2 = Driver.new("Budi", Random.rand(@n), Random.rand(@n), unit_cost)
		@driver3 = Driver.new("Caca", Random.rand(@n), Random.rand(@n), unit_cost)			
		@driver4 = Driver.new("Dodi", Random.rand(@n), Random.rand(@n), unit_cost)
		@driver5 = Driver.new("Echa", Random.rand(@n), Random.rand(@n), unit_cost)

		#driver listing
		@arr_driver = [@driver1, @driver2, @driver3, @driver4, @driver5]
	
		#generating user
		@user = User.new("John Doe", x, y)
	end
	
	#generating n*n board with default value as parameters
	def init_board(n, def_val)
		Array.new(n) { Array.new(n) { def_val } }
	end
	
	#start running program
	def start
		loop do 
			puts "Choose your services:"
			puts "    1. Show map"
			puts "    2. Order Go-Ride"
			puts "    3. View history"
			puts "    4. Quit"
			print "Service: "
			@menu = gets.to_i
			if ((@menu >= 1)&&(@menu <= 4))
				case @menu
					when 1 then show_map
					when 2 then order
					when 3 then history
					when 4 then 
						puts "See you again!"
						break
				end
			else
				puts ""
				puts "invalid input, please choose between 1, 2, 3, or 4"
				sleep(0.5)
			end	
		end
		
	end	

	#printing class board
	def show_map	
		system "cls"
		puts "GO-CLI Local Map"
		
		#printing first border
		for i in 0..(@n+1) do
			print "#"
		end
		puts ""
		
		#printing main map
		for i in 0...@n do
			print "#"
			for j in 0...@n do
				print @board[i][j]
			end
			print "#"
			puts ""
		end
		
		#printing end border
		for i in 0..(@n+1) do
			print "#"
		end
		puts ""
	end
	
	#show steps of user ordering GO-CLI
	def order
		print "Your destination (x) : "
		x = gets.to_i-1
		print "Your destination (y) : "
		y = gets.to_i-1
		search									#get @assigned_driver
		estimate(@user.x, @user.y, x, y)		#get @dx and @dy
		puts "Take this order?"
		puts "    1. Yes"
		puts "    2. No"
		opt = gets.to_i
		while ((opt >= 1)&&(opt<=3))
			if (opt == 1)
				steps = @dx.abs + @dy.abs
				price = @assigned_driver.generate_price(steps)
				puts "Your total price : #{price}"
				puts "Confirm order completion"
				puts "    1. Done"
				puts "    2. Not Done"
				confirm = gets.to_i
					if (confirm == 1)
						([@dx.abs, @dy.abs].max).times do 
							@assigned_driver.moveX(x)
							@assigned_driver.moveY(y)
						end
						@user.save_log(@user.x, @user.y, x, y, steps, price)
						
						@board[@user.x][@user.x] = " "
						@user.x = @assigned_driver.x
						@user.y = @assigned_driver.y
						@board[@user.x][@user.x] = "$"
						
						@user.save_file
						puts "See you later!"
						break
					else
						puts "Please confirm when the trip has completed!"
					end
			elsif (opt == 2)
				puts "See you later!"
				break
			else
				puts "Option invalid, please select 1 or 2"
				opt = gets.to_i
			end
		end
	end
	
	#shows user's history from array
	def history
		@user.show_log
	end
	
	#assigning nearest driver to user
	def search
		min = 2**30 - 2 			#maximum for 32-bit
		test = 0
		@arr_driver.each do |driver|
			test = (driver.x - user.x)**2 + (driver.y - user.y)**2
			test = Math.sqrt(test)
			if (test<min)
				min = test
				@assigned_driver = driver
			end
		end
	end
	
	#after search, estimating pathway
	def estimate(x, y, dest_x, dest_y)
		@dx = x - dest_x
		@dy = y - dest_y
		state = copy_state(@board)
		
		@board[dest_x][dest_y] = "X"
		sum_x = @dx
		sum_y = @dy
		([@dy.abs, @dx.abs].max).times do
			#x turn
			if (sum_x > 0)
				x -= 1
				sum_x -= 1
				@board[x][y] = "*"
				show_map
				sleep(0.1)
			elsif (sum_x < 0)
				x += 1
				sum_x += 1
				@board[x][y] = "*"
				show_map
				sleep(0.1)
			end
							
			#y turn
			if (sum_y > 0)
				y -= 1
				sum_y -= 1
				@board[x][y] = "*"
				show_map
				sleep(0.1)
			elsif (sum_y < 0)
				y += 1
				sum_y += 1
				@board[x][y] = "*"
				show_map
				sleep(0.1)
			end
		end
		@board = copy_state(state)
	end
	
	def copy_state(board)
		state = init_board(@n, 0)
		for i in 0..n-1
			for j in 0..n-1
				state[i][j] = board[i][j]
			end
		end
		state
	end	
end
