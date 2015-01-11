
def step(integer)
	return ((integer * @base)+1) if integer % 2 == 1
	return (integer/2) if integer % 2 == 0
end

def iterate(lowest)
	i = lowest
	tentative_loop = [i]
	while i < @limit && !@found[i]
		@found[i] = true
		i = step(i)
		tentative_loop << i
		if @found[i] && tentative_loop[0] == tentative_loop[-1]
			@loops << {@base => tentative_loop}
			tentative_loop = []
		end
	end

end

def loopIt
	while @lowest < @limit
		iterate(@lowest)
		@lowest += 2
	end
end

def findLoops
	while @base < @max_base
		puts @base
		loopIt
		@base += 2
		@lowest = 1
		@found = {}
	end
end



@loops = []
@base = ARGV[0].to_i
@max_base = ARGV[1].to_i
@limit = ARGV[2].to_i
@found = {}
@lowest = 1
now = Time.now
findLoops
@loops.map{|l| puts l.to_s}
and_then = Time.now
puts "#{(and_then - now)} seconds"
