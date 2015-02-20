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
		@edges = processEdges(adjacency)
		@faces = ["test"]
		@hamiltonianCycles = ["test"]
	end


	def processEdges(adjacency)
		edges = {}
		nodes = {}
		adjacency.each do |e|
			edge = Edge.new(e)
			node1 = Node.new(e[0])
			node2 = Node.new(e[1])
			edges[edge.name] = edge
			nodes[node1.name] = node1
			nodes[node2.name] = node2

			
		end
		return edges
	end



	def addNode
	end

	def addEdge
	end
end

class Node
	def initialize(node_name)
		@name = node_name.to_s
		@adj_nodes = []
		@adj_faces = []
		@adj_edges = []
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