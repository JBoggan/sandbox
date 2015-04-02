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

	def isBipartite?
		0 == self.faces.select{|f| f.nodes.count != 0 % 2}
	end

	def isThreeConnected?

	end

	def isHamiltonian?

	end

	def isPlanar?

	end

	def isCubic?
		0 == self.nodes.select{|n| n.edges.count != 3}
	end

	def hamiltonianCycles
	end

	def addSquare(edge_one, edge_two)


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


	def initialize(adjacency, face_array)
		@nodes = {}
		@edges = processEdges(adjacency)
		@faces = processFaces(face_array)
		@hamiltonianCycles = {}
	end

	def processFaces(face_array)
		faces = {}
		face_array.each do |f|
			face = Face.new(f)

			edges = orientFaceEdges(f)
			edges.each do |e|
				face.add_adj_edge(e)
				@edges[e].add_face(f)
			end

			nodes = nodesFromFace(f)
			nodes.each do |n|
				face.add_node(n)
				@nodes[n].add_face(f)
			end
			faces[f] = face
		end
		return faces
	end

	def processEdges(adjacency)
		edges = {}
		adjacency.each do |e|
			edge = Edge.new(e)
			edges[edge.name] = edge
			e.each do |n|
				if node?(n)	
					node = self.nodes[n]
					node.add_adj_edge(e)
					adj_edges = node.edges
					adj_edges.map{|x| edge.add_adj_edge(x); edges[x].add_adj_edge(edge.name)}
				else
					node = Node.new(n)
					node.add_adj_edge(e)
					@nodes[node.name] = node
				end
			end
		end
		return edges
	end

	def nodesFromFace(name)
		node_array = name.split("_").slice(0..-2)
	end

	def orientEdge(edge)
		if self.edge?(edge)
			return edge
		elsif self.edge?(reverseEdgeName(edge))
			return reverseEdgeName(edge)
		else
			raise "Not an edge!"
		end
	end

	def orientFaceEdges(name)
		edge_array = name.split("_")
		puts edge_array.to_s
		count = edge_array.count - 1
		unordered_edges = (0..count).map{|t| "#{edge_array[t]}_#{edge_array[t+1]}"}
		unordered_edges.pop
		puts unordered_edges.to_s
		unordered_edges.map{|e| orientEdge(e)}
	end

	def reverseEdgeName(name)
		array = name.split("_")
		return array[1]+"_"+array[0]
	end
end

class Node
	def initialize(node_name)
		@name = node_name.to_s
		@adj_nodes = []
		@adj_faces = []
		@adj_edges = []
	end

	def name
		@name
	end

	def add_adj_edge(edge_array)
		@adj_edges << "#{edge_array[0]}_#{edge_array[1]}"
		other_node = edge_array.select{|e| e != @name}[0]
		self.add_adj_node(other_node)
	end

	def add_adj_node(node_name)
		@adj_nodes << node_name
	end

	def edges
		@adj_edges
	end

	def add_face(face)
		@adj_faces << face
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

	def add_adj_edge(new_edge)
		@adj_edges << new_edge if new_edge != name
	end

	def add_face(face)
		@adj_faces << face
	end

	def name
		@name
	end

	def nodes
		@adj_nodes
	end

end

class Face
	def initialize(name)
		@name = name
		@adj_edges = []
		@radiating_edges = []
		@adj_nodes = []
		@adj_faces = []
	end

	def add_node(node)
		@adj_nodes << node
	end

	def add_adj_edge(edge)
		@adj_edges << edge
	end

	def add_radiating_edge(edge)
		@radiating_edges << edge
	end

	def edges
		@adj_edges
	end

	def radiating_edges
		@radiating_edges
	end

	def nodes
		@adj_nodes
	end

	def adj_faces
		@adj_faces
	end

	def name
		@name
	end
end