# We provide these directly to the user
import .LibGecko: FunctionalQuasiconvex, FunctionalHarmonic, FunctionalGeometric,
    FunctionalSMR, FunctionalArithmetic, FunctionalRMS, FunctionalMaximum

Base.@kwdef struct GraphOrderingParameters{FunType}
    functional::FunType = FunctionalGeometric()
    iterations::Integer = 9 # number of V cycles
    window::Integer     = 5 # initial window size
    period::Integer     = 2 # iterations between window increment
    seed::Integer       = 1 # random number seed
end

function order!(graph::GeckoGraph, params::GraphOrderingParameters = GraphOrderingParameters(), logger::AbstractGeckoLogger = DefaultGeckoLogger())
    # Unpack parameters
    (; functional, iterations, window, period, seed) = params
    # Generate logger wrapper
    progress_wrapper = LibGecko.JuliaProgressWrapper(logger, internal_begin_order, internal_end_order, internal_begin_iter, internal_end_iter, internal_begin_phase, internal_end_phase, internal_quit)
    # Actual call for ordering algorithm
    GC.@preserve logger progress_wrapper graph functional LibGecko.order(graph.ptr, Gecko.CxxPtr(functional), iterations, window, period, seed, Gecko.CxxPtr(progress_wrapper));
    return nothing
end

function cost(graph::GeckoGraph)
    LibGecko.cost(graph.ptr)
end
