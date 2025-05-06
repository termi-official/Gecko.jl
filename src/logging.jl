abstract type AbstractGeckoLogger end

# Remove decorations and redirect to user-facing part
function internal_begin_order(data, graph, cost)
    return begin_order(data, GeckoGraph(unsafe_load(graph)), cost)
end
function internal_end_order(data, graph, cost)
    return end_order(data, GeckoGraph(unsafe_load(graph)), cost)
end
function internal_begin_iter(data, graph, iter, maxiter, window)
    return begin_iter(data, GeckoGraph(unsafe_load(graph)), iter, maxiter, window)
end
function internal_end_iter(data, graph, mincost, cost)
    return end_iter(data, GeckoGraph(unsafe_load(graph)), mincost, cost)
end
function internal_begin_phase(data, graph, name)
    return begin_phase(data, GeckoGraph(unsafe_load(graph)), name)
end
function internal_end_phase(data, graph, show)
    return end_phase(data, GeckoGraph(unsafe_load(graph)), show)
end
function internal_quit(data)
    return quit(data)
end

# Interface
function begin_order(data::AbstractGeckoLogger, graph, cost)
    return nothing
end
function end_order(data::AbstractGeckoLogger, graph, cost)
    return nothing
end
function begin_iter(data::AbstractGeckoLogger, graph, iter, maxiter, window)
    return nothing
end
function end_iter(data::AbstractGeckoLogger, graph, mincost, cost)
    return nothing
end
function begin_phase(data::AbstractGeckoLogger, graph, name)
    return nothing
end
function end_phase(data::AbstractGeckoLogger, graph, show)
    return nothing
end
function quit(data::AbstractGeckoLogger)
    return false
end

# Default type used when users do not pass a custom logger
struct DefaultGeckoLogger <: AbstractGeckoLogger
end
