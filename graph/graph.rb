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

	def node?(name)
		self.nodes.include?(name)
	end

	def edge?(name)
		self.edges.include?(name)
	end

	def face?(name)
		self.faces.include?(name)
	end


	def initialize(adjacency)
		@nodes = []
		@edges = processEdges(adjacency)
		@faces = []
		@hamiltonianCycles = []
	end


	def processEdges(adjacency)
		edges = {}
		nodes = {}
		adjacency.each do |e|
			edge = Edge.new(e)
			node1 = Node.new(e[0]) unless node?(e[0])
			node2 = Node.new(e[1]) unless node?(e[1])
			node1.add_adj_edge(edge)
			node2.add_adj_edge(edge)
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

	def add_adj_edge(edge_array)
		@adj_edges << "#{edge_array[0]}_#{edge_array[1]}"
		other_node = edge_array.select{|e| e != @name}[0]
		self.add_adj_node(other_node)
	end

	def add_adj_node(node_name)
		@adj_nodes << node_name
	end

end

class Edge
	def initialize(edge_array)
		@name = "#{edge_array[0]}_#{edge_array[1]}"
		@adj_nodes = [edge_array[0].to_s, edge_array[1].to_s]
		@adj_faces = []
		@adj_edges = []
		#check to see if adj nodes have non-self edges
		#if so add adjacent edge
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
		@adj_edges = []
		@radiating_edges = []
		@adj_nodes = []
		@adj_faces = []

	end
end