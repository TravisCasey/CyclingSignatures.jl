using JLD2
using LinearAlgebra
using GLMakie
using Printf

function rc_data_gen(;
    n = 10000,
    r0 = 1.0,
    θ0 = 0.0,
    Δr = 0.0,
    Δθ = 0.1,
    r_sd = 0.0,
    θ_sd = 0.0,
    resamp_radius = 0.04
)
    # Deterministic Generation
    if Δr == 0
        rd_vec = fill(r0, n+1)
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

    # Add intermediate points for dynamical consistency
    resamp_space_vec = Matrix{Float64}(undef, 0, 2)
    resamp_space_vec = [resamp_space_vec; space_vec[1,:]']
    t_vec = [1]
    for row in axes(space_vec, 1)[2:end]
        diff = space_vec[row,:] - space_vec[row-1,:]
        N = ceil(norm(diff)/resamp_radius) # Insert N - 1 intermediate points
        step = diff / N
        for i in 1:N
            resamp_space_vec = [resamp_space_vec; (space_vec[row-1,:] + i * step)']
        end
        push!(t_vec, t_vec[end] + N)
    end
    push!(t_vec, t_vec[end] + 1) # Not sure why this is needed but it is
    @printf("Inserted %d points", size(resamp_space_vec, 1) - size(space_vec, 1))

    # Calculate Normalized Differences
    vf_vec = mapslices(normalize, resamp_space_vec[2:end,:]-resamp_space_vec[1:end-1,:], dims=2)
    vf_vec = [vf_vec; vf_vec[end,:]'] # Fixes t_vec issues when removing last point
    return hcat(resamp_space_vec, vf_vec), t_vec
end
