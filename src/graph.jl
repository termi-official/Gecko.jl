"""
    GeckoGraph([nnodes])

Gecko multilevel graph for linear ordering problems.
"""
struct GeckoGraph{PtrType <: Union{Gecko.LibGecko.GraphAllocated, ConstCxxPtr{Gecko.LibGecko.Graph}, CxxPtr{Gecko.LibGecko.Graph}}}
    ptr::PtrType
end

GeckoGraph() = GeckoGraph(LibGecko.Graph())
function GeckoGraph(nnodes::Integer)
    g = GeckoGraph(LibGecko.Graph())
    for _ in 1:nnodes
        add_node!(g)
    end
    return g
end

function add_node!(graph::GeckoGraph)
    LibGecko.insert_node(graph.ptr, 1.f0)
end
function add_node!(graph::GeckoGraph, weight::Real)
    LibGecko.insert_node(graph.ptr, Float32(weight))
end

function add_edge!(graph::GeckoGraph, i::Integer, j::Integer)
    LibGecko.insert_arc(graph.ptr, i, j, 1.f0, 1.f0)
end
function add_edge!(graph::GeckoGraph, i::Integer, j::Integer, weight::Real)
    LibGecko.insert_arc(graph.ptr, i, j, Float32(weight), 1.f0)
end
function add_edge!(graph::GeckoGraph, i::Integer, j::Integer, weight::Real, bond::Real)
    LibGecko.insert_arc(graph.ptr, i, j, Float32(weight), Float32(bond))
end

num_nodes(g::GeckoGraph) = Int(LibGecko.nodes(g.ptr))
num_edges(g::GeckoGraph) = Int(LibGecko.edges(g.ptr))

function new_index(graph::GeckoGraph, old_index::Integer)
    Int(LibGecko.rank(graph.ptr, old_index)+1)
end
