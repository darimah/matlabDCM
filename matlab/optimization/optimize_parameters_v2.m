function [optimized_params, results] = optimize_parameters_v2(params)
% OPTIMIZE_PARAMETERS_V2 - Optimisasi parameter dengan algoritma yang lebih baik
% Menggunakan kombinasi grid search + random search + local refinement
% Berdasarkan Bozkurt et al. (2022) dengan perbaikan
%
% Input:
%   params - struktur parameter awal dan bounds
%
% Output:
%   optimized_params - parameter teroptimasi
%   results - hasil optimisasi (error, iterations, dll)

fprintf('   Memulai optimisasi (Algoritma V2 - Improved)...\n');

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

% STRATEGI BARU: 3 FASE OPTIMISASI
% Fase 1: Coarse grid search (cepat, eksplorasi luas)
% Fase 2: Random search around best (escape local minima)
% Fase 3: Fine-tuning (konvergensi)

% Convergence criteria
tol_objective = 0.05;
tol_error = 0.1;

% Initialize bounds
current_bounds_lb = zeros(n_params, 1);
current_bounds_ub = zeros(n_params, 1);

for i = 1:n_params
    current_bounds_lb(i) = bounds.(param_names{i})(1);
    current_bounds_ub(i) = bounds.(param_names{i})(2);
end

best_objective = inf;
best_params = [];
best_error_MAP = 0;
best_error_CO = 0;

%% FASE 1: COARSE GRID SEARCH (5 iterasi, 15 points per iterasi)
fprintf('   [Fase 1] Coarse Grid Search...\n');
n_coarse_iterations = 5;
n_points_per_iter = 15;

for sim = 1:n_coarse_iterations
    fprintf('      Iterasi %d/%d: ', sim, n_coarse_iterations);
    
    % Grid search
    h = (current_bounds_ub - current_bounds_lb) / n_points_per_iter;
    
    for iter = 1:n_points_per_iter
        x = current_bounds_lb + h * iter;
        
        % Test this parameter set
        [obj, err_MAP, err_CO] = evaluate_params(x, param_names, params, MAP_target, CO_target);
        
        if obj < best_objective
            best_objective = obj;
            best_params = x;
            best_error_MAP = err_MAP;
            best_error_CO = err_CO;
        end
    end
    
    fprintf('Best Obj = %.4f (MAP: %.1f%%, CO: %.1f%%)\n', ...
        best_objective, best_error_MAP*100, best_error_CO*100);
    
    % Check early convergence
    if best_objective <= tol_objective
        fprintf('      Konvergen di Fase 1!\n');
        break;
    end
    
    % Narrow bounds (20% margin)
    margin = 0.2;
    for i = 1:n_params
        range = current_bounds_ub(i) - current_bounds_lb(i);
        current_bounds_lb(i) = max(bounds.(param_names{i})(1), ...
                                    best_params(i) - margin*range);
        current_bounds_ub(i) = min(bounds.(param_names{i})(2), ...
                                    best_params(i) + margin*range);
    end
end

%% FASE 2: RANDOM SEARCH (escape local minima)
if best_objective > tol_objective
    fprintf('   [Fase 2] Random Search (escape local minima)...\n');
    n_random_samples = 50;
    
    for sample = 1:n_random_samples
        % Random perturbation around best params
        perturbation = 0.1;  % ±10%
        x = best_params + (rand(n_params, 1) - 0.5) * 2 * perturbation .* (current_bounds_ub - current_bounds_lb);
        
        % Clip to bounds
        x = max(current_bounds_lb, min(current_bounds_ub, x));
        
        % Evaluate
        [obj, err_MAP, err_CO] = evaluate_params(x, param_names, params, MAP_target, CO_target);
        
        if obj < best_objective
            best_objective = obj;
            best_params = x;
            best_error_MAP = err_MAP;
            best_error_CO = err_CO;
            fprintf('      Sample %d: Improved! Obj = %.4f\n', sample, obj);
        end
    end
    
    fprintf('      Best after random search: Obj = %.4f (MAP: %.1f%%, CO: %.1f%%)\n', ...
        best_objective, best_error_MAP*100, best_error_CO*100);
end

%% FASE 3: FINE-TUNING (local refinement)
if best_objective > tol_objective
    fprintf('   [Fase 3] Fine-Tuning...\n');
    n_fine_iterations = 10;
    n_fine_points = 20;
    
    % Very narrow bounds around best
    fine_margin = 0.05;  % ±5%
    for i = 1:n_params
        range = bounds.(param_names{i})(2) - bounds.(param_names{i})(1);
        current_bounds_lb(i) = max(bounds.(param_names{i})(1), ...
                                    best_params(i) - fine_margin*range);
        current_bounds_ub(i) = min(bounds.(param_names{i})(2), ...
                                    best_params(i) + fine_margin*range);
    end
    
    for sim = 1:n_fine_iterations
        fprintf('      Iterasi %d/%d: ', sim, n_fine_iterations);
        
        h = (current_bounds_ub - current_bounds_lb) / n_fine_points;
        
        for iter = 1:n_fine_points
            x = current_bounds_lb + h * iter;
            
            [obj, err_MAP, err_CO] = evaluate_params(x, param_names, params, MAP_target, CO_target);
            
            if obj < best_objective
                best_objective = obj;
                best_params = x;
                best_error_MAP = err_MAP;
                best_error_CO = err_CO;
            end
        end
        
        fprintf('Obj = %.4f (MAP: %.1f%%, CO: %.1f%%)\n', ...
            best_objective, best_error_MAP*100, best_error_CO*100);
        
        if best_objective <= tol_objective
            fprintf('      Konvergen!\n');
            break;
        end
        
        % Further narrow
        for i = 1:n_params
            range = current_bounds_ub(i) - current_bounds_lb(i);
            current_bounds_lb(i) = max(bounds.(param_names{i})(1), ...
                                        best_params(i) - 0.1*range);
            current_bounds_ub(i) = min(bounds.(param_names{i})(2), ...
                                        best_params(i) + 0.1*range);
        end
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
results.converged = (best_objective <= tol_objective);

fprintf('   Optimisasi selesai! Final Obj = %.4f\n', best_objective);

end

%% HELPER FUNCTION: EVALUATE PARAMETERS
function [objective, error_MAP, error_CO] = evaluate_params(x, param_names, params, MAP_target, CO_target)
% Evaluate objective function for given parameter set

% Create params structure
test_params = params;
for i = 1:length(param_names)
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
    
catch
    % If simulation fails, return very high objective
    objective = inf;
    error_MAP = inf;
    error_CO = inf;
end

end

%% HELPER FUNCTION: SIMULATE AND EVALUATE
function [MAP, CO] = simulate_and_evaluate(params)
% Simulasi singkat untuk evaluasi parameter

T = params.T;
tspan = [0, 2*T];  % 2 cardiac cycles

% Initial conditions
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
