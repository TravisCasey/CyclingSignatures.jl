include("../../src/CyclingSignatures-include-file.jl")

using DynamicalSystems
using JLD2

function RosslerRule(u, p, t)
    x, y, z = u[1], u[2], u[3]
    a, b, c = p
    dx = -y - z
    dy = x + a * y
    dz = b + z * (x - c)
    return SVector(dx, dy, dz)
end

u0 = [4.0, 0.0, 0.0]
p = [0.1, 0.1, 14]
Δt = 0.5
total_time = 5000

rossler_system = CoupledODEs(RosslerRule, u0, p)
sol, _ = trajectory(rossler_system, total_time, Δt=Δt)

Y_init = Matrix(sol[:,:])'[:,100:end]
resample_boxsize = 4
resample_sb_radius = 8
Rossler_v(u) = RosslerRule(u, p, 0)


Y_res, t_vec = resampleToConsistent(rossler_system,
                                    Y_init,
                                    resample_boxsize,
                                    Δt,
                                    sb_radius = resample_sb_radius,
                                    sb_fct=Rossler_v)
Z_res = mapslices(u->normalize(Rossler_v(u), 2), Y_res, dims=[1])

jldsave("examples/Rossler/rossler-timeseries.jld2",
        space_data = Y_res,
        veloc_data = Z_res,
        time_data = t_vec)
