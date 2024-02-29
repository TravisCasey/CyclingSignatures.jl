include("random-circle-data.jl")
include("../../src/CyclingSignatures-include-file.jl")
using GLMakie
using Colors
using ColorSchemes

function run_experiment(traj, boxsize; t_vec = nothing)
    sb_boxsize = 0
    n = 100
    ts = trajectoryToTrajectorySpaceSB(traj[:,1:2]',
                                       traj[:,3:4]',
                                       boxsize,
                                       sb_boxsize;
                                       t_vec = t_vec,
                                       filter_missing=true,
                                       shortest_path_fix=true)
    experiment_params = map(i->SubsegmentSampleParameter(i,n), 10:10:200)
    experiments = map(experiment_params) do p
        RandomSubsegmentExperiment(ts, p, boxsize)
    end
    _, results = runExperimentsWithTimer(experiments, Val(:DistanceMatrix))
    return results
end

function generate_multiplot_data(r_sd_list, boxsize_list; points = 10000, resamp_radius = 0.04)
    results_dict = Dict()
    for r_sd in r_sd_list
        circle_data, t_data = rc_data_gen(;r_sd=r_sd, n = points, resamp_radius = resamp_radius)
        for boxsize in boxsize_list
            results_dict[(r_sd, boxsize)] = SubsegmentResultReduced.(run_experiment(circle_data, boxsize; t_vec = t_data))
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
