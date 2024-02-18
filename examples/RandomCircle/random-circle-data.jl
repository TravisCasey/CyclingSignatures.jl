using JLD2

using LinearAlgebra

# Parameters

n = 10000
r₀ = 1.0
θ₀ = 0.0
Δr = 0.0
Δθ = 0.1
σr = 0.1
σθ = 0.2

# Deterministic Generation

if Δr == 0
    rd_vec = fill(r₀, n+1)
else
    rd_vec = Vector(r₀:Δr:r₀+n*Δr)
end

if Δθ == 0
    θd_vec = fill(θ₀, n+1)
else
    θd_vec = Vector(θ₀:Δθ:θ₀+n*Δθ)
end

# Generate Random Perturbations

rp_vec = rd_vec + σr * randn(n+1)
θp_vec = θd_vec + σθ * randn(n+1)

# Calculate Rectangular Coordinates

x_vec = rp_vec .* cos.(θp_vec)
y_vec = rp_vec .* sin.(θp_vec)
space_vec = [x_vec y_vec]

# Calculate Normalized Differences

veloc_vec = mapslices(normalize, space_vec[2:end,:]-space_vec[1:end-1,:], dims=2)
sb_timeseries = [space_vec[1:end-1,:] veloc_vec]

jldsave("examples/RandomCircle/random-circle-timeseries.jld2",
        space_data=space_vec[1:end-1,:],
        veloc_data=veloc_vec)
