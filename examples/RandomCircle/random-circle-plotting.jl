include("../../src/CyclingSignatures-include-file.jl")
using JLD2
using Colors
using ColorSchemes

results = SubsegmentResultReduced.(load("examples/RandomCircle/random-circle-results.jld2", "results"));

r = 0.25
rankFig = plotRanksWithLegend(results, r)
#sig1Fig = plotSignaturesWithLegend(results, 1, r; cutoff=50)
#sig2Fig = plotSignaturesWithLegend(results, 2, r; cutoff=100, legend_kwargs=(;nbanks=10))
#inclFig = plotSubspaceInclusion(results, 1, 2, r; cutoff1=200, cutoff2=200)

#figCombined = Figure(res=(1000,600),fontsize=18)
#g11 = figCombined[1,1] = GridLayout()
#g12 = figCombined[1,2] = GridLayout()
#g21 = figCombined[2,1] = GridLayout()
#g22 = figCombined[2,2]
#plotRanksWithLegend(results, r; gl=g11)
#plotSignaturesWithLegend(results, 1, r; gl=g12, cutoff=20)
#plotSignaturesWithLegend(results, 2, r; gl=g21, cutoff=50, legend_kwargs=(;nbanks=5))
#plotSubspaceInclusion(results, 1, 2, r; gp=g22, cutoff1=20, cutoff2=50, axis_kwargs=(;limits=(.5,5.5,.8,2.2)))
