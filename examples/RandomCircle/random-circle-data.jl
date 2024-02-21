using JLD2
using LinearAlgebra
using GLMakie


function rc_data_gen(;
    n = 10000,
    r0 = 1.0,
    θ0 = 0.0,
    Δr = 0.0,
    Δθ = 0.1,
    r_sd = 0.0,
    θ_sd = 0.0
)
    # Deterministic Generation
    if Δr == 0
        rd_vec = fill(r₀, n+1)
    else
        rd_vec = Vector(r0:Δr:r0+n*Δr)
    end
    if Δθ == 0
        θd_vec = fill(θ0, n+1)
    else
        θd_vec = Vector(θ0:Δθ:θ0+n*Δθ)
    end

    # Generate Random Perturbations
    rp_vec = rd_vec + r_sd * randn(n+1)
    θp_vec = θd_vec + θ_sd * randn(n+1)

    # Calculate Rectangular Coordinates
    x_vec = rp_vec .* cos.(θp_vec)
    y_vec = rp_vec .* sin.(θp_vec)
    space_vec = [x_vec y_vec]

    # Calculate Normalized Differences
    vf_vec = mapslices(normalize, space_vec[2:end,:]-space_vec[1:end-1,:], dims=2)
    return [space_vec[1:end-1,:] vf_vec]
end

# Parameters

n = 10000
r₀ = 1.0
θ₀ = 0.0
Δr = 0.0
Δθ = 0.1
σr = 0.2
σθ = 0.0

jldsave("examples/RandomCircle/random-circle-timeseries.jld2",
        space_data=space_vec[1:end-1,:],
        veloc_data=veloc_vec)

scatter(space_vec[1:end-1,:])
