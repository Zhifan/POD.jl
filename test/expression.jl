@testset "Expression Parser Test" begin

    @testset "Expression Test || bilinear || Affine || exprs.jl" begin

        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)

        m=exprstest(solver=test_solver)

        JuMP.build(m)

        ex = m.internalModel.bounding_constr_expr_mip[1]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [-1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[1][:coefs]
        @test affdict[:vars] == [:(x[1])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[1][:vars]
        @test isapprox(affdict[:rhs], 109.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[1][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[1][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[2]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [3.0,3.0,3.0,3.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[2][:coefs]
        @test affdict[:vars] == [:(x[8]),:(x[9]),:(x[10]),:(x[11])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[2][:vars]
        @test isapprox(affdict[:rhs], 111.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[2][:rhs]
        @test affdict[:sense] == :(>=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[2][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[3]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [-1.0,20.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[3][:coefs]
        @test affdict[:vars] == [:(x[12]),:(x[13])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[3][:vars]
        @test isapprox(affdict[:rhs], 222.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[3][:rhs]
        @test affdict[:sense] == :(>=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[3][:sense]

        # 1.0 * x[12] - 115.0 >= 0.0
        ex = m.internalModel.bounding_constr_expr_mip[4]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [-1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[4][:coefs]
        @test affdict[:vars] == [:(x[12])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[4][:vars]
        @test isapprox(affdict[:rhs], 115.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[4][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[4][:sense]

        # 1.0 * x[12] - 115.0 <= 0.0
        ex = m.internalModel.bounding_constr_expr_mip[5]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[5][:coefs]
        @test affdict[:vars] == [:(x[12])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[5][:vars]
        @test isapprox(affdict[:rhs], 115.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[5][:rhs]
        @test affdict[:sense] == :(>=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[5][:sense]

        # -1.0 * x[12] - 115.0 >= 0.0
        ex = m.internalModel.bounding_constr_expr_mip[6]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [-1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[6][:coefs]
        @test affdict[:vars] == [:(x[12])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[6][:vars]
        @test isapprox(affdict[:rhs], 115.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[6][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[6][:sense]

        # (x[1] + 1.0 * x[14]) - 555.0 >= 0.0
        ex = m.internalModel.bounding_constr_expr_mip[7]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [1.0, 1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[7][:coefs]
        @test affdict[:vars] == [:(x[1]),:(x[14])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[7][:vars]
        @test isapprox(affdict[:rhs], 555.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[7][:rhs]
        @test affdict[:sense] == :(>=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[7][:sense]

        # ((x[8] - 7.0 * x[9]) + x[10] + x[4]) - 6666.0 <= 0.0
        ex = m.internalModel.bounding_constr_expr_mip[8]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [1.0,-7.0,1.0,1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[8][:coefs]
        @test affdict[:vars] == [:(x[8]),:(x[9]),:(x[10]),:(x[4])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[8][:vars]
        @test isapprox(affdict[:rhs], 6666.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[8][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[8][:sense]

        # ((13.0 * x[1] - x[2]) + 30.0 * x[3] + x[4]) - 77.0 >= 0.0
        ex = m.internalModel.bounding_constr_expr_mip[9]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [13.0,-1.0,30.0,1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[9][:coefs]
        @test affdict[:vars] == [:(x[1]),:(x[2]),:(x[3]),:(x[4])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[9][:vars]
        @test isapprox(affdict[:rhs], 77.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[9][:rhs]
        @test affdict[:sense] == :(>=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[9][:sense]
    end

    @testset "Expression Test || bilinear || Affine || nlp1.jl" begin
        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)
        m=nlp1(solver=test_solver)

        JuMP.build(m)

        ex = m.internalModel.bounding_constr_expr_mip[1]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [1.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[1][:coefs]
        @test affdict[:vars] == [:(x[5])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[1][:vars]
        @test isapprox(affdict[:rhs], 8.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[1][:rhs]
        @test affdict[:sense] == :(>=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[1][:sense]
    end

    @testset "Expression Test || bilinear || Affine || nlp3.jl" begin

        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
								   mip_solver=CbcSolver(OutputFlag=0),
								   log_level=0)

        m=nlp3(solver=test_solver)

        JuMP.build(m)

        ex = m.internalModel.bounding_constr_expr_mip[1]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [0.0025,0.0025]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[1][:coefs]
        @test affdict[:vars] == [:(x[4]),:(x[6])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[1][:vars]
        @test isapprox(affdict[:rhs], 1.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[1][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[1][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[2]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [0.0025,-0.0025,0.0025]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[2][:coefs]
        @test affdict[:vars] == [:(x[5]),:(x[4]),:(x[7])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[2][:vars]
        @test isapprox(affdict[:rhs], 1.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[2][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[2][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[3]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [0.01, -0.01]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[3][:coefs]
        @test affdict[:vars] == [:(x[8]),:(x[5])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[3][:vars]
        @test isapprox(affdict[:rhs], 1.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[3][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[3][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[4]
        affdict = POD.expr_linear_to_affine(ex)
        @test (affdict[:coefs] .== [100.0, -1.0, 833.33252]) == [true, true, true]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[4][:coefs]
        @test affdict[:vars] == [:(x[1]),:(x[9]),:(x[4])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[4][:vars]
        @test isapprox(affdict[:rhs], 83333.333; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[4][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[4][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[5]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [1.0,-1.0,-1250.0,1250.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[5][:coefs]
        @test affdict[:vars] == [:(x[10]),:(x[11]),:(x[4]),:(x[5])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[5][:vars]
        @test isapprox(affdict[:rhs], 0.0; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[5][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[5][:sense]

        ex = m.internalModel.bounding_constr_expr_mip[6]
        affdict = POD.expr_linear_to_affine(ex)
        @test affdict[:coefs] == [1.0,-1.0,-2500.0]
        @test affdict[:coefs] == m.internalModel.bounding_constr_mip[6][:coefs]
        @test affdict[:vars] == [:(x[12]),:(x[13]),:(x[5])]
        @test affdict[:vars] == m.internalModel.bounding_constr_mip[6][:vars]
        @test isapprox(affdict[:rhs], -1.25e6; atol = 1e-3)
        @test affdict[:rhs] == m.internalModel.bounding_constr_mip[6][:rhs]
        @test affdict[:sense] == :(<=)
        @test affdict[:sense] == m.internalModel.bounding_constr_mip[6][:sense]
	end

    @testset "Expression Test || bilinear || Simple || bi1.jl " begin

        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)

        m = operator_c(solver=test_solver)

        JuMP.build(m) # Setup internal model

        @test length(keys(m.internalModel.nonlinear_terms)) == 8
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 1), Expr(:ref, :x, 1)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 2), Expr(:ref, :x, 2)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 3), Expr(:ref, :x, 3)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 4), Expr(:ref, :x, 4)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 2), Expr(:ref, :x, 3)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 3), Expr(:ref, :x, 4)])

        # TODO setup detailed check on this problem
    end

    @testset "Expression Test || bilinear || Complex || blend029.jl " begin

        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)

        m = blend029(solver=test_solver)

        JuMP.build(m) # Setup internal model
        @test length(keys(m.internalModel.nonlinear_terms)) == 28
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 37), Expr(:ref, :x, 55)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 38), Expr(:ref, :x, 56)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 37), Expr(:ref, :x, 26)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 43), Expr(:ref, :x, 26)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 47), Expr(:ref, :x, 59)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 48), Expr(:ref, :x, 60)])
        @test haskey(m.internalModel.nonlinear_terms, [Expr(:ref, :x, 47), Expr(:ref, :x, 36)])

        @test m.internalModel.bounding_constr_mip[1][:rhs] == 1.0
        @test m.internalModel.bounding_constr_mip[1][:vars] == Any[:(x[1]), :(x[4]), :(x[7]), :(x[10]), :(x[49])]
        @test m.internalModel.bounding_constr_mip[1][:sense] == :(==)
        @test m.internalModel.bounding_constr_mip[1][:coefs] == Any[1.0, 1.0, 1.0, 1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[1][:cnt] == 5

        @test m.internalModel.bounding_constr_mip[4][:rhs] == 0.1
        @test m.internalModel.bounding_constr_mip[4][:vars] == Any[:(x[4]), :(x[16]), :(x[25]), :(x[34]), :(x[58])]
        @test m.internalModel.bounding_constr_mip[4][:sense] == :(==)
        @test m.internalModel.bounding_constr_mip[4][:coefs] == Any[-1.0, -1.0, -1.0, 1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[4][:cnt] == 5

        @test m.internalModel.bounding_constr_mip[17][:rhs] == -0.14
        @test m.internalModel.bounding_constr_mip[17][:vars] == Any[:(x[11]), :(x[23]), :(x[32]), :(x[64]), :(x[65])]
        @test m.internalModel.bounding_constr_mip[17][:sense] == :(==)
        @test m.internalModel.bounding_constr_mip[17][:coefs] == Any[-1.0, -1.0, -1.0, -1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[17][:cnt] == 5

        @test m.internalModel.bounding_constr_mip[67][:rhs] == 0.0
        @test m.internalModel.bounding_constr_mip[67][:vars] == Any[:(x[13])]
        @test m.internalModel.bounding_constr_mip[67][:sense] == :(>=)
        @test m.internalModel.bounding_constr_mip[67][:coefs] == Any[1.0]
        @test m.internalModel.bounding_constr_mip[67][:cnt] == 1

        @test m.internalModel.bounding_constr_mip[103][:rhs] == 1.0
        @test m.internalModel.bounding_constr_mip[103][:vars] == Any[:(x[73])]
        @test m.internalModel.bounding_constr_mip[103][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[103][:coefs] == Any[1.0]
        @test m.internalModel.bounding_constr_mip[103][:cnt] == 1

        @test m.internalModel.bounding_constr_mip[127][:rhs] == -1.0
        @test m.internalModel.bounding_constr_mip[127][:vars] == Any[:(x[73])]
        @test m.internalModel.bounding_constr_mip[127][:sense] == :(>=)
        @test m.internalModel.bounding_constr_mip[127][:coefs] == Any[-1.0]
        @test m.internalModel.bounding_constr_mip[127][:cnt] == 1

        @test m.internalModel.bounding_constr_mip[187][:rhs] == 1.0
        @test m.internalModel.bounding_constr_mip[187][:vars] == Any[:(x[79]), :(x[94])]
        @test m.internalModel.bounding_constr_mip[187][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[187][:coefs] == Any[1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[187][:cnt] == 2

        @test m.internalModel.bounding_constr_mip[202][:rhs] == 0.04
        @test m.internalModel.bounding_constr_mip[202][:vars] == Any[:(x[103]), :(x[1]), :(x[13]), :(x[25]), :(x[28]), :(x[31])]
        @test m.internalModel.bounding_constr_mip[202][:sense] == :(==)
        @test m.internalModel.bounding_constr_mip[202][:coefs] == Any[1.0, -0.6, -0.2, 0.2, 0.2, 0.2]
        @test m.internalModel.bounding_constr_mip[202][:cnt] == 6

        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[55])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[55])]][:lifted_var_ref] == :(x[103])
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[55])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[55])]][:nonlinear_type] == :bilinear

        @test m.internalModel.bounding_constr_mip[206][:rhs] == 0.0
        @test m.internalModel.bounding_constr_mip[206][:vars] == Any[:(x[107]), :(x[103]), :(x[108]), :(x[109]), :(x[110]), :(x[2]), :(x[14])]
        @test m.internalModel.bounding_constr_mip[206][:sense] == :(==)
        @test m.internalModel.bounding_constr_mip[206][:coefs] == Any[1.0, -1.0, 1.0, 1.0, 1.0, -0.6, -0.2]
        @test m.internalModel.bounding_constr_mip[206][:cnt] == 7

        @test m.internalModel.nonlinear_terms[[:(x[38]), :(x[56])]][:id] == 5
        @test m.internalModel.nonlinear_terms[[:(x[38]), :(x[56])]][:lifted_var_ref] == :(x[107])
        @test m.internalModel.nonlinear_terms[[:(x[38]), :(x[56])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[38]), :(x[56])]][:nonlinear_type] == :bilinear

        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[26])]][:id] == 6
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[26])]][:lifted_var_ref] == :(x[108])
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[26])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[26])]][:nonlinear_type] == :bilinear

        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[32])]][:id] == 8
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[32])]][:lifted_var_ref] == :(x[110])
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[32])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[37]), :(x[32])]][:nonlinear_type] == :bilinear

        @test m.internalModel.bounding_constr_mip[213][:rhs] == 0.0
        @test m.internalModel.bounding_constr_mip[213][:vars] == Any[:(x[129]), :(x[127]), :(x[124]), :(x[130]), :(x[6]), :(x[18])]
        @test m.internalModel.bounding_constr_mip[213][:sense] == :(==)
        @test m.internalModel.bounding_constr_mip[213][:coefs] == Any[1.0, -1.0, -1.0, 1.0, -0.4, -0.4]
        @test m.internalModel.bounding_constr_mip[213][:cnt] == 6

        @test m.internalModel.nonlinear_terms[[:(x[48]), :(x[60])]][:id] == 27
        @test m.internalModel.nonlinear_terms[[:(x[48]), :(x[60])]][:lifted_var_ref] == :(x[129])
        @test m.internalModel.nonlinear_terms[[:(x[48]), :(x[60])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[48]), :(x[60])]][:nonlinear_type] == :bilinear

        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[59])]][:id] == 25
        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[59])]][:lifted_var_ref] == :(x[127])
        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[59])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[59])]][:nonlinear_type] == :bilinear

        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[36])]][:id] == 28
        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[36])]][:lifted_var_ref] == :(x[130])
        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[36])]][:convexified] == false
        @test m.internalModel.nonlinear_terms[[:(x[47]), :(x[36])]][:nonlinear_type] == :bilinear
    end

    @testset "Expression Test || multilinear || Simple || multi.jl " begin

        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)

        m = multi3(solver=test_solver, exprmode=1)

        JuMP.build(m) # Setup internal model

        @test length(keys(m.internalModel.nonlinear_terms)) == 1
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3])]][:lifted_var_ref] == :(x[4])
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3])]][:nonlinear_type] == :multilinear

        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[4])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        @test m.internalModel.bounding_constr_mip[1][:rhs] == 3.0
        @test m.internalModel.bounding_constr_mip[1][:vars] == Any[:(x[1]), :(x[2]), :(x[3])]
        @test m.internalModel.bounding_constr_mip[1][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[1][:coefs] == Any[1.0, 1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[1][:cnt] == 3

        m = multi3(solver=test_solver, exprmode=2)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:lifted_var_ref] == :(x[4])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 4), Expr(:ref, :x, 3)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 4), Expr(:ref, :x, 3)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 4), Expr(:ref, :x, 3)]][:nonlinear_type] == :bilinear

        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[5])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi3(solver=test_solver, exprmode=3)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:lifted_var_ref] == :(x[4])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 4)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear

        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[5])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=1)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 1

        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[5])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3]), :(x[4])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3]), :(x[4])]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3]), :(x[4])]][:nonlinear_type] == :multilinear

        @test m.internalModel.bounding_constr_mip[1][:rhs] == 4.0
        @test m.internalModel.bounding_constr_mip[1][:vars] == Any[:(x[1]), :(x[2]), :(x[3]), :(x[4])]
        @test m.internalModel.bounding_constr_mip[1][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[1][:coefs] == Any[1.0, 1.0, 1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[1][:cnt] == 4

        m = multi4(solver=test_solver, exprmode=2)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 3

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 5), Expr(:ref, :x, 6)]][:id] == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 5), Expr(:ref, :x, 6)]][:lifted_var_ref] == :(x[7])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 5), Expr(:ref, :x, 6)]][:nonlinear_type] == :bilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[7])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing


        m = multi4(solver=test_solver, exprmode=3)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[:(x[5]), :(x[3]), :(x[4])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[5]), :(x[3]), :(x[4])]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[:(x[5]), :(x[3]), :(x[4])]][:nonlinear_type] == :multilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[6])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=4)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[5])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[5])]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[5])]][:nonlinear_type] == :multilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[6])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=5)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 3

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 5)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 5)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 5)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 6), Expr(:ref, :x, 4)]][:id] == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 6), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[7])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 6), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[7])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=6)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2

        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3])]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2]), :(x[3])]][:nonlinear_type] == :multilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 5), Expr(:ref, :x, 4)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 5), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 5), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear

        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[6])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=7)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 3

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 3), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 5)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 5)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 5)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 6)]][:id] == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 6)]][:lifted_var_ref] == :(x[7])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 6)]][:nonlinear_type] == :bilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[7])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing


        m = multi4(solver=test_solver, exprmode=8)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[5]), :(x[4])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[5]), :(x[4])]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[5]), :(x[4])]][:nonlinear_type] == :multilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[6])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing


        m = multi4(solver=test_solver, exprmode=9)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 2

        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[3]), :(x[4])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[3]), :(x[4])]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[3]), :(x[4])]][:nonlinear_type] == :multilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 5)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 5)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 5)]][:nonlinear_type] == :bilinear

        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[6])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=10)

        JuMP.build(m)
        @test length(keys(m.internalModel.nonlinear_terms)) == 3

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 4), Expr(:ref, :x, 5)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 4), Expr(:ref, :x, 5)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 4), Expr(:ref, :x, 5)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 6)]][:id] == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 6)]][:lifted_var_ref] == :(x[7])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 6)]][:nonlinear_type] == :bilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[7])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing

        m = multi4(solver=test_solver, exprmode=11)

        JuMP.build(m)

        @test length(keys(m.internalModel.nonlinear_terms)) == 3

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 3)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 5)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 5)]][:lifted_var_ref] == :(x[6])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 5)]][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 6), Expr(:ref, :x, 4)]][:id] == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 6), Expr(:ref, :x, 4)]][:lifted_var_ref] == :(x[7])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 6), Expr(:ref, :x, 4)]][:nonlinear_type] == :bilinear


        @test m.internalModel.bounding_obj_mip[:rhs] == 0
        @test m.internalModel.bounding_obj_mip[:vars] == Expr[:(x[7])]
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0]
        @test m.internalModel.bounding_obj_mip[:cnt] == 1
        @test m.internalModel.bounding_obj_mip[:sense] == nothing
    end

    @testset "Expression Test || bilinear || Complex-div || div.jl" begin
        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)

        m = div(solver=test_solver)

        JuMP.build(m) # Setup internal model

        @test length(keys(m.internalModel.nonlinear_terms)) == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 1)]][:id] == 1
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 1)]][:lifted_var_ref] == :(x[3])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 1)]][:nonlinear_type] == :monomial

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 2)]][:id] == 2
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 2)]][:lifted_var_ref] == :(x[4])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 2), Expr(:ref, :x, 2)]][:nonlinear_type] == :monomial

        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:id] == 3
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:lifted_var_ref] == :(x[5])
        @test m.internalModel.nonlinear_terms[[Expr(:ref, :x, 1), Expr(:ref, :x, 2)]][:nonlinear_type] == :bilinear

        aff_mip = m.internalModel.bounding_constr_mip

        @test aff_mip[1][:rhs] == 0.0
        @test aff_mip[1][:vars] == Any[:(x[1])]
        @test aff_mip[1][:sense] == :(>=)
        @test round.(aff_mip[1][:coefs],1) == Any[-3.0]
        @test aff_mip[1][:cnt] == 1

        @test aff_mip[2][:rhs] == 0.0
        @test aff_mip[2][:vars] == Any[:(x[2])]
        @test aff_mip[2][:sense] == :(>=)
        @test aff_mip[2][:coefs] == Any[0.25]
        @test aff_mip[2][:cnt] == 1

        @test aff_mip[3][:rhs] == 0.0
        @test aff_mip[3][:vars] == Any[:(x[2])]
        @test aff_mip[3][:sense] == :(>=)
        @test aff_mip[3][:coefs] == Any[5.0]
        @test aff_mip[3][:cnt] == 1

        @test aff_mip[4][:rhs] == 0.0
        @test aff_mip[4][:vars] == Any[:(x[2])]
        @test aff_mip[4][:sense] == :(>=)
        @test aff_mip[4][:coefs] == Any[-120.0]
        @test aff_mip[4][:cnt] == 1

        @test aff_mip[5][:rhs] == 0.0
        @test aff_mip[5][:vars] == Any[:(x[2])]
        @test aff_mip[5][:sense] == :(>=)
        @test aff_mip[5][:coefs] == Any[72000.0]
        @test aff_mip[5][:cnt] == 1

        @test aff_mip[6][:rhs] == 0.0
        @test aff_mip[6][:vars] == Any[:(x[1])]
        @test aff_mip[6][:sense] == :(>=)
        @test aff_mip[6][:coefs] == Any[72000.0]
        @test aff_mip[6][:cnt] == 1

        @test aff_mip[7][:rhs] == 8.0
        @test aff_mip[7][:vars] == Any[:(x[5])]
        @test aff_mip[7][:sense] == :(>=)
        @test aff_mip[7][:coefs] == Any[0.6]
        @test aff_mip[7][:cnt] == 1

        @test aff_mip[8][:rhs] == 0.0
        @test aff_mip[8][:vars] == Any[:(x[2]),:(x[5])]
        @test aff_mip[8][:sense] == :(>=)
        @test aff_mip[8][:coefs] == Any[5.6,-72000.0]
        @test aff_mip[8][:cnt] == 2

        @test aff_mip[9][:rhs] == 0.0
        @test aff_mip[9][:vars] == Any[:(x[2]),:(x[5])]
        @test aff_mip[9][:sense] == :(>=)
        @test aff_mip[9][:coefs] == Any[5.6,-36000.0]
        @test aff_mip[9][:cnt] == 2

        @test aff_mip[10][:rhs] == 0.0
        @test aff_mip[10][:vars] == Any[:(x[2]),:(x[5]),:(x[2])]
        @test aff_mip[10][:sense] == :(>=)
        @test aff_mip[10][:coefs] == Any[5.6, -300.0, -1.75]
        @test aff_mip[10][:cnt] == 3

        @test aff_mip[11][:rhs] == 0.0
        @test aff_mip[11][:vars] == Any[:(x[2]),:(x[1]),:(x[5])]
        @test aff_mip[11][:sense] == :(>=)
        @test aff_mip[11][:coefs] == Any[5.6, -0.5, 0.5]
        @test aff_mip[11][:cnt] == 3
    end

    @testset "Expression parsing || part1 " begin
        m = Model(solver=PODSolver(nlp_local_solver=IpoptSolver(),
								   mip_solver=CbcSolver(OutputFlag=0),
								   log_level=0))
        @variable(m, x[1:4]>=0)
        @NLconstraint(m, x[1]^2 >= 1)  					# Basic monomial x[5]=x[1]^2
        @NLconstraint(m, x[1]*x[2] <= 1)				# x[6] <= 1 : x[6] = x[1]*x[2]
        @NLconstraint(m, x[1]^2 * x[2]^2 <= 1)          # x[5] + x[7] <= 1 : x[7] = x[2]^2
        @NLconstraint(m, x[1]*(x[2]*x[3]) >= 1)         # x[9] >= 1 : x[8] = x[2] * x[3] && x[9] = x[1]*x[8]
        @NLconstraint(m, x[1]^2*(x[2]^2 * x[3]^2) <= 1) # x[12] <= 1 : x[10] = x[3] ^ 2 && x[11] = x[7] * x[10] && x[12] = x[11]*[5]

        JuMP.build(m)

        @test m.internalModel.bounding_constr_expr_mip[1] == :(x[5]-1.0>=0.0)
        @test m.internalModel.bounding_constr_expr_mip[2] == :(x[6]-1.0<=0.0)
        @test m.internalModel.bounding_constr_expr_mip[3] == :(x[8]-1.0<=0.0)
        @test m.internalModel.bounding_constr_expr_mip[4] == :(x[10]-1.0>=0.0)
        @test m.internalModel.bounding_constr_expr_mip[5] == :(x[13]-1.0<=0.0)
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[1])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[2])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[2])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[3])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[5]), :(x[7])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[9])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[3])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[2])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[5]), :(x[12])])

        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[1])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[2])]][:id] == 3
        @test m.internalModel.nonlinear_terms[[:(x[5]), :(x[7])]][:id] == 4
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[3])]][:id] == 5
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[9])]][:id] == 6
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[3])]][:id] == 7
        @test m.internalModel.nonlinear_terms[[:(x[7]), :(x[11])]][:id] == 8
        @test m.internalModel.nonlinear_terms[[:(x[5]), :(x[12])]][:id] == 9
    end

    @testset "Expression parsing || part2" begin
        m = Model(solver=PODSolver(nlp_local_solver=IpoptSolver(),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0))

        @variable(m, x[1:4]>=0)
        @NLconstraint(m, (x[1]*x[2]) * x[3] >= 1)
        @NLconstraint(m, (x[1]^2 * x[2]^2) * x[3]^2 <= 1)

        @NLconstraint(m, x[1] * (x[2]^2 * x[3]^2) >= 1)
        @NLconstraint(m, (x[1]^2 * x[2]) * x[3]^2 <= 1)
        @NLconstraint(m, x[1]^2 * (x[2] * x[3]) >= 1)
        @NLconstraint(m, (x[1] * x[2]^2) * x[3] <= 1)

        JuMP.build(m)

        @test m.internalModel.bounding_constr_expr_mip[1] == :(x[6]-1.0>=0.0)
        @test m.internalModel.bounding_constr_expr_mip[2] == :(x[11]-1.0<=0.0)
        @test m.internalModel.bounding_constr_expr_mip[3] == :(x[13]-1.0>=0.0)
        @test m.internalModel.bounding_constr_expr_mip[4] == :(x[15]-1.0<=0.0)
        @test m.internalModel.bounding_constr_expr_mip[5] == :(x[17]-1.0>=0.0)
        @test m.internalModel.bounding_constr_expr_mip[6] == :(x[19]-1.0<=0.0)

        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[2])]) #5
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[5])]) #6
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[1])]) #7
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[2])]) #8
        @test haskey(m.internalModel.nonlinear_terms, [:(x[7]), :(x[8])]) #9
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[3])]) #10
        @test haskey(m.internalModel.nonlinear_terms, [:(x[9]), :(x[10])]) #11
        @test haskey(m.internalModel.nonlinear_terms, [:(x[8]), :(x[10])]) #12
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[12])]) #13
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[7])])  #14
        @test haskey(m.internalModel.nonlinear_terms, [:(x[14]), :(x[10])]) #15
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[3])]) #16
        @test haskey(m.internalModel.nonlinear_terms, [:(x[7]), :(x[16])]) #17
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[8])]) #18
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[18])]) #19

        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[5])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[1])]][:id] == 3
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[2])]][:id] == 4
        @test m.internalModel.nonlinear_terms[[:(x[7]), :(x[8])]][:id] == 5
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[3])]][:id] == 6
        @test m.internalModel.nonlinear_terms[[:(x[9]), :(x[10])]][:id] == 7
        @test m.internalModel.nonlinear_terms[[:(x[8]), :(x[10])]][:id] == 8
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[12])]][:id] == 9
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[7])]][:id] == 10
        @test m.internalModel.nonlinear_terms[[:(x[14]), :(x[10])]][:id] == 11
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[3])]][:id] == 12
        @test m.internalModel.nonlinear_terms[[:(x[7]), :(x[16])]][:id] == 13
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[8])]][:id] == 14
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[18])]][:id] == 15
    end

    @testset "Expression parsing || part3" begin
        m = Model(solver=PODSolver(nlp_local_solver=IpoptSolver(),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0))

        @variable(m, x[1:4]>=0)
        @NLconstraint(m, ((x[1]*x[2])*x[3])*x[4] >= 1)
        @NLconstraint(m, ((x[1]^2*x[2])*x[3])*x[4] <= 1)
        @NLconstraint(m, ((x[1]*x[2]^2)*x[3])*x[4] >= 1)
        @NLconstraint(m, ((x[1]*x[2])*x[3]^2)*x[4] <= 1)
        @NLconstraint(m, ((x[1]*x[2])*x[3])*x[4]^2 >= 1)
        @NLconstraint(m, ((x[1]^2*x[2]^2)*x[3]^2)*x[4]^2 <= 1)

        JuMP.build(m)

        @test m.internalModel.bounding_constr_expr_mip[1] == :(x[7]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[2] == :(x[11]-1.0 <= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[3] == :(x[15]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[4] == :(x[18]-1.0 <= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[5] == :(x[20]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[6] == :(x[23]-1.0 <= 0.0)

        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[2])]) #5
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[5])]) #6
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]), :(x[6])]) #7
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[1])]) #8
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[8])]) #9
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[9])]) #10
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]), :(x[10])]) #11
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[2])]) #12
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[12])])  #13
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[13])]) #14
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]), :(x[14])]) #15
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]), :(x[3])]) #16
        @test haskey(m.internalModel.nonlinear_terms, [:(x[5]), :(x[16])]) #17
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]), :(x[17])]) #18
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]), :(x[4])]) #19
        @test haskey(m.internalModel.nonlinear_terms, [:(x[6]), :(x[19])]) #20
        @test haskey(m.internalModel.nonlinear_terms, [:(x[8]), :(x[12])]) #21
        @test haskey(m.internalModel.nonlinear_terms, [:(x[21]), :(x[16])]) #22
        @test haskey(m.internalModel.nonlinear_terms, [:(x[22]), :(x[19])]) #23

        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[2])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[5])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[6])]][:id] == 3
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[1])]][:id] == 4
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[8])]][:id] == 5
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[9])]][:id] == 6
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[10])]][:id] == 7
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[2])]][:id] == 8
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[12])]][:id] == 9
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[13])]][:id] == 10
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[14])]][:id] == 11
        @test m.internalModel.nonlinear_terms[[:(x[3]), :(x[3])]][:id] == 12
        @test m.internalModel.nonlinear_terms[[:(x[5]), :(x[16])]][:id] == 13
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[17])]][:id] == 14
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[4])]][:id] == 15
        @test m.internalModel.nonlinear_terms[[:(x[6]), :(x[19])]][:id] == 16
        @test m.internalModel.nonlinear_terms[[:(x[8]), :(x[12])]][:id] == 17
        @test m.internalModel.nonlinear_terms[[:(x[21]), :(x[16])]][:id] == 18
        @test m.internalModel.nonlinear_terms[[:(x[22]), :(x[19])]][:id] == 19
    end

    @testset "Expression parsing || part7" begin
        m = Model(solver=PODSolver(nlp_local_solver=IpoptSolver(),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0))
        @variable(m, x[1:4]>=0)

        @NLconstraint(m, x[1]*x[2]*x[3]*x[4] >= 1)
        @NLconstraint(m, x[1]^2*x[2]*x[3]*x[4] >= 1)
        @NLconstraint(m, x[1]*x[2]^2*x[3]*x[4] >= 1)
        @NLconstraint(m, x[1]*x[2]*x[3]^2*x[4]^2 >= 1)
        @NLconstraint(m, x[1]*x[2]^2*x[3]^2*x[4] >= 1)
        @NLconstraint(m, x[1]^2*x[2]*x[3]*x[4]^2 >= 1)
        @NLconstraint(m, x[1]^2*x[2]^2*x[3]^2*x[4]^2 >= 1)

        JuMP.build(m)

        @test m.internalModel.bounding_constr_expr_mip[1] == :(x[5]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[2] == :(x[7]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[3] == :(x[9]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[4] == :(x[12]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[5] == :(x[13]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[6] == :(x[14]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[7] == :(x[15]-1.0 >= 0.0)

        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[2]),:(x[3]),:(x[4])]) #5
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[1])]) #6
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]),:(x[3]),:(x[4]),:(x[6])]) #7
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]),:(x[2])]) #8
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[3]),:(x[4]),:(x[8])]) #9
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]),:(x[3])]) #10
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]),:(x[4])]) #11
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[2]),:(x[10]),:(x[11])]) #12
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[4]),:(x[8]),:(x[10])]) #13
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]),:(x[3]),:(x[6]),:(x[11])]) #14
        @test haskey(m.internalModel.nonlinear_terms, [:(x[6]),:(x[8]),:(x[10]),:(x[11])]) #15

        @test m.internalModel.nonlinear_terms[[:(x[1]),:(x[2]),:(x[3]),:(x[4])]][:id] == 1 #5
        @test m.internalModel.nonlinear_terms[[:(x[1]),:(x[1])]][:id] == 2 #6
        @test m.internalModel.nonlinear_terms[[:(x[2]),:(x[3]),:(x[4]),:(x[6])]][:id] == 3 #7
        @test m.internalModel.nonlinear_terms[[:(x[2]),:(x[2])]][:id] == 4 #8
        @test m.internalModel.nonlinear_terms[[:(x[1]),:(x[3]),:(x[4]),:(x[8])]][:id] == 5 #9
        @test m.internalModel.nonlinear_terms[[:(x[3]),:(x[3])]][:id] == 6 #10
        @test m.internalModel.nonlinear_terms[[:(x[4]),:(x[4])]][:id] == 7 #11
        @test m.internalModel.nonlinear_terms[[:(x[1]),:(x[2]),:(x[10]),:(x[11])]][:id] ==  8  #12
        @test m.internalModel.nonlinear_terms[[:(x[1]),:(x[4]),:(x[8]),:(x[10])]][:id] == 9 #13
        @test m.internalModel.nonlinear_terms[[:(x[2]),:(x[3]),:(x[6]),:(x[11])]][:id] == 10 #14
        @test m.internalModel.nonlinear_terms[[:(x[6]),:(x[8]),:(x[10]),:(x[11])]][:id] == 11 #15
    end

    @testset "Expression parsing || part8" begin
        m = Model(solver=PODSolver(nlp_local_solver=IpoptSolver(),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0))
        @variable(m, x[1:4]>=0)

        @NLconstraint(m, (x[1]*x[2]*x[3])*x[4] >= 1)
        @NLconstraint(m, (x[1]^2*x[2]*x[3])*x[4] >= 1)
        @NLconstraint(m, x[1]*(x[2]^2*x[3])*x[4] >= 1)
        @NLconstraint(m, x[1]*(x[2]*x[3]^2)*x[4] >= 1)
        @NLconstraint(m, (x[1]*x[2]^2)*x[3]*x[4] >= 1)
        @NLconstraint(m, (x[1]*x[2])*x[3]^2*x[4] >= 1)
        @NLconstraint(m, (x[1]*x[2])*x[3]*x[4]^2 >= 1)
        @NLconstraint(m, (x[1]*x[2])*x[3]^2*x[4]^2 >= 1)
        @NLconstraint(m, (x[1]^2*x[2]^2*x[3]^2)*x[4]^2 >= 1)

        JuMP.build(m)

        @test m.internalModel.bounding_constr_expr_mip[1] == :(x[6]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[2] == :(x[9]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[3] == :(x[12]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[4] == :(x[15]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[5] == :(x[17]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[6] == :(x[19]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[7] == :(x[21]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[8] == :(x[22]-1.0 >= 0.0)
        @test m.internalModel.bounding_constr_expr_mip[9] == :(x[24]-1.0 >= 0.0)

        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[2]),:(x[3])]) #5
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]),:(x[5])]) #6
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[1])]) #7
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]),:(x[3]),:(x[7])]) #8
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]),:(x[8])]) #9
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]),:(x[2])]) #10
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]),:(x[10])]) #11
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[4]),:(x[11])]) #12
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]),:(x[3])]) #13
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]),:(x[13])]) #14
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[4]),:(x[14])]) #15
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[10])]) #16
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]),:(x[4]),:(x[16])]) #17
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]),:(x[2])]) #18
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]),:(x[18]),:(x[13])]) #19
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]),:(x[4])]) #20
        @test haskey(m.internalModel.nonlinear_terms, [:(x[3]),:(x[18]),:(x[20])]) #21
        @test haskey(m.internalModel.nonlinear_terms, [:(x[18]),:(x[13]),:(x[20])]) #22
        @test haskey(m.internalModel.nonlinear_terms, [:(x[7]),:(x[10]),:(x[13])]) #23
        @test haskey(m.internalModel.nonlinear_terms, [:(x[23]),:(x[20])]) #24
    end

    @testset "Convex Parsing" begin
        m = Model(solver=PODSolver(nlp_local_solver=IpoptSolver(),
                           mip_solver=CbcSolver(OutputFlag=0),
                           log_level=0))


        @variable(m, 0<=x[1:5]<=2)

        @constraint(m, 3*x[1]*x[1] + 4*x[2]*x[2] <= 25)                             # 1: true
        @constraint(m, 3*x[1]*x[1] - 25 + 4*x[2]*x[2] <= 0)                         # 2: true
        @constraint(m, 3(x[1]x[1]) + 4*x[2]*x[2] <= -5)                             # 3: false
        @constraint(m, 3(x[1]x[1]) + 4*x[2]^2 <= 10)                                # 4: true
        @constraint(m, 3x[1]^2 + 4x[2]^2 + 6x[3]^2 <= 10)                           # 5: true

        @NLconstraint(m, 3x[1]^0.5 + 4x[2]^0.5 + 5x[5]^0.5 <= 100)					# 6: true | type-C
        @NLconstraint(m, -3x[1]^0.5 -4x[2]^0.5 >= -100)								# 7: true | type-C
        @NLconstraint(m, 3x[1]^3 + x[2]^3 + 5x[3]^3 <= 200)                         # 8: true | type-a
        @NLconstraint(m, x[1]*x[1]*x[1] + x[2]*x[2]*x[2] + x[3]*x[3]*x[3] + 5*x[4]*20*x[4]*x[4] <= 200) # 9: true
        @NLconstraint(m, 3*x[1]*x[1] + 4*x[2]*x[2] <= 25)                           # 10: true

        @NLconstraint(m, (3*x[1]*x[1] + 4*x[2]*x[2]) <= 25)                         # 11: true
        @NLconstraint(m, 3*x[1]*x[1] + 4*x[2]*x[2] - 25 <= 0)                       # 12: true
        @NLconstraint(m, -3*x[1]*x[1] -4*x[2]*x[2] >= -25)                          # 13: true
        @NLconstraint(m, 3*x[1]*x[1] + 5x[2]*x[2] <= 25)                            # 14: true
        @NLconstraint(m, x[1]*3*x[1] + x[2]*x[2]*5 + x[4]^(3-1) <= 25)              # 15: true

        @NLconstraint(m, 4*x[1]^2 + 5x[2]^2 <= 25)                                  # 16: true
        @NLconstraint(m, 3*x[1]*x[1] - 25 + 4*x[2]*x[2] <= 0)                       # 17: false (unsupported when with @NLconstraint)
        @NLconstraint(m, 3*x[1]*x[1] + 4*x[2]*x[1] <= 25)                           # 18: false
        @NLconstraint(m, 3*x[1]*x[1] + 16*x[2]^2 <= 40)                             # 19: true
        @NLconstraint(m, 3*x[1]^2 + 16*x[2]^2 + 17 <= 16)                           # 20: false

        @NLconstraint(m, 3*x[1]^3 + 16*x[2]^2 <= 20 - 20)                           # 21: false
        @NLconstraint(m, 3*x[1]*x[1] + 4*x[2]*x[2] + 5*x[3]*x[3] + 6x[4]x[4] <= 15) # 22: true
        @NLconstraint(m, 3x[1]x[1] + 4x[2]x[2] + 5x[3]^2 <= -15)                    # 23: false
        @NLconstraint(m, 3x[1]^2 + 4x[2]^2 >= 15)                                   # 24: false
        @NLconstraint(m, sum(x[i]^2 for i in 1:5) <= 99999)                         # 25: true

        @NLconstraint(m, 3x[1]^4 + 4x[2]^4 <= 200)                                  # 26: true
        @NLconstraint(m, 3x[1]^4 + 4x[2]x[2]x[2]x[2] - 200 <= 0)                    # 27: true
        @NLconstraint(m, 3x[1]^4 + 4x[2]^2*x[2]*x[2] <= 200)                        # 28: true
        @NLconstraint(m, 3x[1]^4 + 4x[2]^3 <= 200)                                  # 29: false
        @NLconstraint(m, 3x[1]^8 + 16*25*x[2]^8 - 30x[3]^8 <= 50)                   # 30: false

        @objective(m, Max, x[1]^2+x[3]^2)                                           # true

        JuMP.build(m)

        @test m.internalModel.num_constr_convex == 21

        # 0 : OBJ
        @test m.internalModel.structural_obj == :convex
        @test m.internalModel.nonlinear_constrs[0][:expr_orig] == :objective
        @test m.internalModel.nonlinear_constrs[0][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[0][:convexified] == false

        @test m.internalModel.bounding_obj_mip[:sense] == nothing
        @test m.internalModel.bounding_obj_mip[:coefs] == [1.0, 1.0]
        @test m.internalModel.bounding_obj_mip[:vars] == [:(x[1]), :(x[3])]
        @test m.internalModel.bounding_obj_mip[:rhs] == 0.0
        @test m.internalModel.bounding_obj_mip[:powers] == [2, 2]
        @test m.internalModel.bounding_obj_mip[:cnt] == 2

        # 1
        @test m.internalModel.structural_constr[1] == :convex
        @test m.internalModel.nonlinear_constrs[1][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[1][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[1][:convexified] == false
        @test m.internalModel.bounding_constr_mip[1][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[1][:coefs] == [3.0, 4.0]
        @test m.internalModel.bounding_constr_mip[1][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[1][:rhs] == 25.0
        @test m.internalModel.bounding_constr_mip[1][:powers] == [2, 2]
        @test m.internalModel.bounding_constr_mip[1][:cnt] == 2

        # 2
        @test m.internalModel.structural_constr[2] == :convex
        @test m.internalModel.nonlinear_constrs[2][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[2][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[2][:convexified] == false
        @test m.internalModel.bounding_constr_mip[2][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[2][:coefs] == [3.0, 4.0]
        @test m.internalModel.bounding_constr_mip[2][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[2][:rhs] == 25.0
        @test m.internalModel.bounding_constr_mip[2][:powers] == [2, 2]
        @test m.internalModel.bounding_constr_mip[2][:cnt] == 2

        # 4
        @test m.internalModel.structural_constr[4] == :convex
        @test m.internalModel.nonlinear_constrs[4][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[4][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[4][:convexified] == false
        @test m.internalModel.bounding_constr_mip[4][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[4][:coefs] == [3.0, 4.0]
        @test m.internalModel.bounding_constr_mip[4][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[4][:rhs] == 10.0
        @test m.internalModel.bounding_constr_mip[4][:powers] == [2, 2]
        @test m.internalModel.bounding_constr_mip[4][:cnt] == 2

        # 5
        @test m.internalModel.structural_constr[5] == :convex
        @test m.internalModel.nonlinear_constrs[5][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[5][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[5][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[5][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[5][:coefs] == [3.0, 4.0, 6.0]
        @test m.internalModel.bounding_constr_mip[5][:vars] == [:(x[1]), :(x[2]), :(x[3])]
        @test m.internalModel.bounding_constr_mip[5][:rhs] == 10.0
        @test m.internalModel.bounding_constr_mip[5][:powers] == [2, 2, 2]
        @test m.internalModel.bounding_constr_mip[5][:cnt] == 3

        # 6
        @test m.internalModel.structural_constr[6] == :convex
        @test m.internalModel.nonlinear_constrs[6][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[6][:convex_type] == :convexC
        @test m.internalModel.nonlinear_constrs[6][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[6][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[6][:coefs] == [3.0, 4.0, 5.0]
        @test m.internalModel.bounding_constr_mip[6][:vars] == [:(x[1]), :(x[2]), :(x[5])]
        @test m.internalModel.bounding_constr_mip[6][:rhs] == 100.0
        @test m.internalModel.bounding_constr_mip[6][:powers] == [0.5, 0.5, 0.5]
        @test m.internalModel.bounding_constr_mip[6][:cnt] == 3

        # 7
        @test m.internalModel.structural_constr[7] == :convex
        @test m.internalModel.nonlinear_constrs[7][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[7][:convex_type] == :convexC
        @test m.internalModel.nonlinear_constrs[7][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[7][:sense] == :(>=)
        @test m.internalModel.bounding_constr_mip[7][:coefs] == [-3.0, -4.0]
        @test m.internalModel.bounding_constr_mip[7][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[7][:rhs] == -100.0
        @test m.internalModel.bounding_constr_mip[7][:powers] == [0.5, 0.5]
        @test m.internalModel.bounding_constr_mip[7][:cnt] == 2

        # 8
        @test m.internalModel.structural_constr[8] == :convex
        @test m.internalModel.nonlinear_constrs[8][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[8][:convex_type] == :convexB
        @test m.internalModel.nonlinear_constrs[8][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[8][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[8][:coefs] == [3.0, 1.0, 5.0]
        @test m.internalModel.bounding_constr_mip[8][:vars] == [:(x[1]), :(x[2]), :(x[3])]
        @test m.internalModel.bounding_constr_mip[8][:rhs] == 200.0
        @test m.internalModel.bounding_constr_mip[8][:powers] == [3.0, 3.0, 3.0]
        @test m.internalModel.bounding_constr_mip[8][:cnt] == 3

        # 9
        @test m.internalModel.structural_constr[9] == :convex
        @test m.internalModel.nonlinear_constrs[9][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[9][:convex_type] == :convexB
        @test m.internalModel.nonlinear_constrs[9][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[9][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[9][:coefs] == [1.0, 1.0, 1.0, 100.0]
        @test m.internalModel.bounding_constr_mip[9][:vars] == [:(x[1]), :(x[2]), :(x[3]), :(x[4])]
        @test m.internalModel.bounding_constr_mip[9][:rhs] == 200.0
        @test m.internalModel.bounding_constr_mip[9][:powers] == [3, 3, 3, 3]
        @test m.internalModel.bounding_constr_mip[9][:cnt] == 4

        # 11
        @test m.internalModel.structural_constr[11] == :convex
        @test m.internalModel.nonlinear_constrs[11][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[11][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[11][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[11][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[11][:coefs] == [3.0, 4.0]
        @test m.internalModel.bounding_constr_mip[11][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[11][:rhs] == 25.0
        @test m.internalModel.bounding_constr_mip[11][:powers] == [2, 2]
        @test m.internalModel.bounding_constr_mip[11][:cnt] == 2

        # 14
        @test m.internalModel.structural_constr[14] == :convex
        @test m.internalModel.nonlinear_constrs[14][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[14][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[14][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[14][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[14][:coefs] == [3.0, 5.0]
        @test m.internalModel.bounding_constr_mip[14][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[14][:rhs] == 25.0
        @test m.internalModel.bounding_constr_mip[14][:powers] == [2, 2]
        @test m.internalModel.bounding_constr_mip[14][:cnt] == 2

        # 15
        @test m.internalModel.structural_constr[15] == :convex
        @test m.internalModel.nonlinear_constrs[15][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[15][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[15][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[15][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[15][:coefs] == [3.0, 5.0, 1.0]
        @test m.internalModel.bounding_constr_mip[15][:vars] == [:(x[1]), :(x[2]), :(x[4])]
        @test m.internalModel.bounding_constr_mip[15][:rhs] == 25.0
        @test m.internalModel.bounding_constr_mip[15][:powers] == [2, 2, 2]
        @test m.internalModel.bounding_constr_mip[15][:cnt] == 3

        # 19
        @test m.internalModel.structural_constr[19] == :convex
        @test m.internalModel.nonlinear_constrs[19][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[19][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[19][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[19][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[19][:coefs] == [3.0, 16.0]
        @test m.internalModel.bounding_constr_mip[19][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[19][:rhs] == 40.0
        @test m.internalModel.bounding_constr_mip[19][:powers] == [2, 2]
        @test m.internalModel.bounding_constr_mip[19][:cnt] == 2

        # 22
        @test m.internalModel.structural_constr[22] == :convex
        @test m.internalModel.nonlinear_constrs[22][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[22][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[22][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[22][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[22][:coefs] == [3.0, 4.0, 5.0, 6.0]
        @test m.internalModel.bounding_constr_mip[22][:vars] == [:(x[1]), :(x[2]), :(x[3]), :(x[4])]
        @test m.internalModel.bounding_constr_mip[22][:rhs] == 15.0
        @test m.internalModel.bounding_constr_mip[22][:powers] == [2, 2, 2, 2]
        @test m.internalModel.bounding_constr_mip[22][:cnt] == 4

        # 25
        @test m.internalModel.structural_constr[25] == :convex
        @test m.internalModel.nonlinear_constrs[25][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[25][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[25][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[25][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[25][:coefs] == [1.0, 1.0, 1.0, 1.0, 1.0]
        @test m.internalModel.bounding_constr_mip[25][:vars] == [:(x[1]), :(x[2]), :(x[3]), :(x[4]), :(x[5])]
        @test m.internalModel.bounding_constr_mip[25][:rhs] == 99999.0
        @test m.internalModel.bounding_constr_mip[25][:powers] == [2, 2, 2, 2, 2]
        @test m.internalModel.bounding_constr_mip[25][:cnt] == 5

        # 26
        @test m.internalModel.structural_constr[26] == :convex
        @test m.internalModel.nonlinear_constrs[26][:expr_orig] == :constraints
        @test m.internalModel.nonlinear_constrs[26][:convex_type] == :convexA
        @test m.internalModel.nonlinear_constrs[26][:convexified] == :false
        @test m.internalModel.bounding_constr_mip[26][:sense] == :(<=)
        @test m.internalModel.bounding_constr_mip[26][:coefs] == [3.0, 4.0]
        @test m.internalModel.bounding_constr_mip[26][:vars] == [:(x[1]), :(x[2])]
        @test m.internalModel.bounding_constr_mip[26][:rhs] == 200.0
        @test m.internalModel.bounding_constr_mip[26][:powers] == [4, 4]
        @test m.internalModel.bounding_constr_mip[26][:cnt] == 2
    end

    @testset "Linear Lifting : nlp2" begin
        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=PajaritoSolver(mip_solver=CbcSolver(),cont_solver=IpoptSolver(print_level=0), log_level=0),
                               log_level=0)

        m = nlp2(solver=test_solver)

        JuMP.build(m) #

        @test length(m.internalModel.linear_terms) == 2
        @test length(m.internalModel.nonlinear_terms) == 4
        l_key1 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, -1.0),Pair{Symbol,Any}(:coef_var, Set(Any[(1.0, 3)])))
        l_key2 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, -2.0),Pair{Symbol,Any}(:coef_var, Set(Any[(1.0, 6)])))
        @test haskey(m.internalModel.linear_terms, l_key1)
        @test haskey(m.internalModel.linear_terms, l_key2)
        @test m.internalModel.linear_terms[l_key1][:id] == 1
        @test m.internalModel.linear_terms[l_key2][:id] == 2
        @test m.internalModel.linear_terms[l_key1][:lifted_constr_ref] == :(x[4] == x[3] - 1.0)
        @test m.internalModel.linear_terms[l_key2][:lifted_constr_ref] == :(x[7] == x[6] - 2.0)
        @test m.internalModel.linear_terms[l_key1][:lifted_var_ref].args[2] == 4
        @test m.internalModel.linear_terms[l_key2][:lifted_var_ref].args[2] == 7
        @test m.internalModel.linear_terms[l_key1][:y_idx] == 4
        @test m.internalModel.linear_terms[l_key2][:y_idx] == 7
        @test haskey(m.internalModel.nonlinear_terms, [:(x[2]), :(x[2])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[4]), :(x[4])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[7]), :(x[7])])
        @test haskey(m.internalModel.nonlinear_terms, [:(x[1]), :(x[1])])
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[1])]][:id] == 1
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[2])]][:id] == 3
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[4])]][:id] == 2
        @test m.internalModel.nonlinear_terms[[:(x[7]), :(x[7])]][:id] == 4
        @test m.internalModel.nonlinear_terms[[:(x[1]), :(x[1])]][:lifted_var_ref].args[2] == 3
        @test m.internalModel.nonlinear_terms[[:(x[2]), :(x[2])]][:lifted_var_ref].args[2] == 6
        @test m.internalModel.nonlinear_terms[[:(x[4]), :(x[4])]][:lifted_var_ref].args[2] == 5
        @test m.internalModel.nonlinear_terms[[:(x[7]), :(x[7])]][:lifted_var_ref].args[2] == 8

        # @test isapprox(m.objVal, 0.0; atol=1e-5)
    end

    @testset "Linear Lifting : general" begin
        test_solver = PODSolver(nlp_local_solver=IpoptSolver(print_level=0),
                               mip_solver=CbcSolver(OutputFlag=0),
                               log_level=0)

        m = basic_linear_lift(solver=test_solver)

        JuMP.build(m) # Setup internal model

        lk1 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, 3.0),Pair{Symbol,Any}(:coef_var, Set(Any[(1.0, 2), (1.0, 1), (1.0, 3)])))
        lk2 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, 0.0),Pair{Symbol,Any}(:coef_var, Set(Any[(3.0, 2), (-1.0, 3)])))
        lk3 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, 0.0),Pair{Symbol,Any}(:coef_var, Set(Any[(1.0, 1), (-1.0, 2)])))
        lk4 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, 0.0),Pair{Symbol,Any}(:coef_var, Set(Any[(1.0, 1), (1.0, 3)])))
        lk5 = Dict{Symbol,Any}(Pair{Symbol,Any}(:sign, :+),Pair{Symbol,Any}(:scalar, 0.0),Pair{Symbol,Any}(:coef_var, Set(Any[(1.0, 2), (1.0, 1)])))

        @test m.internalModel.linear_terms[lk1][:y_idx] == 16
        @test m.internalModel.linear_terms[lk2][:y_idx] == 9
        @test m.internalModel.linear_terms[lk3][:y_idx] == 8
        @test m.internalModel.linear_terms[lk4][:y_idx] == 12
        @test m.internalModel.linear_terms[lk5][:y_idx] == 14

        @test m.internalModel.linear_terms[lk1][:lifted_var_ref].args[2] == 16
        @test m.internalModel.linear_terms[lk2][:lifted_var_ref].args[2] == 9
        @test m.internalModel.linear_terms[lk3][:lifted_var_ref].args[2] == 8
        @test m.internalModel.linear_terms[lk4][:lifted_var_ref].args[2] == 12
        @test m.internalModel.linear_terms[lk5][:lifted_var_ref].args[2] == 14

        @test m.internalModel.linear_terms[lk1][:id] == 5
        @test m.internalModel.linear_terms[lk2][:id] == 2
        @test m.internalModel.linear_terms[lk3][:id] == 1
        @test m.internalModel.linear_terms[lk4][:id] == 3
        @test m.internalModel.linear_terms[lk5][:id] == 4

        nlk1 = [:(x[8]), :(x[9]), :(x[12])]
        nlk2 = [:(x[2]), :(x[2])]
        nlk3 = [:(x[2]), :(x[3])]
        nlk4 = [:(x[8]), :(x[8])]
        nlk5 = [:(x[1]), :(x[3])]
        nlk6 = [:(x[8]), :(x[9])]
        nlk7 = [:(x[1]), :(x[2])]
        nlk8 = [:(x[16]), :(x[15])]
        nlk9 = [:(x[14]), :(x[14])]

        @test m.internalModel.nonlinear_terms[nlk1][:id] == 7
        @test m.internalModel.nonlinear_terms[nlk2][:id] == 3
        @test m.internalModel.nonlinear_terms[nlk3][:id] == 4
        @test m.internalModel.nonlinear_terms[nlk4][:id] == 6
        @test m.internalModel.nonlinear_terms[nlk5][:id] == 2
        @test m.internalModel.nonlinear_terms[nlk6][:id] == 5
        @test m.internalModel.nonlinear_terms[nlk7][:id] == 1
        @test m.internalModel.nonlinear_terms[nlk8][:id] == 9
        @test m.internalModel.nonlinear_terms[nlk9][:id] == 8

        @test m.internalModel.nonlinear_terms[nlk1][:lifted_var_ref].args[2] == 13
        @test m.internalModel.nonlinear_terms[nlk2][:lifted_var_ref].args[2] == 6
        @test m.internalModel.nonlinear_terms[nlk3][:lifted_var_ref].args[2] == 7
        @test m.internalModel.nonlinear_terms[nlk4][:lifted_var_ref].args[2] == 11
        @test m.internalModel.nonlinear_terms[nlk5][:lifted_var_ref].args[2] == 5
        @test m.internalModel.nonlinear_terms[nlk6][:lifted_var_ref].args[2] == 10
        @test m.internalModel.nonlinear_terms[nlk7][:lifted_var_ref].args[2] == 4
        @test m.internalModel.nonlinear_terms[nlk8][:lifted_var_ref].args[2] == 17
        @test m.internalModel.nonlinear_terms[nlk9][:lifted_var_ref].args[2] == 15

        @test m.internalModel.nonlinear_terms[nlk1][:nonlinear_type] == :multilinear
        @test m.internalModel.nonlinear_terms[nlk2][:nonlinear_type] == :monomial
        @test m.internalModel.nonlinear_terms[nlk3][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[nlk4][:nonlinear_type] == :monomial
        @test m.internalModel.nonlinear_terms[nlk5][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[nlk6][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[nlk7][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[nlk8][:nonlinear_type] == :bilinear
        @test m.internalModel.nonlinear_terms[nlk9][:nonlinear_type] == :monomial

        @test m.internalModel.nonlinear_terms[nlk1][:orig_vars] == [8,9,12]
        @test m.internalModel.nonlinear_terms[nlk2][:orig_vars] == [2]
        @test m.internalModel.nonlinear_terms[nlk3][:orig_vars] == [2,3]
        @test m.internalModel.nonlinear_terms[nlk4][:orig_vars] == [8]
        @test m.internalModel.nonlinear_terms[nlk5][:orig_vars] == [1,3]
        @test m.internalModel.nonlinear_terms[nlk6][:orig_vars] == [8,9]
        @test m.internalModel.nonlinear_terms[nlk7][:orig_vars] == [1,2]
        @test m.internalModel.nonlinear_terms[nlk8][:orig_vars] == [16, 15]
        @test m.internalModel.nonlinear_terms[nlk9][:orig_vars] == [14]
    end

end
