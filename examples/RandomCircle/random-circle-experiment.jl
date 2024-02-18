include("../../src/CyclingSignatures-include-file.jl")

using JLD2

timeseries = load("examples/RandomCircle/random-circle-timeseries.jld2")
boxsize = 0.3
sb_boxsize = 4
ts = trajectoryToTrajectorySpaceSB(timeseries["space_data"]',
                                           timeseries["veloc_data"]',
                                           boxsize,
                                           sb_boxsize,
                                           filter_missing=true,
                                           shortest_path_fix=true)

n = 40
experiment_params = map(i->SubsegmentSampleParameter(i,n), 10:10:200)

experiments = map(experiment_params) do p
    RandomSubsegmentExperiment(ts, p, boxsize)
end

times, results = runExperimentsWithTimer(experiments, Val(:DistanceMatrix));
jldsave("examples/RandomCircle/random-circle-results.jld2",
        results=results,
        times=times)
