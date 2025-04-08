using Gecko
using Test

function grid_test(
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
    graph = Gecko.Graph()

    # insert nodes
    for i in 1:nodes
        Gecko.insert_node(graph, 1.f0)
        x = floor(Int, (i - 1) % size)
        y = floor(Int, (i - 1) / size)

        if (x > 0.)
            Gecko.insert_arc(graph, i, i - 1, 1.f0, 1.f9)
        end
        if (x < size - 1.)
            Gecko.insert_arc(graph, i, i + 1, 1.f0, 1.f9)
        end
        if (y > 0.)
            Gecko.insert_arc(graph, i, i - size, 1.f0, 1.f9)
        end
        if (y < size - 1.)
            Gecko.insert_arc(graph, i, i + size, 1.f0, 1.f9)
        end
    end
    @test Gecko.nodes(graph) == nodes
    @test Gecko.edges(graph) == edges

    # order graph
    progress = Gecko.Progress()
    functional = Gecko.FunctionalGeometric()
    Gecko.order(graph, Gecko.CxxPtr(functional), iterations, window, period, seed, Gecko.CxxPtr(progress));
    cost = Gecko.cost(graph);

    epsilon = 1e-2;
    @test cost ≥ (1.0 + epsilon) * mincost
end

@testset "Gecko.jl" begin
    maxdims = 5  # number of hypercube dimensions

    @testset "2D grid" begin
        for size in 1:6
            grid_test(size)
        end
    end
end
