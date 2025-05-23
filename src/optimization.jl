# We provide these directly to the user
import .LibGecko: FunctionalQuasiconvex, FunctionalHarmonic, FunctionalGeometric,
    FunctionalSMR, FunctionalArithmetic, FunctionalRMS, FunctionalMaximum

"""
    GraphOrderingParameters(;kwargs)

kwargs can be one of the following:
* Optimization functional `functional = FunctionalGeometric()`
* Number of V cycles `iterations = 9`
* Initial window size `window = 5`
* Number of iterations between window increments `period = 2`
* Random number seed `seed = 1`

For more details on the parameters please consult the Gecko paper.
"""
Base.@kwdef struct GraphOrderingParameters{FunType}
    functional::FunType = FunctionalGeometric()
    iterations::Integer = 9 # number of V cycles
    window::Integer     = 5 # initial window size
    period::Integer     = 2 # iterations between window increment
    seed::Integer       = 1 # random number seed
end

"""
    order!(graph::GeckoGraph [, params::GraphOrderingParameters])

Reorder the graph, using the parameter set in `GraphOrderingParameters`.
"""
function order!(graph::GeckoGraph, params::GraphOrderingParameters = GraphOrderingParameters(), logger::AbstractGeckoLogger = DefaultGeckoLogger())
    # Unpack parameters
    (; functional, iterations, window, period, seed) = params
    # Generate logger wrapper
    progress_wrapper = LibGecko.JuliaProgressWrapper(logger, internal_begin_order, internal_end_order, internal_begin_iter, internal_end_iter, internal_begin_phase, internal_end_phase, internal_quit)
    # Actual call for ordering algorithm
    GC.@preserve logger progress_wrapper graph functional LibGecko.order(graph.ptr, Gecko.CxxPtr(functional), iterations, window, period, seed, Gecko.CxxPtr(progress_wrapper));
    return nothing
end

"""
    cost(graph::GeckoGraph)

Return the current cost of the ordered graph.
"""
function cost(graph::GeckoGraph)
    LibGecko.cost(graph.ptr)
end
