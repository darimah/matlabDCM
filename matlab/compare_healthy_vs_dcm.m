%% COMPARE HEALTHY VS DCM
% Script untuk membandingkan simulasi kondisi healthy vs DCM
% Berdasarkan Bozkurt et al. (2022) - Tabel 1 & 3

clear; clc; close all;

addpath('models');
addpath('optimization');
addpath('utils');

fprintf('========================================\n');
fprintf('  PERBANDINGAN HEALTHY vs DCM\n');
fprintf('========================================\n\n');

%% PARAMETER DASAR PASIEN
age_months = 102;  % 8.5 tahun
BSA = 0.94;  % m^2
HR = 101;  % bpm
T = 60/HR;

% Panjang sumbu panjang (sama untuk healthy & DCM)
llv = 6.5;  % cm
lrv = 5.8;  % cm

%% SIMULASI 1: HEALTHY CONDITION
fprintf('[1/2] Simulasi kondisi HEALTHY...\n');

params_healthy = struct();
params_healthy.T = T;
params_healthy.T1 = 0.33 * T;
params_healthy.T2 = 0.45 * T;
params_healthy.HR = HR;
params_healthy.llv = llv;
params_healthy.lrv = lrv;

% Parameter dari Bozkurt 2022 - Healthy Child (Model 1)
params_healthy.Ees_lv = 2.5;      % mmHg/mL
params_healthy.Ees_rv = 1.5;      % mmHg/mL
params_healthy.V0_lv = 7.5;       % mL
params_healthy.V0_rv = 7.5;       % mL
params_healthy.Alv = 1.14;        % mmHg
params_healthy.Arv = 1.14;        % mmHg
params_healthy.Blv = 0.026;       % 1/mL
params_healthy.Brv = 0.026;       % 1/mL
params_healthy.Klv = 1.3;         % -
params_healthy.Krv = 1.65;        % -

% Sirkulasi
params_healthy.Rao = 0.048;       % mmHg·s/mL
params_healthy.Cao = 0.223;       % mL/mmHg
params_healthy.Ras = 0.77;        % mmHg·s/mL
params_healthy.Cas = 0.558;       % mL/mmHg
params_healthy.Rvs = 0.048;       % mmHg·s/mL
params_healthy.Cvs = 13.85;       % mL/mmHg
params_healthy.Rpo = 0.0095;      % mmHg·s/mL
params_healthy.Cpo = 1.896;       % mL/mmHg
params_healthy.Rap = 0.148;       % mmHg·s/mL
params_healthy.Cap = 0.078;       % mL/mmHg
params_healthy.Rvp = 0.048;       % mmHg·s/mL
params_healthy.Cvp = 13.85;       % mL/mmHg
params_healthy.Vblood = 640;      % mL

% Simulasi
tspan = [0, 3*T];
IC = [98, 50, 79, 60, 60, 0, 80, 0, 5, 15, 0, 10, 0, 8];
options = odeset('RelTol', 1e-3, 'AbsTol', 1e-6, 'MaxStep', 1e-3);
[t_h, y_h] = ode15s(@(t,y) cardiovascular_model(t, y, params_healthy), tspan, IC, options);

% Ekstrak siklus terakhir
idx_h = t_h >= 2*T;
t_healthy = t_h(idx_h) - 2*T;
y_healthy = y_h(idx_h, :);

fprintf('   Simulasi healthy selesai.\n\n');

%% SIMULASI 2: DCM CONDITION
fprintf('[2/2] Simulasi kondisi DCM...\n');

params_dcm = params_healthy;  % Copy dari healthy

% Modifikasi untuk DCM (berdasarkan Bozkurt 2022 - Model 1 DCM)
params_dcm.Ees_lv = 0.9;      % ↓ Systolic dysfunction
params_dcm.V0_lv = 25;        % ↑ Enlarged cavity
params_dcm.Alv = 0.65;        % ↓ Diastolic dysfunction
params_dcm.Klv = 0.95;        % ↓ Remodeling
params_dcm.Ras = 1.6;         % ↑ Increased systemic resistance

% Simulasi
IC_dcm = [121, 60, 85, 60, 43, 0, 70, 0, 5, 15, 0, 10, 0, 8];
[t_d, y_d] = ode15s(@(t,y) cardiovascular_model(t, y, params_dcm), tspan, IC_dcm, options);

% Ekstrak siklus terakhir
idx_d = t_d >= 2*T;
t_dcm = t_d(idx_d) - 2*T;
y_dcm = y_d(idx_d, :);

fprintf('   Simulasi DCM selesai.\n\n');

%% HITUNG PARAMETER KLINIS

% Healthy
Vlv_h = y_healthy(:,1);
pao_h = y_healthy(:,5);
EF_h = (max(Vlv_h) - min(Vlv_h)) / max(Vlv_h) * 100;
CO_h = (max(Vlv_h) - min(Vlv_h)) * HR / 1000;
Pao_sys_h = max(pao_h);
Pao_dias_h = min(pao_h);

% DCM
Vlv_d = y_dcm(:,1);
pao_d = y_dcm(:,5);
EF_d = (max(Vlv_d) - min(Vlv_d)) / max(Vlv_d) * 100;
CO_d = (max(Vlv_d) - min(Vlv_d)) * HR / 1000;
Pao_sys_d = max(pao_d);
Pao_dias_d = min(pao_d);

%% DISPLAY PERBANDINGAN
fprintf('========================================\n');
fprintf('  HASIL PERBANDINGAN\n');
fprintf('========================================\n');
fprintf('Parameter          Healthy    DCM      Change\n');
fprintf('----------------------------------------\n');
fprintf('Pao sys (mmHg)     %6.1f   %6.1f   %+6.1f\n', Pao_sys_h, Pao_sys_d, Pao_sys_d-Pao_sys_h);
fprintf('Pao dias (mmHg)    %6.1f   %6.1f   %+6.1f\n', Pao_dias_h, Pao_dias_d, Pao_dias_d-Pao_dias_h);
fprintf('LVEDV (mL)         %6.1f   %6.1f   %+6.1f\n', max(Vlv_h), max(Vlv_d), max(Vlv_d)-max(Vlv_h));
fprintf('LVESV (mL)         %6.1f   %6.1f   %+6.1f\n', min(Vlv_h), min(Vlv_d), min(Vlv_d)-min(Vlv_h));
fprintf('EF (%%)             %6.1f   %6.1f   %+6.1f\n', EF_h, EF_d, EF_d-EF_h);
fprintf('CO (L/min)         %6.2f   %6.2f   %+6.2f\n', CO_h, CO_d, CO_d-CO_h);
fprintf('----------------------------------------\n');
fprintf('Ees,lv (mmHg/mL)   %6.2f   %6.2f   %+6.2f\n', params_healthy.Ees_lv, params_dcm.Ees_lv, params_dcm.Ees_lv-params_healthy.Ees_lv);
fprintf('V0,lv (mL)         %6.1f   %6.1f   %+6.1f\n', params_healthy.V0_lv, params_dcm.V0_lv, params_dcm.V0_lv-params_healthy.V0_lv);
fprintf('Alv (mmHg)         %6.2f   %6.2f   %+6.2f\n', params_healthy.Alv, params_dcm.Alv, params_dcm.Alv-params_healthy.Alv);
fprintf('========================================\n\n');

%% VISUALISASI PERBANDINGAN

% Figure 1: Pressure-Volume Loops Comparison
figure('Name', 'PV Loops: Healthy vs DCM', 'Position', [100 100 1200 500]);

% Hitung tekanan ventrikel kiri untuk healthy
plv_h = zeros(length(t_healthy), 1);
for i = 1:length(t_healthy)
    t_cycle = mod(t_healthy(i), T);
    if t_cycle < params_healthy.T1
        fact = (1 - cos(t_cycle/params_healthy.T1 * pi)) / 2;
    elseif t_cycle < params_healthy.T2
        fact = (1 + cos((t_cycle-params_healthy.T1)/(params_healthy.T2-params_healthy.T1) * pi)) / 2;
    else
        fact = 0;
    end
    plv_a = params_healthy.Ees_lv * (Vlv_h(i) - params_healthy.V0_lv) * fact;
    plv_p = params_healthy.Alv * (exp(params_healthy.Blv * Vlv_h(i)) - 1);
    plv_h(i) = plv_a + plv_p;
end

% Hitung tekanan ventrikel kiri untuk DCM
plv_d = zeros(length(t_dcm), 1);
for i = 1:length(t_dcm)
    t_cycle = mod(t_dcm(i), T);
    if t_cycle < params_dcm.T1
        fact = (1 - cos(t_cycle/params_dcm.T1 * pi)) / 2;
    elseif t_cycle < params_dcm.T2
        fact = (1 + cos((t_cycle-params_dcm.T1)/(params_dcm.T2-params_dcm.T1) * pi)) / 2;
    else
        fact = 0;
    end
    plv_a = params_dcm.Ees_lv * (Vlv_d(i) - params_dcm.V0_lv) * fact;
    plv_p = params_dcm.Alv * (exp(params_dcm.Blv * Vlv_d(i)) - 1);
    plv_d(i) = plv_a + plv_p;
end

subplot(1,2,1);
plot(Vlv_h, plv_h, 'b-', 'LineWidth', 2.5);
hold on;
plot(Vlv_d, plv_d, 'r-', 'LineWidth', 2.5);
xlabel('Volume Ventrikel Kiri (mL)', 'FontSize', 12);
ylabel('Tekanan Ventrikel Kiri (mmHg)', 'FontSize', 12);
title('Pressure-Volume Loop', 'FontSize', 14, 'FontWeight', 'bold');
legend('Healthy', 'DCM', 'Location', 'northwest', 'FontSize', 11);
grid on;
set(gca, 'FontSize', 11);

subplot(1,2,2);
plot(t_healthy, Vlv_h, 'b-', 'LineWidth', 2);
hold on;
plot(t_dcm, Vlv_d, 'r-', 'LineWidth', 2);
xlabel('Waktu (s)', 'FontSize', 12);
ylabel('Volume Ventrikel Kiri (mL)', 'FontSize', 12);
title('Volume vs Time', 'FontSize', 14, 'FontWeight', 'bold');
legend('Healthy', 'DCM', 'FontSize', 11);
grid on;
set(gca, 'FontSize', 11);

% Figure 2: Time Series Comparison
figure('Name', 'Time Series: Healthy vs DCM', 'Position', [100 100 1200 800]);

subplot(2,2,1);
plot(t_healthy, plv_h, 'b-', 'LineWidth', 1.5);
hold on;
plot(t_dcm, plv_d, 'r-', 'LineWidth', 1.5);
ylabel('Tekanan LV (mmHg)', 'FontSize', 11);
title('Tekanan Ventrikel Kiri', 'FontSize', 12, 'FontWeight', 'bold');
legend('Healthy', 'DCM', 'FontSize', 10);
grid on;

subplot(2,2,2);
plot(t_healthy, pao_h, 'b-', 'LineWidth', 1.5);
hold on;
plot(t_dcm, pao_d, 'r-', 'LineWidth', 1.5);
ylabel('Tekanan Aorta (mmHg)', 'FontSize', 11);
title('Tekanan Aorta', 'FontSize', 12, 'FontWeight', 'bold');
legend('Healthy', 'DCM', 'FontSize', 10);
grid on;

subplot(2,2,3);
plot(t_healthy, Vlv_h, 'b-', 'LineWidth', 1.5);
hold on;
plot(t_dcm, Vlv_d, 'r-', 'LineWidth', 1.5);
xlabel('Waktu (s)', 'FontSize', 11);
ylabel('Volume LV (mL)', 'FontSize', 11);
title('Volume Ventrikel Kiri', 'FontSize', 12, 'FontWeight', 'bold');
legend('Healthy', 'DCM', 'FontSize', 10);
grid on;

subplot(2,2,4);
% Bar chart perbandingan
categories = {'EF (%)', 'CO (L/min)', 'SBP (mmHg)'};
healthy_vals = [EF_h, CO_h, Pao_sys_h];
dcm_vals = [EF_d, CO_d, Pao_sys_d];
x = 1:3;
bar(x-0.2, healthy_vals, 0.4, 'b');
hold on;
bar(x+0.2, dcm_vals, 0.4, 'r');
set(gca, 'XTick', x, 'XTickLabel', categories);
ylabel('Nilai', 'FontSize', 11);
title('Perbandingan Parameter Klinis', 'FontSize', 12, 'FontWeight', 'bold');
legend('Healthy', 'DCM', 'FontSize', 10);
grid on;

fprintf('Visualisasi selesai!\n');
fprintf('========================================\n');
