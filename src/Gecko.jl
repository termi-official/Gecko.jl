module Gecko

using CxxWrap

# This submodule contains the CxxWrap stuff
module LibGecko
    using CxxWrap
    using gecko_jll

    @wrapmodule(gecko_jll.get_libgeckowrapper_path)

    function __init__()
        @initcxx
    end
end

include("logging.jl")
include("graph.jl")
include("optimization.jl")

# User-facing API
export GeckoGraph, add_node!, add_edge!, order!, cost, num_nodes, num_edges

end
