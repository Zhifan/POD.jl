using JuMP

type PODNonlinearModel <: MathProgBase.AbstractNonlinearModel

    # external developer parameters for testing and debugging
    dev_debug::Bool                                             # Turn on the debug mode
    dev_test::Bool                                              # Turn on for testing new code with
    colorful_pod::Any                                           # Turn on for a color solver
    mip_license::Any                                            # Granted solver identifier

    # Temporary internal place-holder for testing differnt things
    dump::Any

    # basic solver parameters
    log_level::Int                                              # Verbosity flag: 0 for quiet, 1 for basic solve info, 2 for iteration info
    timeout::Float64                                            # Time limit for algorithm (in seconds)
    maxiter::Int                                                # Target Maximum Iterations
    rel_gap::Float64                                            # Relative optimality gap termination condition
    abs_gap::Float64                                            # Absolute optimality gap termination condition
    tol::Float64                                                # Numerical tol used in the algorithmic process
    tol_fea::Float64                                            # Feasibility tolerance used in POD

    # convexification method tuning
    recognize_convex::Bool                                      # recognize convex expressions in parsing objective functions and constraints
    bilinear_mccormick::Bool                                    # disable Tightening McCormick method used for for convexirfy nonlinear terms
    bilinear_convexhull::Bool                                   # convexify bilinear terms using convex hull representation
    monomial_convexhull::Bool                                   # convexify monomial terms using convex hull representation

    # expression-based user-inputs
    method_convexification::Array{Function}                     # Array of functions that user wich to use to convexify some specific non-linear temrs :: no over-ride privilege
    term_patterns::Array{Function}                              # Array of functions that user wish to use to parse/recognize nonlinear terms in constraint expression
    constr_patterns::Array{Function}                            # Array of functions that user wish to use to parse/recognize structural constraint from expression

    # parameters used in partitioning algorithm
    discretization_ratio::Any                                   # Discretization ratio parameter (use a fixed value for now, later switch to a function)
    discretization_uniform_rate::Int                            # Discretization rate parameter when using uniform partitions
    discretization_var_pick_algo::Any                           # Algorithm for choosing the variables to discretize: 1 for minimum vertex cover, 0 for all variables
    discretization_add_partition_method::Any                    # Additional methods to add discretization
    discretization_abs_width_tol::Float64                       # absolute tolerance used when setting up partition/discretizations
    discretization_rel_width_tol::Float64                       # relative width tolerance when setting up partition/discretizations
    discretization_consecutive_forbid::Int                      # forbit bounding model to add partitions on the same spot when # steps of previous indicate the same bouding solution, done in a distributed way (per variable)

    # parameters used to control convhull formulation
    convexhull_sweep_limit::Int                                 # Contoller for formulation density
    convhull_formulation_sos2::Bool                                   # Convex hull formulation with SOS-2 representation (numerically best so far)
    convhull_formulation_sos2aux::Bool                                # Speical SOS-2 formulation that utilized auxilary variables
    convhull_formulation_facet::Bool                                  # Use the facets contraint generated from PORTA
    convhull_formulation_minib::Bool                                  # Use minimum formulation with boundary cuts

    # parameters related to presolving
    presolve_track_time::Bool                                   # Account presolve time for total time usage
    presolve_bound_tightening::Bool                             # Perform bound tightening procedure before main algorithm
    presolve_maxiter::Int                                       # Maximum iteration allowed to perform presolve (vague in parallel mode)
    presolve_bt_width_tol::Float64                              # Numerical tol bound-tightening width
    presolve_bt_output_tol::Float64                             # Variable bounds truncation tol
    presolve_bound_tightening_algo::Any                         # Method used for bound tightening procedures, can either be index of default methods or functional inputs
    presolve_mip_relaxation::Bool                               # Relax the MIP solved in built-in relaxation scheme for time performance
    presolve_mip_timelimit::Float64                             # Regulate the time limit for a single MIP solved in built-in bound tighening algorithm

    # Domain Reduction
    bound_basic_propagation::Bool                               # Conduct basic bound propagation

    # additional parameters
    user_parameters::Dict                                       # Additional parameters used for user-defined functional inputs

    # add all the solver options
    nlp_local_solver::MathProgBase.AbstractMathProgSolver       # Local continuous NLP solver for solving NLPs at each iteration
    minlp_local_solver::MathProgBase.AbstractMathProgSolver     # Local MINLP solver for solving MINLPs at each iteration
    mip_solver::MathProgBase.AbstractMathProgSolver             # MILP solver for successive lower bound solves

    # identifiers of the sub-solvers
    nlp_local_solver_identifier::AbstractString
    minlp_local_solver_identifier::AbstractString
    mip_solver_identifier::AbstractString

    # initial data provided by user
    num_var_orig::Int                                           # Initial number of variables
    num_cont_var_orig::Int                                      # Initial number of continuous variables
    num_int_var_orig::Int                                       # Initial number of binary/integer variables
    num_constr_orig::Int                                        # Initial number of constraints
    num_lconstr_orig::Int                                       # Initial number of linear constraints
    num_nlconstr_orig::Int                                      # Initial number of non-linear constraints
    var_type_orig::Vector{Symbol}                               # Variable type vector on original variables (only :Bin, :Cont, :Int)
    var_start_orig::Vector{Float64}                             # Variable warm start vector on original variables
    constr_type_orig::Vector{Symbol}                            # Constraint type vector on original variables (only :(==), :(>=), :(<=))
    constr_expr_orig::Vector{Expr}                              # Constraint expressions
    obj_expr_orig::Expr                                         # Objective expression

    # extra initial data that is useful for non-linear local continuous solves
    l_var_orig::Vector{Float64}                                 # Variable lower bounds
    u_var_orig::Vector{Float64}                                 # Variable upper bounds
    l_constr_orig::Vector{Float64}                              # Constraint lower bounds
    u_constr_orig::Vector{Float64}                              # Constraint upper bounds
    sense_orig::Symbol                                          # Problem type (:Min, :Max)
    d_orig::JuMP.NLPEvaluator                                   # Instance of AbstractNLPEvaluator for evaluating gradient, Hessian-vector products, and Hessians of the Lagrangian

    # additional initial data that may be useful later on - non populated for now
    A_orig                                                      # Linear constraint matrix
    A_l_orig                                                    # Linear constraint matrix LHS
    A_u_orig                                                    # Linear constraint matrix RHS
    is_obj_linear_orig::Bool                                    # Bool variable for type of objective
    c_orig::Vector{Float64}                                     # Coefficient vector for linear objective
    num_lconstr_updated::Int                                    # Updated number of linear constraints - includes linear constraints added via @NLconstraint macro
    num_nlconstr_updated::Int                                   # Updated number of non-linear constraints
    indexes_lconstr_updated::Vector{Int}                        # Indexes of updated linear constraints

    # local solution model extra data for each iteration
    l_var::Vector{Float64}                                      # Updated variable lower bounds for local solve
    u_var::Vector{Float64}                                      # Updated variable upper bounds for local solve
    var_type::Vector{Symbol}                                    # Updated variable type for local solve

    # mixed-integer convex program bounding model
    model_mip::JuMP.Model                                       # JuMP convex MIP model for bounding
    x_int::Vector{JuMP.Variable}                                # JuMP vector of integer variables (:Int, :Bin)
    x_cont::Vector{JuMP.Variable}                               # JuMP vector of continuous variables
    num_var_linear_lifted_mip::Int                             # Number of linear lifting variables required.
    num_var_nonlinear_lifted_mip::Int                                     # Number of lifted variables
    num_var_discretization_mip::Int                             # Number of variables on which discretization is performed
    num_constr_convex::Int                                      # Number of structural constraints
    linear_terms::Dict{Any, Any}                                # Dictionary containing details of lifted linear terms
    nonlinear_terms::Dict{Any,Any}                              # Dictionary containing details of lifted non-linear terms
    nonlinear_constrs::Dict{Any,Any}                            # Dictionary containing details of special constraints
    all_nonlinear_vars::Vector{Int}                             # A vector of all original variable indices that is involved in the nonlinear terms
    structural_obj::Symbol                                      # A symbolic indicator of the expression type of objective function
    structural_constr::Vector{Symbol}                           # A vector indicate whether a constraint is with sepcial structure
    bounding_obj_expr_mip::Expr                                 # Lifted objective expression; if linear, same as obj_expr_orig
    bounding_constr_expr_mip::Vector{Expr}                      # Lifted constraints; if linear, same as corresponding constr_expr_orig
    bounding_obj_mip::Dict{Any, Any}                            # Lifted objective expression in affine form
    bounding_constr_mip::Vector{Dict{Any, Any}}                 # Lifted constraint expressions in affine form
    discretization::Dict{Any,Any}                               # Discretization points keyed by the variables
    var_discretization_mip::Vector{Any}                         # Variables on which discretization is performed
    sol_incumb_lb::Vector{Float64}                              # Incumbent lower bounding solution
    l_var_tight::Vector{Float64}                                # Tightened variable upper bounds
    u_var_tight::Vector{Float64}                                # Tightened variable Lower Bounds

    # Solution and bound information
    best_bound::Float64                                         # Best bound from MIP
    best_obj::Float64                                           # Best feasible objective value
    best_sol::Vector{Float64}                                   # Best feasible solution
    best_bound_sol::Vector{Float64}                             # Best bound solution
    best_rel_gap::Float64                                       # Relative optimality gap = |best_bound - best_obj|/|best_obj|
    bound_sol_history::Vector{Vector{Float64}}                  # History of bounding solutions limited by parameter discretization_consecutive_forbid
    final_soln::Vector{Float64}                                 # Final solution

    # Logging information and status
    logs::Dict{Symbol,Any}                                      # Logging information
    status::Dict{Symbol,Symbol}                                 # Detailed status of each different phases in algorithm
    pod_status::Symbol                                          # Current POD status

    # constructor
    function PODNonlinearModel(dev_debug, dev_test,colorful_pod,
                                log_level, timeout, maxiter, rel_gap, tol, tol_fea,
                                nlp_local_solver,
                                minlp_local_solver,
                                mip_solver,
                                recognize_convex,
                                bilinear_mccormick,
                                bilinear_convexhull,
                                monomial_convexhull,
                                method_convexification,
                                term_patterns,
                                constr_patterns,
                                discretization_var_pick_algo,
                                discretization_ratio,
                                discretization_uniform_rate,
                                discretization_add_partition_method,
                                discretization_abs_width_tol,
                                discretization_rel_width_tol,
                                discretization_consecutive_forbid,
                                convexhull_sweep_limit,
                                convhull_formulation_sos2,
                                convhull_formulation_sos2aux,
                                convhull_formulation_facet,
                                convhull_formulation_minib,
                                presolve_track_time,
                                presolve_bound_tightening,
                                presolve_maxiter,
                                presolve_bt_width_tol,
                                presolve_bt_output_tol,
                                presolve_bound_tightening_algo,
                                presolve_mip_relaxation,
                                presolve_mip_timelimit,
                                bound_basic_propagation,
                                user_parameters)

        m = new()

        m.colorful_pod = colorful_pod
        m.dev_debug = dev_debug
        m.dev_test = dev_test

        m.log_level = log_level
        m.timeout = timeout
        m.maxiter = maxiter
        m.rel_gap = rel_gap
        m.tol = tol
        m.tol_fea = tol_fea

        m.recognize_convex = recognize_convex
        m.bilinear_mccormick = bilinear_mccormick
        m.bilinear_convexhull = bilinear_convexhull
        m.monomial_convexhull = monomial_convexhull

        m.method_convexification = method_convexification
        m.term_patterns = term_patterns
        m.constr_patterns = constr_patterns

        m.discretization_var_pick_algo = discretization_var_pick_algo
        m.discretization_ratio = discretization_ratio
        m.discretization_uniform_rate = discretization_uniform_rate
        m.discretization_add_partition_method = discretization_add_partition_method
        m.discretization_abs_width_tol = discretization_abs_width_tol
        m.discretization_rel_width_tol = discretization_rel_width_tol
        m.discretization_consecutive_forbid = discretization_consecutive_forbid

        m.convexhull_sweep_limit = convexhull_sweep_limit
        m.convhull_formulation_sos2 = convhull_formulation_sos2
        m.convhull_formulation_sos2aux = convhull_formulation_sos2aux
        m.convhull_formulation_facet = convhull_formulation_facet
        m.convhull_formulation_minib = convhull_formulation_minib

        m.presolve_track_time = presolve_track_time
        m.presolve_bound_tightening = presolve_bound_tightening
        m.presolve_maxiter = presolve_maxiter
        m.presolve_bt_width_tol = presolve_bt_width_tol
        m.presolve_bt_output_tol = presolve_bt_output_tol
        m.presolve_bound_tightening_algo = presolve_bound_tightening_algo
        m.presolve_mip_relaxation = presolve_mip_relaxation
        m.presolve_mip_timelimit = presolve_mip_timelimit

        m.bound_basic_propagation = bound_basic_propagation

        m.nlp_local_solver = nlp_local_solver
        m.minlp_local_solver = minlp_local_solver
        m.mip_solver = mip_solver

        m.num_var_orig = 0
        m.num_cont_var_orig = 0
        m.num_int_var_orig = 0
        m.num_constr_orig = 0
        m.num_lconstr_orig = 0
        m.num_nlconstr_orig = 0
        m.var_type_orig = Symbol[]
        m.var_start_orig = Float64[]
        m.constr_type_orig = Symbol[]
        m.constr_expr_orig = Expr[]
        m.num_lconstr_updated = 0
        m.num_nlconstr_updated = 0
        m.indexes_lconstr_updated = Int[]

        m.linear_terms = Dict()
        m.nonlinear_terms = Dict()
        m.nonlinear_constrs = Dict()
        m.all_nonlinear_vars = Int[]
        m.bounding_constr_expr_mip = []
        m.bounding_constr_mip = []
        m.var_discretization_mip = []
        m.discretization = Dict()
        m.num_var_linear_lifted_mip = 0
        m.num_var_nonlinear_lifted_mip = 0
        m.num_var_discretization_mip = 0
        m.num_constr_convex = 0
        m.structural_constr = []
        m.bound_sol_history = []
        m.sol_incumb_lb = []

        m.user_parameters = Dict()

        m.best_obj = Inf
        m.best_bound = -Inf
        m.best_rel_gap = Inf
        m.pod_status = :NotLoaded

        m.dump = STDOUT

        create_status!(m)
        create_logs!(m)

        return m
    end
end

function MathProgBase.loadproblem!(m::PODNonlinearModel,
                                    num_var::Int, num_constr::Int,
                                    l_var::Vector{Float64}, u_var::Vector{Float64},
                                    l_constr::Vector{Float64}, u_constr::Vector{Float64},
                                    sense::Symbol, d::MathProgBase.AbstractNLPEvaluator)

    m.num_var_orig = num_var
    m.num_constr_orig = num_constr
    m.l_var_orig = l_var
    m.u_var_orig = u_var
    m.l_constr_orig = l_constr
    m.u_constr_orig = u_constr
    m.sense_orig = sense
    if m.sense_orig == :Max
        m.best_obj = -Inf
        m.best_bound = Inf
    end
    m.d_orig = d
    MathProgBase.initialize(m.d_orig, [:Grad,:Jac,:Hess,:ExprGraph])
    for i in 1:m.num_constr_orig
        push!(m.constr_expr_orig, MathProgBase.constr_expr(d, i))
    end
    m.obj_expr_orig = MathProgBase.obj_expr(d)
    m.var_type_orig = [getcategory(Variable(d.m, i)) for i in 1:m.num_var_orig]

    # Summarize constraints information in original model
    @compat m.constr_type_orig = Array{Symbol}(m.num_constr_orig)
    @assert length(m.l_constr_orig) == m.num_constr_orig
    for i in 1:m.num_constr_orig
        if l_constr[i] > -Inf && u_constr[i] < Inf
            m.constr_type_orig[i] = :(==)
            @assert m.l_constr_orig[i] == m.u_constr_orig[i]
        elseif l_constr[i] > -Inf
            m.constr_type_orig[i] = :(>=)
            @assert m.u_constr_orig[i] == Inf
        else
            m.constr_type_orig[i] = :(<=)
            @assert m.l_constr_orig[i] == -Inf
        end
    end

    m.structural_obj = :none
    m.structural_constr = [:none for i in 1:m.num_constr_orig]

    for i = 1:m.num_constr_orig
        if MathProgBase.isconstrlinear(m.d_orig, i)
            m.num_lconstr_orig += 1
            m.structural_constr[i] = :generic_linear
        else
            m.structural_constr[i] = :generic_nonlinear
        end
    end
    m.num_nlconstr_orig = m.num_constr_orig - m.num_lconstr_orig

    # not using this any where (in optional fields)
    m.is_obj_linear_orig = MathProgBase.isobjlinear(m.d_orig)
    m.is_obj_linear_orig ? (m.structural_obj = :generic_linear) : (m.structural_obj = :generic_nonlinear)

    # populate data to create the bounding model
    process_expr(m)                 # Compact process of every expression
    initialize_tight_bounds(m)      # Initialize tightened bound vectors for future usage
    m.bound_basic_propagation && bounds_propagation(m) # Fetch bounds from constraints
    resolve_lifted_var_bounds(m)    # resolve lifted var bounds
    pick_vars_discretization(m)     # Picking variables to be discretized
    initialize_discretization(m)    # Initialize discretization dictionary

    # Setup the memory space for recording bounding solutions
    m.bound_sol_history = Vector{Vector{Float64}}(m.discretization_consecutive_forbid)

    # Record the initial solution from the warmstarting value, if any
    m.best_sol = m.d_orig.m.colVal

    fetch_mip_solver_identifier(m)
    fetch_nlp_solver_identifier(m)
    fetch_minlp_solver_identifier(m)

    logging_summary(m)

    return
end

function MathProgBase.optimize!(m::PODNonlinearModel)
    if any(isnan, m.best_sol)
        m.best_sol = zeros(length(m.best_sol))
    end
    presolve(m)
    global_solve(m)
    (m.log_level > 0) && logging_row_entry(m, finsih_entry=true)
    summary_status(m)
end

MathProgBase.setwarmstart!(m::PODNonlinearModel, x) = (m.var_start_orig = x)
MathProgBase.setvartype!(m::PODNonlinearModel, v::Vector{Symbol}) = (m.var_type_orig = v)

MathProgBase.status(m::PODNonlinearModel) = m.pod_status
MathProgBase.getobjval(m::PODNonlinearModel) = m.best_obj
MathProgBase.getobjbound(m::PODNonlinearModel) = m.best_bound
MathProgBase.getsolution(m::PODNonlinearModel) = m.best_sol
MathProgBase.getsolvetime(m::PODNonlinearModel) = m.logs[:total_time]


"""
    presolve(m::PODNonlinearModel)

Function that perfoms a presolve on the user-supplied nonlinear program.
The presolve first provides the model to a local solver to obtain an initial feasible solution.
If the local solver returns a feasible solution then the objective value of the feasible solution
is used in conjunction with the original model for a bound-tightening procedure.
If the local solver reports infeasibililty the bound-tightening procedure does not use
the objective value. Furthermore, in this case, a second local solve is attempted using the tightened bounds.

If a local solution is not obtained eved after the second solve then an initial McCormick solve is performed.
The local solution (if available) or the initial McCormick solution (if infeasible after two local solve tries)
is then used to partition the variables for the subsequent Adaptive Multivariate Partitioning algorithm iterations.
"""
function presolve(m::PODNonlinearModel)

    start_presolve = time()
    (m.log_level > 0) && println("\nPOD algorithm presolver started.")
    (m.log_level > 0) && println("Performing local solve to obtain a feasible solution.")
    local_solve(m, presolve = true)

    # Regarding upcoming changes in status
    status_pass = [:Optimal, :Suboptimal, :UserLimit]
    status_reroute = [:Infeasible]

    if m.status[:local_solve] in status_pass
        bound_tightening(m, use_bound = true)                              # performs bound-tightening with the local solve objective value
        (m.presolve_bound_tightening) && initialize_discretization(m)      # Reinitialize discretization dictionary on tight bounds
        add_partition(m, use_solution=m.best_sol)  # Setting up the initial discretization
    elseif m.status[:local_solve] in status_reroute
        (m.log_level > 0) && println("first attempt at local solve failed, performing bound tightening without objective value...")
        bound_tightening(m, use_bound = false)                      # do bound tightening without objective value
        (m.log_level > 0) && println("second attempt at local solve using tightened bounds...")
        local_solve(m, presolve = true) # local_solve(m) to generate a feasible solution which is a starting point for bounding_solve
        if m.status in status_pass  # successful second try
            add_partition(m, use_solution=m.best_sol)
        else    # if this does not produce an feasible solution then solve atmc without discretization and use as a starting point
            (m.log_level > 0) && println("reattempt at local solve failed, initialize discretization with lower bound solution... \n local solve remains infeasible...")
            # TODO: Make sure the discretization dictionary is clean
            create_bounding_mip(m)       # Build the bounding ATMC model
            bounding_solve(m)            # Solve bounding model
            add_partition(m, use_solution=m.best_bound_sol)
        end
    elseif m.status[:local_solve] == :Not_Enough_Degrees_Of_Freedom
        error("NLP solver returns $(m.status[:local_solve]). \n Consider more replace equality constraints with >= and <= to resolve this.")
    else
        error("NLP local solve is $(m.status[:local_solve]) - quitting solve.")
        quit()
    end

    cputime_presolve = time() - start_presolve
    m.logs[:presolve_time] += cputime_presolve
    m.logs[:total_time] = m.logs[:presolve_time]
    m.logs[:time_left] -= m.logs[:presolve_time]
    (m.log_level > 0) && println("Presolve ended.")
    (m.log_level > 0) && println("Presolve time = $(@compat round.(m.logs[:total_time],2))s")

    return
end


"""

    global_solve(m::PODNonlinearModel)

Perform the global algorithm that is based on the adaptive conexification scheme.
This iterative algorithm loops over [`bounding_solve`](@ref) and [`local_solve`](@ref) for converging lower bound (relaxed problem) and upper bound (feasible problem).
Each [`bounding_solve`](@ref) provides a lower bound solution that is used as a partioning point for next iteration (this feature can be modified given different `add_adaptive_partition`).
Each [`local_solve`](@ref) provides a local serach of incumbent feasible solution. The algrithm terminates given time limits, optimality condition, or iteration limits.

The algorithm is can be reformed when `add_adaptive_partition` is replaced with user-defined functional input.
For example, this algorithm can easily be reformed as a uniform-partitioning algorithm in other literature.

"""
function global_solve(m::PODNonlinearModel)

    (m.log_level > 0) && logging_head(m)
    (!m.presolve_track_time) && reset_timer(m)
    while (m.best_rel_gap > m.rel_gap) && (m.logs[:time_left] > 0.0001) && (m.logs[:n_iter] < m.maxiter)
        m.logs[:n_iter] += 1
        create_bounding_mip(m)                                                  # Build the bounding ATMC model
        bounding_solve(m)                                                       # Solve bounding model
        update_opt_gap(m)
        (m.log_level > 0) && logging_row_entry(m)
        local_solve(m)                                                          # Solve upper bounding model
        (m.best_rel_gap <= m.rel_gap || m.logs[:n_iter] >= m.maxiter) && break
        add_partition(m)                                 # Add extra discretizations
    end

    return
end

"""

    local_solve(m::PODNonlinearModel, presolve::Bool=false)

Perform a local NLP or MINLP solve to obtain a feasible solution.
The `presolve` option is set to `true` when the function is invoked in [`presolve`](@ref).
Otherwise, the function is invoked from [`bounding_solve`](@ref).

"""

function local_solve(m::PODNonlinearModel; presolve = false)

    convertor = Dict(:Max=>:>, :Min=>:<)

    ((:Bin in m.var_type_orig) || (:Int in m.var_type_orig)) && (has_discrete_var = true)

    if presolve
        if has_discrete_var && m.minlp_local_solver != UnsetSolver()
            local_solve_nlp_model = MathProgBase.NonlinearModel(m.minlp_local_solver)
        elseif has_discrete_var && m.minlp_local_solver == UnsetSolver()
            warn("Discrete variable detected with no minlp_local_solver indicated. Using nlp_local_solver ...")
            local_solve_nlp_model = MathProgBase.NonlinearModel(m.nlp_local_solver)
        else
            local_solve_nlp_model = MathProgBase.NonlinearModel(m.nlp_local_solver)
        end
    else
        if m.nlp_local_solver != UnsetSolver()
            local_solve_nlp_model = MathProgBase.NonlinearModel(m.nlp_local_solver)
        else
            warn("Handling NLP problem with minlp solver, could result in error due to MINLP solver.")
            local_solve_nlp_model = MathProgBase.NonlinearModel(m.minlp_local_solver)
        end
    end

    if presolve
        l_var, u_var = m.l_var_orig, m.u_var_orig
    else
        l_var, u_var = fix_domains(m)
    end

    MathProgBase.loadproblem!(local_solve_nlp_model,
                              m.num_var_orig,
                              m.num_constr_orig,
                              l_var,
                              u_var,
                              m.l_constr_orig,
                              m.u_constr_orig,
                              m.sense_orig,
                              m.d_orig)

    (!m.d_orig.want_hess) && MathProgBase.initialize(m.d_orig, [:Grad,:Jac,:Hess,:HessVec, :ExprGraph]) # Safety scheme for sub-solvers re-initializing the NLPEvaluator
    presolve && has_discrete_var && MathProgBase.setvartype!(local_solve_nlp_model, m.var_type_orig)
    if isempty(m.sol_incumb_lb)
        println("[BETA] warm starting local solve using UB solution (RISKY)")
        MathProgBase.setwarmstart!(local_solve_nlp_model, m.best_sol[1:m.num_var_orig])
    else
        println("[BETA] warm starting local solve using LB solution (RISKY)")
        MathProgBase.setwarmstart!(local_solve_nlp_model, m.sol_incumb_lb[1:m.num_var_orig])
    end

    start_local_solve = time()
    MathProgBase.optimize!(local_solve_nlp_model)
    cputime_local_solve = time() - start_local_solve
    m.logs[:total_time] += cputime_local_solve
    m.logs[:time_left] = max(0.0, m.timeout - m.logs[:total_time])
    status_pass = [:Optimal, :Suboptimal, :UserLimit, :LocalOptimal]
    status_reroute = [:Infeasible]

    local_solve_nlp_status = MathProgBase.status(local_solve_nlp_model)
    if local_solve_nlp_status in status_pass
        candidate_obj = MathProgBase.getobjval(local_solve_nlp_model)
        push!(m.logs[:obj], candidate_obj)
        if eval(convertor[m.sense_orig])(candidate_obj, m.best_obj + 1e-5)
            m.best_obj = candidate_obj
            m.best_sol = MathProgBase.getsolution(local_solve_nlp_model)
            m.best_sol = round.(MathProgBase.getsolution(local_solve_nlp_model), 5)
            m.status[:feasible_solution] = :Detected
        end
        m.status[:local_solve] = local_solve_nlp_status
        return
    elseif local_solve_nlp_status in status_reroute
        m.status[:local_solve] = heu_relaxation_rounding(m)
        return
    elseif local_solve_nlp_status == :Unbounded
        (presolve == true) && warn("[PRESOLVE] NLP local solve is unbounded.")
        (presolve == false) && warn("[LOCAL SOLVE] NLP local solve is unbounded.")
        m.status[:local_solve] = :Unbounded
        return
    else
		(presolve == true) && error("[PRESOLVE] NLP solve failure $(local_solve_nlp_status).")
        (presolve == false) && warn("[LOCAL SOLVE] NLP local solve failure.")
        m.status[:local_solve] = :Error
        return
    end

    return
end

"""

    bounding_solve(m::PODNonlinearModel; kwargs...)

This is a solving process usually deal with a MIP or MIQCP problem for lower bounds of problems.
It solves the problem built upon a convexification base on a discretization Dictionary of some variables.
The convexification utilized is Tighten McCormick scheme.
See `create_bounding_mip` for more details of the problem solved here.

"""
function bounding_solve(m::PODNonlinearModel; kwargs...)

    # ================= Solve Start ================ #
    convertor = Dict(:Max=>:<, :Min=>:>)
    boundlocator = Dict(:Max=>:+, :Min=>:-)
    boundlocator_rev = Dict(:Max=>:-, :Max=>:+)
    update_mip_time_limit(m)
    update_boundstop_options(m)
    start_bounding_solve = time()
    status = solve(m.model_mip, suppress_warnings=true)
    cputime_bounding_solve = time() - start_bounding_solve
    m.logs[:total_time] += cputime_bounding_solve
    m.logs[:time_left] = max(0.0, m.timeout - m.logs[:total_time])
    # ================= Solve End ================ #

    status_solved = [:Optimal, :UserObjLimit, :UserLimit, :Suboptimal]
    status_maynosolution = [:UserObjLimit, :UserLimit]  # Watch out for these cases
    status_reroute = [:Infeasible]
    if status in status_solved
        (status == :Optimal) ? candidate_bound = m.model_mip.objVal : candidate_bound = m.model_mip.objBound
        candidate_bound_sol = [round.(getvalue(Variable(m.model_mip, i)), 6) for i in 1:m.num_var_orig+m.num_var_linear_lifted_mip+m.num_var_nonlinear_lifted_mip]
        (m.discretization_consecutive_forbid>0) && (m.bound_sol_history[mod(m.logs[:n_iter]-1, m.discretization_consecutive_forbid)+1] = copy(candidate_bound_sol)) # Requires proper offseting
        push!(m.logs[:bound], candidate_bound)
        if eval(convertor[m.sense_orig])(candidate_bound, m.best_bound + 1e-10)
            m.best_bound = candidate_bound
            m.best_bound_sol = copy(candidate_bound_sol)
            m.sol_incumb_lb = [getvalue(Variable(m.model_mip, i)) for i in 1:m.num_var_orig+m.num_var_linear_lifted_mip+m.num_var_nonlinear_lifted_mip] # can remove this
            m.status[:bounding_solve] = status
            m.status[:bound] = :Detected
        end
    elseif status in status_reroute
        push!(m.logs[:bound], "-")
        m.status[:bounding_solve] = status
        print_iis_gurobi(m.model_mip)
        error("[PROBLEM INFEASIBLE] Infeasibility detected via convex relaxation Infeasibility")
    elseif status == :Unbounded
        m.status[:bounding_solve] = status
        error("[MIP UNBOUNDED] MIP solver failure")
    else
        error("[MIP UNEXPECTED] MIP solver failure $(status)")
    end
end
