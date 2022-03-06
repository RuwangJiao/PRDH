classdef CNSGAII3 < ALGORITHM
% <multi> <real/binary/permutation> <constrained/none>
% Nondominated sorting genetic algorithm II  3,7,11,14,17,21,23,24,25,27,30,31,38,46,56
%7,11,17,21,23,24,25,27,29,30,31,33,37,38,45,53,56,59
% 3,7,11,14,17,21,23,24,25,27,29,30,31,33,37,38,45,46,53,56,59
%------------------------------- Reference --------------------------------
% K. Deb, A. Pratap, S. Agarwal, and T. Meyarivan, A fast and elitist
% multiobjective genetic algorithm: NSGA-II, IEEE Transactions on
% Evolutionary Computation, 2002, 6(2): 182-197.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2021 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    methods
        function main(Algorithm,Problem)
            %% Setting population size and maxFE for fair comparison %%
            [Problem.N, Problem.maxFE] = InitialExperimentSetting(Problem);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %% Generate random population
            Population = InitializationM(Problem, Problem.N);
            %Population = Problem.Initialization();
            [~,FrontNo,CrowdDis] = Environmental(Population,Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                Offspring  = OffspringReproduction(Population(MatingPool));
                [Population,FrontNo,CrowdDis] = EnvironmentalSelection([Population,Offspring],Problem.N);

                %%%%% Applied to the test set %%%%%
                %diversity = DiversityMeasure(Population);
                %disp(diversity);
                Population = FSTest(Problem, Population);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        end
    end
end

function Population = InitializationM(obj, N)
    PopDec = randi([0,1], N, obj.D);
    PopDec(N,:) = zeros(1, obj.D);
    j = randperm(obj.D, 1);
    PopDec(N, j) = 1;
    Population = SOLUTION(PopDec);
end