class BarnetteGraph
=begin
Notes:

Faces must be defined by the user since this is computationally very difficult to work out.
As a convention that will simplify merging and division, all faces are labeled in clockwise orientation

=end



	def nodes 
	 	@nodes
	end

	def edges
		@edges
	end

	def faces
		@faces
	end

	def hcycles
		@hcycles
	end

	def isBipartite?
		0 == self.faces.select{|f| f.nodes.count != 0 % 2}
	end

	def isThreeConnected?

	end

	def incrementNode
		@max_node.next!
	end

	def isHamiltonian?

	end

	def isPlanar?

	end

	def isCubic?
		0 == self.nodes.select{|n| n.edges.count != 3}
	end

	def render
		#for d3.js visualization
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

	def hcycle?(name)
		self.hcycles.include?(name)
	end



	def initialize(adjacency, face_array, hcycles = nil)
		@max_node = ""
		@nodes = {}
		@edges = processEdges(adjacency)
		@faces = processFaces(face_array)
		@hcycles = processHcycles(hcycles)
	end

	def processHcycles(cycle_array)
		hcycles = {}
		cycle_array.each do |h|
			hcycle = Hcycle.new(h)
			
			edges = orientCycleEdges(h)
			edges.each do |e|
				edge = self.edges[e]
				hcycle.add_edge(e)
				@edges[e].add_hcycle(h)
			end
			hcycles[h] = hcycle
		end
		return hcycles
	end

	def processFaces(face_array)
		faces = {}
		face_array.each do |f|
			face = Face.new(f)

			edges = orientCycleEdges(f)
			edges.each do |e|
				edge = self.edges[e]
				if !edge.faces.empty?
					other_face = faces[edge.faces[0]]
					face.add_adj_face(other_face.name)
					other_face.add_adj_face(face.name)
					faces[other_face.name] = other_face
				end
				face.add_adj_edge(e)
				@edges[e].add_face(f)

			end

			nodes = nodesFromCycle(f)
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
					@max_node = n if n.length > @max_node.length || n > @max_node
					node = Node.new(n)
					node.add_adj_edge(e)
					@nodes[node.name] = node
				end
			end
		end
		return edges
	end

	def nodesFromCycle(name)
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

	def orientCycleEdges(name)
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

	def algorithmUp(edge_array)
		#edge_array.map{|e| segmentEdge(e)}
		#connectSegments
	end

	def algorithmDown(edge_array)
		return nil if edge_array.count != 2
		edge_array.map{|e| dropEdge(e)}
		#desegment
		#
	end

	def dropEdge(edge)
		edge.split('_').map{|n| self.nodes[n].drop_edge(edge)}
		self.edges[edge].adj_edges.map{|e| self.edges[e].drop_edge(edge)}
		#mergeFaces(edge)
		#transformHamiltonian(edge)
	end

	def mergeFaces(edge)
		faces = @edges[edge].faces
		face1 = faces[0]
		face2 = faces[1]
		
		sum_edges = face1.edges + face2.edges
		sum_rad_edges = face1.radiating_edges + face2.radiating_edges
		sum_nodes = face1.nodes + face2.nodes
		sum_faces = face1.adj_faces + face2.adj_faces

		sum_rad_edges.select!{|e| !face1.edges.include?(e) && !face2.edges.include?(e)}
		sum_nodes.uniq!
		sum_faces.select!{|f| face1.name != f && face2.name != f}.uniq!

		sum_name = mergeFaceName(edge)



	end

	def mergeFaceName(edge)
		faces = @edges[edge].faces
		face1 = faces[0]
		face2 = faces[1]

		partial_name1 = face1.name.split(edge)
		partial_name2 = face2.name.split(edge)
	end

	def segmentEdge(edge)

	end

	def desegment

	end

	def connectSegments

	end

	def newAlgoEdges

	end

	def newAlgoFaces

	end

	def findSquare
		self.faces.keys.each do |f|
			return f if f.length == 9
		end
	end

	def self.cube_edges
		[["a","b"],
		["b","c"],
		["c","d"],
		["d","a"],
		["e","f"],
		["f","g"],
		["g","h"],
		["h","e"],
		["a","e"],
		["b","f"],
		["c","g"],
		["d","h"]
		]
	end

	def self.cube_faces
		['a_b_c_d_a', 'e_f_g_h_e', 'a_b_f_e_a', 'b_c_g_f_b', 'c_d_h_g_c', 'a_e_h_d_a']
	end

	def self.cube_hcycles
		['a_b_c_d_h_g_f_e_a','b_c_d_a_e_h_g_f_b', 'c_d_a_b_f_e_h_g_c', 'd_a_b_c_g_f_e_h_d', 'a_e_f_b_c_g_h_d_a', 'b_f_g_c_d_h_e_a_b']
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

	def drop_edge(old_edge)
		@adj_edges.delete(old_edge)
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
		@hcycles = []
		#check to see if adj nodes have non-self edges
		#if so add adjacent edge
	end

	def add_hcycle(hcycle)
		@hcycles << hcycle
	end

	def add_adj_edge(new_edge)
		@adj_edges << new_edge if new_edge != name
	end

	def drop_edge(old_edge)
		@adj_edges.delete(old_edge)
	end

	def add_face(face)
		@adj_faces << face
	end

	def hcycles
		@hcycles
	end

	def name
		@name
	end

	def adj_edges
		@adj_edges
	end

	def nodes
		@adj_nodes
	end

	def faces
		@adj_faces
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

	def add_adj_face(face)
		@adj_faces << face
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

class Hcycle
	def initialize(name)
		@name = name
		@edges = []
	end

	def add_edge(edge)
		@edges << edge
	end

	def edges
		@edges
	end

end

