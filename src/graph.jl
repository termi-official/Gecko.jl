"""
    GeckoGraph([nnodes])

Gecko multilevel graph for linear ordering problems.
"""
struct GeckoGraph
    ptr::CxxPtr{LibGecko.Graph}
end

GeckoGraph() = GeckoGraph(LibGecko.Graph())
function GeckoGraph(nnodes::Integer)
    g = GeckoGraph(LibGecko.Graph())
    for _ in 1:nnodes
        add_node!(g)
    end
end

function add_node!(graph::GeckoGraph)
    LibGecko.insert_node(graph.ptr, 1.f0)
end
function add_node!(graph::GeckoGraph, weight::Real)
    LibGecko.insert_node(graph.ptr, Float32(weight))
end

function add_edge!(graph::GeckoGraph, i::Integer, j::Integer)
    LibGecko.insert_arc(graph, i, j, 1.f0, 1.f0)
end
function add_edge!(graph::GeckoGraph, i::Integer, j::Integer, weight::Real, bond::Real)
    LibGecko.insert_arc(graph, i, j, Float32(weight), Float32(bond))
end

num_nodes(g::GeckoGraph) = LibGecko.nodes(g.ptr)
num_edges(g::GeckoGraph) = LibGecko.edges(g.ptr)
