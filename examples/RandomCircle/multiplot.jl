include("random-circle-data.jl")
include("../../src/CyclingSignatures-include-file.jl")
using GLMakie
using Colors
using ColorSchemes

function run_experiment(traj, boxsize)
    sb_boxsize = 0
    n = 50
    ts = trajectoryToTrajectorySpaceSB(traj[:,1:2]',
                                       traj[:,3:4]',
                                       boxsize,
                                       sb_boxsize,
                                       filter_missing=true,
                                       shortest_path_fix=true)
    experiment_params = map(i->SubsegmentSampleParameter(i,n), 100:100:3000)
    experiments = map(experiment_params) do p
        RandomSubsegmentExperiment(ts, p, boxsize)
    end
    _, results = runExperimentsWithTimer(experiments, Val(:DistanceMatrix))
    return results
end

function generate_multiplot_data(r_sd_list, boxsize_list; points = 10000, resamp = 4)
    results_dict = Dict()
    for r_sd in r_sd_list
        circle_data = rc_data_gen(;r_sd=r_sd, n = points, resamp = resamp)
        for boxsize in boxsize_list
            results_dict[(r_sd, boxsize)] = SubsegmentResultReduced.(run_experiment(circle_data, boxsize))
        end
    end
    jldsave("examples/RandomCircle/multiplot-results.jld2", results=results_dict)
end

function display_multiplot(r_sd_disp, boxsize_disp)
    results_dict = load("examples/RandomCircle/multiplot-results.jld2", "results")

    fig = Figure()
    for (i, r_sd) in enumerate(r_sd_disp)
        for (j, boxsize) in enumerate(boxsize_disp)
            g = fig[i, j] = GridLayout()
            plotRanksWithLegend(results_dict[(r_sd, boxsize)], boxsize; gl=g)
        end
    end
    display(fig)
end
