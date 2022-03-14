classdef PRDH < ALGORITHM
% <multi> <binary> 
% Solving Multi-objective Feature Selection Problems in Classification via 
% Problem Reformulation and Duplication Handling
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
            %% Generate initial population
            Population = InitializePopulation(Problem);
            [~, FrontNo, CrowdDis] = EnvironmentalSelection(Population, Problem.N);

            %% Optimization
            while Algorithm.NotTerminated(Population)
                MatingPool = TournamentSelection(2, Problem.N, FrontNo, -CrowdDis);
                Offspring  = OffspringReproduction(Population(MatingPool));
                [Population, FrontNo, CrowdDis] = EnvironmentalSelection([Population, Offspring], Problem.N);
            end
        end
    end
end

function Population = InitializePopulation(Problem)
    T = min(Problem.D, Problem.N * 3);
    Pop = zeros(Problem.N, Problem.D);
    for i = 1 : Problem.N
        k = randperm(T, 1);
        j = randperm(Problem.D, k);
        Pop(i, j) = 1;
    end
    Population = SOLUTION(Pop);
end
