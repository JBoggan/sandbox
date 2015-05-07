class Array
	def a
		File.write("#{self[0]}", self.join("\n"))
		self
	end

	def b
		self.reverse
	end

	def c
		map(&:succ)
	end

end

def parse
	@file = ARGV[0]
	array = open([])
	@args = array
	array.each do |x|
		@args = @args.send(x)
	end
end

def open(array)
	File.read(@file).split("\n")
end

def write(array)
	File.write(array.hash, array.join("\n"))
	array
end


