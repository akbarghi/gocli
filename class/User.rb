#bin/class/User.rb

class User
	
	attr_accessor :name
	attr_accessor :x
	attr_accessor :y
	attr_accessor :log
	@@log_id = 0

	def initialize (name, x, y)
		@name = name
		@x = x
		@y = y
		@log = Hash.new(0)
		load_log
	end
	
	#saving an order to log
	def save_log (init_x, init_y, dest_x, dest_y, steps, price)
		@@log_id += 1
		@log[@@log_id] = [init_x, init_y, dest_x, dest_y, steps, price]
	end
	
	#saving order history to file
	def save_file
		aFile = File.new("user_log.txt", "w")
		if aFile
			for i in 1..@@log_id do
				arr = @log[i]
				arr.each do |data|
					aFile.write(data)
				end
			end
		end
	end
	
	#loading order history from external file
	def load_log
		Dir.chdir("C:/Users/user/Desktop/gocli/class")
		arr = IO.readlines("user_log.txt")
		i = 1
		(arr.length/6).times do
			@log[i] = [arr[(i-1)*6], arr[(i-1)*6+1], arr[(i-1)*6+2], arr[(i-1)*6+3], arr[(i-1)*6+4], arr[(i-1)*6+5]]
			i += 1
		end
	end
	
	#showing order history from hash array
	def show_log
		puts ""
		puts "User order history"
		puts "User name: #{name}"
		for i in 1..@@log_id do
			arr = @log[i]
			puts "log_id      : #{i}"
			puts "pick up     : #{arr[0]+1}, #{arr[1]+1}"
			puts "destination : #{arr[2]+1}, #{arr[3]+1}"
			puts "total steps : #{arr[4]}"
			puts "total price : #{arr[5]}"
			puts ""
		end
	end
end

