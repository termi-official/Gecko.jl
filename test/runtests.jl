using Gecko
using Test

mutable struct TestProgressCallbacks
    bo_called::Bool
    eo_called::Bool
    bi_called::Bool
    ei_called::Bool
    bp_called::Bool
    ep_called::Bool
    q_called::Bool
end
TestProgressCallbacks() = TestProgressCallbacks(false, false, false, false, false, false, false)

function Gecko.begin_order(data::TestProgressCallbacks, graph, cost)
    data.bo_called = true
    return nothing
end
function Gecko.end_order(data::TestProgressCallbacks, graph, cost)
    data.eo_called = true
    return nothing
end
function Gecko.begin_iter(data::TestProgressCallbacks, graph, iter, maxiter, window)
    data.bi_called = true
    return nothing
end
function Gecko.end_iter(data::TestProgressCallbacks, graph, mincost, cost)
    data.ei_called = true
    return nothing
end
function Gecko.begin_phase(data::TestProgressCallbacks, graph, name)
    data.bp_called = true
    return nothing
end
function Gecko.end_phase(data::TestProgressCallbacks, graph, show)
    data.ep_called = true
    return nothing
end
function Gecko.quit(data::TestProgressCallbacks)
    data.q_called = true
    return false
end

function grid_test_internal(
    size,           # number of nodes along each dimension
    iterations = 9, # number of V cycles
    window = 5,     # initial window size
    period = 2,     # iterations between window increment
    seed = 1        # random number seed
)
    # known minimal edge products
    minproduct = [0., 1., 3., 225., 688905., 145904338125., 984582541613671875. ]
    @test size ≤ sizeof(minproduct) / sizeof(minproduct[1])

    nodes = size * size           # grid node count
    edges = 2 * size * (size - 1) # grid edge count

    mincost = edges > 0 ? (exp(log(minproduct[size]) / edges)) : 0.0

    # construct graph
    graph = Gecko.LibGecko.Graph()

    # insert nodes
    for i in 1:nodes
        Gecko.LibGecko.insert_node(graph, 1.f0)
        x = floor(Int, (i - 1) % size)
        y = floor(Int, (i - 1) / size)

        if (x > 0.)
            Gecko.LibGecko.insert_arc(graph, i, i - 1, 1.f0, 1.f0)
        end
        if (x < size - 1.)
            Gecko.LibGecko.insert_arc(graph, i, i + 1, 1.f0, 1.f0)
        end
        if (y > 0.)
            Gecko.LibGecko.insert_arc(graph, i, i - size, 1.f0, 1.f0)
        end
        if (y < size - 1.)
            Gecko.LibGecko.insert_arc(graph, i, i + size, 1.f0, 1.f0)
        end
    end
    @test Gecko.LibGecko.nodes(graph) == nodes
    @test Gecko.LibGecko.edges(graph) == edges

    # order graph
    state_capsule = TestProgressCallbacks()
    progress = Gecko.LibGecko.JuliaProgressWrapper(state_capsule, Gecko.begin_order, Gecko.end_order, Gecko.begin_iter, Gecko.end_iter, Gecko.begin_phase, Gecko.end_phase, Gecko.quit)
    functional = Gecko.LibGecko.FunctionalGeometric()
    Gecko.LibGecko.order(graph, Gecko.CxxPtr(functional), iterations, window, period, seed, Gecko.CxxPtr(progress));
    cost = Gecko.LibGecko.cost(graph)

    @test state_capsule.bo_called == true
    @test state_capsule.eo_called == true
    if size > 1
        @test state_capsule.bi_called == true
        @test state_capsule.ei_called == true
        @test state_capsule.bp_called == true
        @test state_capsule.ep_called == true
        @test state_capsule.q_called  == true
    else
        @test state_capsule.bi_called == false
        @test state_capsule.ei_called == false
        @test state_capsule.bp_called == false
        @test state_capsule.ep_called == false
        @test state_capsule.q_called  == false
    end

    epsilon = 1e-2;
    @test cost ≥ (1.0 + epsilon) * mincost
end

@testset "Gecko wrapper internals" begin
    maxdims = 5  # number of hypercube dimensions

    @testset "2D grid" begin
        for size in 1:6
            grid_test_internal(size)
        end
    end
end

function grid_test_api(
    size,           # number of nodes along each dimension
)
    # known minimal edge products
    minproduct = [0., 1., 3., 225., 688905., 145904338125., 984582541613671875. ]
    @test size ≤ sizeof(minproduct) / sizeof(minproduct[1])

    nodes = size * size           # grid node count
    edges = 2 * size * (size - 1) # grid edge count

    mincost = edges > 0 ? (exp(log(minproduct[size]) / edges)) : 0.0

    # construct graph
    graph = GeckoGraph(nodes)

    # insert nodes
    for i in 1:nodes
        x = floor(Int, (i - 1) % size)
        y = floor(Int, (i - 1) / size)

        if (x > 0.)
            add_edge!(graph, i, i - 1)
        end
        if (x < size - 1.)
            add_edge!(graph, i, i + 1)
        end
        if (y > 0.)
            add_edge!(graph, i, i - size)
        end
        if (y < size - 1.)
            add_edge!(graph, i, i + size)
        end
    end
    @test num_nodes(graph) == nodes
    @test num_edges(graph) == edges

    # order graph
    logger = TestProgressCallbacks()
    functional = FunctionalGeometric()
    Gecko.order!(graph, OrderingParameters(), logger);
    cost = Gecko.cost(graph)

    @test logger.bo_called == true
    @test logger.eo_called == true
    if size > 1
        @test logger.bi_called == true
        @test logger.ei_called == true
        @test logger.bp_called == true
        @test logger.ep_called == true
        @test logger.q_called  == true
    else
        @test logger.bi_called == false
        @test logger.ei_called == false
        @test logger.bp_called == false
        @test logger.ep_called == false
        @test logger.q_called  == false
    end

    epsilon = 1e-2;
    @test cost ≥ (1.0 + epsilon) * mincost
end

@testset "Gecko user api" begin
    maxdims = 5  # number of hypercube dimensions

    @testset "2D grid" begin
        for size in 1:6
            grid_test_internal(size)
        end
    end
end
