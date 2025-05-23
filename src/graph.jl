"""
    GeckoGraph([nnodes])

Gecko multilevel graph for linear ordering problems.
"""
struct GeckoGraph{PtrType <: Union{Gecko.LibGecko.GraphAllocated, ConstCxxPtr{Gecko.LibGecko.Graph}, CxxPtr{Gecko.LibGecko.Graph}}}
    ptr::PtrType
end

GeckoGraph() = GeckoGraph(LibGecko.Graph())
function GeckoGraph(nnodes::Integer)
    g = GeckoGraph()
    for _ in 1:nnodes
        add_node!(g)
    end
    return g
end

"""
    add_node!(graph::GeckoGraph)

Add a new node to the graph wth index `num_nodes + 1`.
"""
function add_node!(graph::GeckoGraph)
    add_node!(graph, 1.f0)
end
function add_node!(graph::GeckoGraph, weight::Real)
    LibGecko.insert_node(graph.ptr, Float32(weight))
end

"""
    add_directed_edge!(graph::GeckoGraph, i::Integer, j::Integer)

Add a new directed edge to the graph, connecting nodes `i` and `j`.
Insertion must be sorted by the first node index `i`, i.e. if we insert an edge with `i=3`, then we cannot add an edge with `i=2` afterwards.
"""
function add_directed_edge!(graph::GeckoGraph, i::Integer, j::Integer)
    add_directed_edge!(graph, i, j, 1.f0)
end
function add_directed_edge!(graph::GeckoGraph, i::Integer, j::Integer, weight::Real)
    add_directed_edge!(graph, i, j, Float32(weight), 1.f0)
end
function add_directed_edge!(graph::GeckoGraph, i::Integer, j::Integer, weight::Real, bond::Real)
    LibGecko.insert_arc(graph.ptr, i, j, Float32(weight), Float32(bond))
end

"""
    num_nodes(graph::GeckoGraph)

The current number of nodes in the graph.
"""
num_nodes(g::GeckoGraph) = Int(LibGecko.nodes(g.ptr))

"""
    num_nodes(graph::GeckoGraph)

The current number of edges in the graph.
"""
num_edges(g::GeckoGraph) = Int(LibGecko.edges(g.ptr))

"""
    num_nodes(graph::GeckoGraph, i::Integer)

The new index of node `i` after reordering.
"""
function new_index(graph::GeckoGraph, old_index::Integer)
    Int(LibGecko.rank(graph.ptr, old_index)+1)
end
