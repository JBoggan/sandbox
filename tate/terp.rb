class Array
	def a
		File.write("#{self.hash}", self.join("\n"))
		self
	end

	def b
		self.reverse
	end

	def c
		map(&:succ)
	end

	def d
		self
	end

	def e
		map(&:chop)
	end

	def f

	end

	def g

	end

	def h

	end

end

def parse(filename)
	@file = filename   #ARGV[0]
	array = open([])
	@args = array
	array.each do |x|
		x.split("").each_with_index do |char,i|
			@position = i
			@args = @args.send(char)
		end
	end
end

def open(array)
	File.read(@file).split("\n")
end

def write(array)
	File.write(array.hash, array.join("\n"))
	array
end


