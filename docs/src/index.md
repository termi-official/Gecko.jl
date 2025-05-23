```@meta
CurrentModule = Gecko
```

# Gecko.jl

Documentation for [Gecko.jl](https://github.com/termi-official/Gecko.jl), a Julia wrapper for the C++ graph ordering library [Gecko](https://github.com/LLNL/gecko).

## How to use the library

```julia
using Gecko

# Graph with 4 nodes
g = GeckoGraph(4)

# Connect to quadrilateral. Insertion must be sorted by the first node index.
add_directed_edge!(g, 1, 2)
add_directed_edge!(g, 1, 3)
add_directed_edge!(g, 2, 1)
add_directed_edge!(g, 2, 4)
add_directed_edge!(g, 3, 1)
add_directed_edge!(g, 3, 4)
add_directed_edge!(g, 4, 2)
add_directed_edge!(g, 4, 3)

# Optimize ordering
order!(g)

# We can now access the optimized ordering via
new_index(g, 2 #= old_node_index =#)
```

## Citing Gecko

If you use gecko for scholarly research, please cite the following paper:

* Peter Lindstrom
  [The Minimum Edge Product Linear Ordering Problem](https://www.researchgate.net/publication/259383744_The_Minimum_Edge_Product_Linear_Ordering_Problem)
  LLNL technical report LLNL-TR-496076, August 26, 2011.

## Public API Reference

```@docs
GeckoGraph
add_node!
add_directed_edge!
cost
num_nodes
num_edges
order!
new_index
GraphOrderingParameters
```

The following functionals are provided.

```
FunctionalQuasiconvex
FunctionalHarmonic
FunctionalGeometric
FunctionalSMR
FunctionalArithmetic
FunctionalRMS
FunctionalMaximum
```
