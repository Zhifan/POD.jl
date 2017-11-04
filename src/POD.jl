module POD

using JuMP
using MathProgBase
using Compat

# Engine for High-level Algorithmic Control and User-interface
include("algorithm.jl")
include("solver.jl")

# Engine for expression handling
include("nlexpr.jl")
include("operators.jl")

# Main Algorithmic Process
include("presolve.jl")
include("amp.jl")
include("heu.jl")

# Convexification method
include("tmc.jl")
include("multi.jl")

# Model Manipulation and utilities
include("bounds.jl")
include("utility.jl")

# Othes
include("log.jl")

end # module
