function [optimized_params, results] = optimize_parameters(params)
% OPTIMIZE_PARAMETERS - Optimisasi parameter model kardiovaskular
% Menggunakan direct search method (pattern search)
% Berdasarkan Bozkurt et al. (2022)
%
% Input:
%   params - struktur parameter awal dan bounds
%
% Output:
%   optimized_params - parameter teroptimasi
%   results - hasil optimisasi (error, iterations, dll)

fprintf('   Memulai optimisasi...\n');

% Target values
MAP_target = (params.Pao_sys_target + 2*params.Pao_dias_target) / 3;
CO_target = params.CO_target;

% Initial bounds
bounds = params.bounds;

% Parameter vector names
param_names = {'Ees_lv', 'Ees_rv', 'V0_lv', 'V0_rv', ...
               'Alv', 'Arv', 'Blv', 'Brv', ...
               'Rao', 'Cao', 'Ras', 'Cas', 'Rvs', 'Cvs', ...
               'Rpo', 'Cpo', 'Rap', 'Cap', 'Rvp', 'Cvp', ...
               'Vblood', 'Klv', 'Krv'};

n_params = length(param_names);
n_iterations_per_sim = 10;
max_simulations = 10;

% Convergence criteria
tol_objective = 0.05;
tol_error = 0.1;

% Initialize
current_bounds_lb = zeros(n_params, 1);
current_bounds_ub = zeros(n_params, 1);

for i = 1:n_params
    current_bounds_lb(i) = bounds.(param_names{i})(1);
    current_bounds_ub(i) = bounds.(param_names{i})(2);
end

best_objective = inf;
best_params = [];

%% OPTIMISASI ITERATIF
for sim = 1:max_simulations
    fprintf('   Simulasi %d/%d: ', sim, max_simulations);
    
    % Step size
    h = (current_bounds_ub - current_bounds_lb) / n_iterations_per_sim;
    
    % Test parameter combinations
    for iter = 1:n_iterations_per_sim
        % Generate parameter set
        x = current_bounds_lb + h * iter;
        
        % Special handling for A and B (decrease from upper bound)
        % karena MAP dan CO menurun dengan meningkatnya A dan B
        idx_A = find(strcmp(param_names, 'Alv'));
        idx_B = find(strcmp(param_names, 'Blv'));
        x(idx_A) = current_bounds_ub(idx_A) - h(idx_A) * iter;
        x(idx_B) = current_bounds_ub(idx_B) - h(idx_B) * iter;
        
        % Create params structure
        test_params = params;
        for i = 1:n_params
            test_params.(param_names{i}) = x(i);
        end
        
        % Simulate
        try
            [MAP_sim, CO_sim] = simulate_and_evaluate(test_params);
            
            % Calculate errors
            error_MAP = (MAP_target - MAP_sim) / MAP_target;
            error_CO = (CO_target - CO_sim) / CO_target;
            
            % Objective function
            objective = abs(error_MAP + error_CO);
            
            % Update best
            if objective < best_objective
                best_objective = objective;
                best_params = x;
                best_error_MAP = error_MAP;
                best_error_CO = error_CO;
            end
            
        catch
            % Skip if simulation fails
            continue;
        end
    end
    
    fprintf('Obj = %.4f, MAP err = %.2f%%, CO err = %.2f%%\n', ...
        best_objective, best_error_MAP*100, best_error_CO*100);
    
    % Check convergence
    if best_objective <= tol_objective && ...
       abs(best_error_MAP) <= tol_error && ...
       abs(best_error_CO) <= tol_error
        fprintf('   Konvergen! Optimisasi selesai.\n');
        break;
    end
    
    % Update bounds untuk simulasi berikutnya
    % Narrow down around best parameters
    margin = 0.1;  % 10% margin
    for i = 1:n_params
        range = current_bounds_ub(i) - current_bounds_lb(i);
        current_bounds_lb(i) = max(bounds.(param_names{i})(1), ...
                                    best_params(i) - margin*range);
        current_bounds_ub(i) = min(bounds.(param_names{i})(2), ...
                                    best_params(i) + margin*range);
    end
end

%% OUTPUT
optimized_params = struct();
for i = 1:n_params
    optimized_params.(param_names{i}) = best_params(i);
end

results = struct();
results.final_objective = best_objective;
results.error_MAP = best_error_MAP;
results.error_CO = best_error_CO;
results.n_simulations = sim;
results.converged = (best_objective <= tol_objective);

end

%% HELPER FUNCTION
function [MAP, CO] = simulate_and_evaluate(params)
% Simulasi singkat untuk evaluasi parameter

T = params.T;
tspan = [0, 2*T];  % 2 cardiac cycles

% Initial conditions (simplified)
IC = zeros(14, 1);
IC(1) = params.Vlv_dias_target;  % Vlv
IC(2) = 50;   % Vla
IC(3) = params.Vrv_dias_target;  % Vrv
IC(4) = 60;   % Vra
IC(5) = params.Pao_dias_target;  % pao
IC(6) = 0;    % Qao
IC(7) = 80;   % pas
IC(8) = 0;    % Qas
IC(9) = 5;    % pvs
IC(10) = 15;  % ppo
IC(11) = 0;   % Qpo
IC(12) = 10;  % pap
IC(13) = 0;   % Qap
IC(14) = 8;   % pvp

% Solve
options = odeset('RelTol', 1e-2, 'AbsTol', 1e-4, 'MaxStep', 1e-3);
[t, y] = ode15s(@(t,y) cardiovascular_model(t, y, params), tspan, IC, options);

% Ekstrak siklus terakhir
last_cycle_idx = t >= T;
pao_last = y(last_cycle_idx, 5);
Vlv_last = y(last_cycle_idx, 1);

% Calculate MAP
MAP = mean(pao_last);

% Calculate CO
SV = max(Vlv_last) - min(Vlv_last);  % mL
CO = SV * params.HR / 1000;  % L/min

end
