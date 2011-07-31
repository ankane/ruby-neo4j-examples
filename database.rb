require "bundler/setup"
require "neography"
require "cgi"

class Database
  def neo
    server = ENV["NEO4J_SERVER"]
    @neo ||= Neography::Rest.new
  end

  def find(type, name)           # Line 2
    hit = neo.get_index type, "name", CGI.escape(name)
    # get_index will return nil or an array of hashes
    hit && hit.first
  end

  def find_or_create(type, name) # Line 3
    # look for an actor or movie in the index first
    node = find type, name
    return node if node

    node = neo.create_node "name" => name
    neo.add_to_index type, "name", CGI.escape(name), node  # Line 4
    node
  end

  def acted_in(actor, movie)
    neo.create_relationship "acting", actor, movie  # Line 5
  end

  def shortest_path(from, to)
    from_node = find "actor", from
    to_node   = find "actor", to

    return [] unless from_node && to_node

    acting  = {"type" => "acting"}
    degrees = 6
    depth   = degrees * 2
    nodes   = neo.get_path(from_node, to_node, acting, depth)["nodes"] || []

    nodes.map do |node|
      id = node.split("/").last
      neo.get_node(id)["data"]["name"]
    end
  end
end

# @neo = Neography::Rest.new
#
# node1 = @neo.get_node(1)
# node2 = @neo.create_node("age" => rand(100))
# @neo.create_relationship("friends", node1, node2)
#
# @neo.create_node_index("ft_users", "fulltext")
# @neo.add_node_to_index("ft_users", "name", "Max Payne", node1)
# puts (@neo.find_node_index("ft_users", "name", "Max") || []).size
#
# @neo.get_node_relationships(node1, "out", "friends").each do |node|
#   puts @neo.get_node(node["end"])["data"].inspect
#   puts
# end
#
# puts @neo.get_path(node1, node2, {"type" => "friends"}).inspect
