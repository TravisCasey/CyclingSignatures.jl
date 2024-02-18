include("../../src/CyclingSignatures-include-file.jl")

using JLD2

rossler_data = load("examples/Rossler/rossler-timeseries.jld2")
Y_vec = rossler_data["space_data"]
Z_vec = rossler_data["veloc_data"]
t_vec = rossler_data["time_data"]

boxsize = 8
sb_radius = 3

ts = trajectoryToTrajectorySpaceSB(Y_vec,
                                   Z_vec,
                                   boxsize,
                                   sb_radius,
                                   t_vec = t_vec,
                                   filter_missing=true,
                                   shortest_path_fix=true)

n = 50
experiment_params = map(i->SubsegmentSampleParameter(i,n), 10:10:250)

experiments = map(experiment_params) do p
    RandomSubsegmentExperiment(ts, p, boxsize)
end

times, results = runExperimentsWithTimer(experiments)

jldsave("examples/Rossler/rossler-results.jld2", results=results, times=times)
