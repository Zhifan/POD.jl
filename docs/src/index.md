# POD.jl Documentation

## Overview

[POD.jl](https://github.com/lanl-ansi/POD.jl) relies on piecewise convex relaxations to solve mixed-integer nonlinear programs (MINLP). The main algorithmic idea is to strengthen the convex relaxation by systematically partitioning variable domain and use the relaxation to guide the local search. Instead of equally partitioning the domains of variables appearing in multi-linear terms (predominantly common in the literature), we construct sparser partitions yet tighter relaxations by adaptively partitioning the variable domains in regions of interest. This approach decouples the number of partitions from the size of the variable domains, leads to a significant reduction in computation time, and limits the number of binary variables that are introduced by the partitioning. To describe the piecewise function, POD.jl deploy a locally idea convexification formulation with performance guarantee in practical computation. Furthermore, POD.jl tries constraint programing techniques to contract the variable bounds for further performance improvements. POD.jl is specifically designed to fit Julia [JuMP](https://github.com/JuliaOpt/JuMP.jl) model. It performs expression-based analyze to structurally understand the problem and apply the algorithm smartly. The code is design to embrace the open-source community with API-based inputs, which is used to handle problems of users' interests with user's idea bridged with POD's algorithm.

## Documentation Structure
We kindly ask the user to walk through the "Getting Started" section for a brief, basic usage guidance on [Installation](@ref), [Usage](@ref), and [Choosing Sub-Solvers](@ref). The list of [Parameters](@ref) is documented and it can be used to control the solver. For more advanced control of the solver, user should consult with the develop team at the moment.