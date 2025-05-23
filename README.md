# Gecko

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://termi-official.github.io/Gecko.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://termi-official.github.io/Gecko.jl/dev/)
[![Build Status](https://github.com/termi-official/Gecko.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/termi-official/Gecko.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/termi-official/Gecko.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/termi-official/Gecko.jl)

Julia wrapper for the C++ graph ordering library [Gecko](https://github.com/LLNL/gecko).
Credits go to the original author [Peter Lindstrom](https://people.llnl.gov/pl) at Lawrence Livermore National Laboratory.

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
------------

If you use gecko for scholarly research, please cite the following paper:

* Peter Lindstrom
  [The Minimum Edge Product Linear Ordering Problem](https://www.researchgate.net/publication/259383744_The_Minimum_Edge_Product_Linear_Ordering_Problem)
  LLNL technical report LLNL-TR-496076, August 26, 2011.

