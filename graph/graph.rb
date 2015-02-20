class BarnetteGraph
	def nodes 
	 	@nodes
	end

	def edges
		@edges
	end

	def faces
		@faces
	end

	def hamiltonianCycles
	end


	def initialize(adjacency)
		@nodes = ["test"]
		@edges = generateEdges(adjacency)
		@faces = ["test"]
		@hamiltonianCycles = ["test"]
	end


	def generateEdges(adjacency)
		edges = {}
		adjacency.each do |e|
			edge = Edge.new(e)
			edges[edge.name] = edge
		end
		return edges
	end



	def addNode
	end

	def addEdge
	end
end

class Node
	def initialize
		@name = "this"
	end
end

class Edge
	def initialize(edge_array)
		@name = "#{edge_array[0]}_#{edge_array[1]}"
		@adj_nodes = [edge_array[0].to_s, edge_array[1].to_s]
		@adj_faces = []
		@adj_edges = []
	end

	def name
		@name
	end

	def nodes
		@adj_nodes
	end

end

class Face
	def initialize

	end
end