%% MAIN SIMULATION - Model Kardiovaskular DCM Pediatrik
% Berdasarkan: Bozkurt et al. (2022) - Patient-Specific Modelling and 
% Parameter Optimisation to Simulate Dilated Cardiomyopathy in Children
%
% Author: Rufaida Kariemah
% NPM: 2206031561
% Pembimbing: dr. Puspita Anggraini Katili, M.Sc., Ph.D.

clear; clc; close all;

%% 1. SETUP PATH
addpath('models');
addpath('optimization');
addpath('utils');
addpath('data');

fprintf('==============================================\n');
fprintf('  SIMULASI MODEL KARDIOVASKULAR DCM PEDIATRIK\n');
fprintf('==============================================\n\n');

%% 2. LOAD DATA PASIEN
fprintf('[1/6] Loading data pasien...\n');

% CEK APAKAH ADA DATA PASIEN DI WORKSPACE
% Jika Anda sudah menjalankan file pasien (misal: pasien_001.m),
% maka variabel 'patient_data' sudah ada di workspace
if exist('patient_data', 'var')
    fprintf('   ✓ Menggunakan data pasien dari workspace\n');
    fprintf('   Nama: %s\n', patient_data.name);
else
    % Jika tidak ada, gunakan data contoh
    fprintf('   ⚠ Tidak ada data pasien di workspace\n');
    fprintf('   Menggunakan data contoh (Mild DCM, 8.5 tahun)\n');
    fprintf('   \n');
    fprintf('   CARA MENGGUNAKAN DATA PASIEN SENDIRI:\n');
    fprintf('   1. Edit file: data/patient_template.m\n');
    fprintf('   2. Isi dengan data pasien real\n');
    fprintf('   3. Jalankan: >> patient_template\n');
    fprintf('   4. Lalu jalankan: >> main_simulation\n');
    fprintf('   \n');
    
    % Data contoh pasien (Mild DCM, 8.5 tahun)
    patient_data = struct();
    
    % Data Demografis
    patient_data.name = 'Contoh Pasien (Mild DCM)';
    patient_data.age_months = 102;  % 8 tahun 6 bulan
    patient_data.sex = 'M';  % M/F
    patient_data.height_cm = 130;
    patient_data.weight_kg = 25;
    patient_data.BSA = 0.94;  % m^2
    
    % Data Hemodinamik (dari Ekokardiografi)
    patient_data.HR = 101;  % bpm
    patient_data.Pao_sys = 109;  % mmHg
    patient_data.Pao_dias = 60;  % mmHg
    patient_data.CO = 5.3;  % L/min
    
    % Volume Ventrikel (mL)
    patient_data.Vlv_dias = 100;  % LVEDV
    patient_data.Vlv_sys = 48;    % LVESV
    patient_data.Vrv_dias = 83;   % RVEDV
    patient_data.Vrv_sys = 26;    % RVESV
    
    % Diameter Ventrikel (cm)
    patient_data.Dlv_dias = 4.6;  % LVEDD
    patient_data.Dlv_sys = 3.4;   % LVESD
    patient_data.Drv_dias = NaN;  % RVEDD (tidak ada di protokol)
    patient_data.Drv_sys = NaN;   % RVESD (tidak ada di protokol)
    
    % Panjang Sumbu Panjang (cm) - KONSTAN sesuai asumsi Bozkurt 2022
    patient_data.llv = 6.5;
    patient_data.llv_sys = 6.5;   % Konstan
    patient_data.llv_dias = 6.5;  % Konstan
    
    patient_data.lrv = 5.8;
    patient_data.lrv_sys = 5.8;   % Konstan
    patient_data.lrv_dias = 5.8;  % Konstan
    
    % Data Validasi
    patient_data.EF_measured = 52;  % %
    patient_data.FS_measured = 26;  % %
end

fprintf('   Pasien: %s\n', patient_data.name);
fprintf('   Usia: %.1f bulan (%.1f tahun)\n', patient_data.age_months, patient_data.age_months/12);
fprintf('   BSA: %.2f m^2\n', patient_data.BSA);
fprintf('   HR: %d bpm\n', patient_data.HR);
fprintf('   CO: %.1f L/min\n', patient_data.CO);
fprintf('   EF (measured): %d%%\n\n', patient_data.EF_measured);

%% 3. INISIALISASI PARAMETER MODEL
fprintf('[2/6] Inisialisasi parameter model...\n');

% Durasi siklus jantung
T = 60 / patient_data.HR;  % detik

% Parameter waktu aktivasi (dari Bozkurt 2022)
params.T = T;
params.T1 = 0.33 * T;  % Akhir sistol
params.T2 = 0.45 * T;  % Akhir relaksasi

% Input data pasien
params.HR = patient_data.HR;
params.llv = patient_data.llv;
params.lrv = patient_data.lrv;
params.Pao_sys_target = patient_data.Pao_sys;
params.Pao_dias_target = patient_data.Pao_dias;
params.CO_target = patient_data.CO;
params.Vlv_dias_target = patient_data.Vlv_dias;
params.Vlv_sys_target = patient_data.Vlv_sys;
params.Vrv_dias_target = patient_data.Vrv_dias;
params.Vrv_sys_target = patient_data.Vrv_sys;
params.Dlv_dias_target = patient_data.Dlv_dias;
params.Dlv_sys_target = patient_data.Dlv_sys;

% ESTIMASI VOLUME DARAH DARI BSA (Linear Regression)
fprintf('   Estimasi volume darah dari BSA...\n');
[TBV_est, UBV_est, SBV_est] = estimate_blood_volume_from_BSA(...
    patient_data.BSA, patient_data.age_months, patient_data.sex);

fprintf('   TBV (Total Blood Volume): %.0f mL\n', TBV_est);
fprintf('   UBV (Unstressed, 70%%): %.0f mL\n', UBV_est);
fprintf('   SBV (Stressed, 30%%): %.0f mL\n\n', SBV_est);

% Simpan estimasi untuk referensi
params.TBV_estimated = TBV_est;
params.UBV_estimated = UBV_est;
params.SBV_estimated = SBV_est;

% Initial bounds untuk optimisasi (dari Tabel 1, Bozkurt 2022)
% DISESUAIKAN UNTUK DCM: kontraktilitas rendah, volume besar
bounds.Ees_lv = [0.5, 3.5];      % mmHg/mL - LEBIH RENDAH untuk DCM
bounds.Ees_rv = [0.5, 2.0];      % mmHg/mL - LEBIH RENDAH untuk DCM
bounds.V0_lv = [5, 30];          % mL - LEBIH BESAR untuk DCM
bounds.V0_rv = [5, 20];          % mL - LEBIH BESAR untuk DCM
bounds.Alv = [0.5, 1.3];         % mmHg - LEBIH RENDAH untuk DCM (diastolic dysfunction)
bounds.Arv = [0.5, 1.3];         % mmHg
bounds.Blv = [0.015, 0.035];     % 1/mL - LEBIH LEBAR
bounds.Brv = [0.015, 0.035];     % 1/mL
bounds.Rao = [0.03, 0.07];       % mmHg·s/mL - LEBIH LEBAR
bounds.Cao = [0.15, 0.35];       % mL/mmHg - LEBIH LEBAR
bounds.Ras = [0.4, 2.0];         % mmHg·s/mL - LEBIH TINGGI untuk DCM (afterload tinggi)
bounds.Cas = [0.25, 1.0];        % mL/mmHg - LEBIH LEBAR
bounds.Rvs = [0.03, 0.07];       % mmHg·s/mL
bounds.Cvs = [10.0, 18.0];       % mL/mmHg - LEBIH LEBAR
bounds.Rpo = [0.005, 0.015];     % mmHg·s/mL
bounds.Cpo = [1.0, 3.0];         % mL/mmHg - LEBIH LEBAR
bounds.Rap = [0.10, 0.20];       % mmHg·s/mL
bounds.Cap = [0.04, 0.12];       % mL/mmHg
bounds.Rvp = [0.03, 0.07];       % mmHg·s/mL
bounds.Cvp = [10.0, 18.0];       % mL/mmHg - LEBIH LEBAR

% BOUNDS VBLOOD BERDASARKAN ESTIMASI TBV
% Gunakan ±30% untuk DCM (lebih lebar karena variabilitas tinggi)
Vblood_margin = 0.30;  % ±30% untuk DCM
bounds.Vblood = [TBV_est * (1 - Vblood_margin), ...
                 TBV_est * (1 + Vblood_margin)];
fprintf('   Vblood bounds (±30%% dari TBV): [%.0f, %.0f] mL\n', ...
    bounds.Vblood(1), bounds.Vblood(2));

bounds.Klv = [0.8, 2.5];         % - LEBIH LEBAR untuk DCM (remodeling)
bounds.Krv = [1.0, 5.0];         % - LEBIH LEBAR

params.bounds = bounds;

fprintf('   Parameter bounds initialized\n');
fprintf('   Total parameters to optimize: 23\n\n');

%% 4. OPTIMISASI PARAMETER
fprintf('[3/6] Memulai optimisasi parameter...\n');
fprintf('   Metode: Improved Direct Search (3-Phase Algorithm)\n');
fprintf('   Target: MAP dan CO\n\n');

% Jalankan optimisasi dengan algoritma yang lebih baik
[optimized_params, optimization_results] = optimize_parameters_v2(params);

fprintf('   Optimisasi selesai!\n');
fprintf('   Objective function: %.4f\n', optimization_results.final_objective);
fprintf('   Error MAP: %.2f%%\n', optimization_results.error_MAP * 100);
fprintf('   Error CO: %.2f%%\n\n', optimization_results.error_CO * 100);

%% 5. SIMULASI MODEL LENGKAP
fprintf('[4/6] Menjalankan simulasi model lengkap...\n');

% Gabungkan parameter teroptimasi
full_params = params;
field_names = fieldnames(optimized_params);
for i = 1:length(field_names)
    full_params.(field_names{i}) = optimized_params.(field_names{i});
end

% Simulasi 3 siklus jantung
n_cycles = 3;
tspan = [0, n_cycles * T];

% Initial conditions - HARUS SAMA dengan yang digunakan saat optimisasi!
% [Vlv, Vla, Vrv, Vra, pao, Qao, pas, Qas, pvs, ppo, Qpo, pap, Qap, pvp]
IC = zeros(14, 1);
IC(1) = patient_data.Vlv_dias;      % Vlv - dari data pasien
IC(2) = 50;                          % Vla - estimasi atrium kiri
IC(3) = patient_data.Vrv_dias;      % Vrv - dari data pasien
IC(4) = 60;                          % Vra - estimasi atrium kanan
IC(5) = patient_data.Pao_dias;      % pao - dari data pasien
IC(6) = 0;                           % Qao - aliran aorta (start dari 0)
IC(7) = 80;                          % pas - tekanan arteri sistemik (estimasi)
IC(8) = 0;                           % Qas - aliran arteri sistemik (start dari 0)
IC(9) = 5;                           % pvs - tekanan vena sistemik (estimasi)
IC(10) = 15;                         % ppo - tekanan arteri pulmonal (estimasi)
IC(11) = 0;                          % Qpo - aliran pulmonal (start dari 0)
IC(12) = 10;                         % pap - tekanan arteriol pulmonal (estimasi)
IC(13) = 0;                          % Qap - aliran arteriol pulmonal (start dari 0)
IC(14) = 8;                          % pvp - tekanan vena pulmonal (estimasi)

% Solve ODE dengan toleransi yang sama seperti saat optimisasi
options = odeset('RelTol', 1e-2, 'AbsTol', 1e-4, 'MaxStep', 1e-3);
[t, y] = ode15s(@(t,y) cardiovascular_model(t, y, full_params), tspan, IC, options);

fprintf('   Simulasi selesai!\n');
fprintf('   Time points: %d\n', length(t));
fprintf('   Duration: %.2f detik (%d siklus)\n\n', tspan(end), n_cycles);

%% 6. VALIDASI HASIL
fprintf('[5/6] Validasi hasil simulasi...\n');

% Ekstrak hasil dari siklus terakhir
last_cycle_idx = t >= (n_cycles-1)*T;
t_last = t(last_cycle_idx) - (n_cycles-1)*T;
y_last = y(last_cycle_idx, :);

% Hitung parameter validasi
validation = validate_results(t_last, y_last, patient_data, full_params);

fprintf('   HASIL VALIDASI:\n');
fprintf('   ----------------------------------------\n');
fprintf('   Parameter          Model    Measured   Error\n');
fprintf('   ----------------------------------------\n');
fprintf('   Pao sys (mmHg)    %6.1f    %6.1f    %5.1f%%\n', ...
    validation.Pao_sys, patient_data.Pao_sys, validation.error_Pao_sys);
fprintf('   Pao dias (mmHg)   %6.1f    %6.1f    %5.1f%%\n', ...
    validation.Pao_dias, patient_data.Pao_dias, validation.error_Pao_dias);
fprintf('   CO (L/min)        %6.2f    %6.2f    %5.1f%%\n', ...
    validation.CO, patient_data.CO, validation.error_CO);
fprintf('   LVEDV (mL)        %6.1f    %6.1f    %5.1f%%\n', ...
    validation.Vlv_dias, patient_data.Vlv_dias, validation.error_Vlv_dias);
fprintf('   LVESV (mL)        %6.1f    %6.1f    %5.1f%%\n', ...
    validation.Vlv_sys, patient_data.Vlv_sys, validation.error_Vlv_sys);
fprintf('   EF (%%)            %6.1f    %6.1f    %5.1f%%\n', ...
    validation.EF, patient_data.EF_measured, validation.error_EF);
fprintf('   ----------------------------------------\n\n');

%% 7. VISUALISASI
fprintf('[6/6] Membuat visualisasi...\n');

% Figure 1: Pressure-Volume Loops
figure('Name', 'Pressure-Volume Loops', 'Position', [100 100 1200 500]);

subplot(1,2,1);
plot(y_last(:,1), validation.plv_all, 'b-', 'LineWidth', 2);
hold on;
plot(patient_data.Vlv_dias, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
plot(patient_data.Vlv_sys, max(validation.plv_all), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
xlabel('Volume Ventrikel Kiri (mL)');
ylabel('Tekanan Ventrikel Kiri (mmHg)');
title('Left Ventricular Pressure-Volume Loop');
legend('Model', 'EDV (measured)', 'ESV (measured)');
grid on;

subplot(1,2,2);
plot(y_last(:,3), validation.prv_all, 'r-', 'LineWidth', 2);
xlabel('Volume Ventrikel Kanan (mL)');
ylabel('Tekanan Ventrikel Kanan (mmHg)');
title('Right Ventricular Pressure-Volume Loop');
grid on;

% Figure 2: Time Series
figure('Name', 'Hemodynamic Time Series', 'Position', [100 100 1200 800]);

subplot(3,2,1);
plot(t_last, validation.plv_all, 'b-', 'LineWidth', 1.5);
hold on;
plot(t_last, y_last(:,5), 'r-', 'LineWidth', 1.5);
ylabel('Tekanan (mmHg)');
title('Tekanan Ventrikel Kiri & Aorta');
legend('LV', 'Aorta');
grid on;

subplot(3,2,2);
plot(t_last, validation.prv_all, 'b-', 'LineWidth', 1.5);
ylabel('Tekanan (mmHg)');
title('Tekanan Ventrikel Kanan');
grid on;

subplot(3,2,3);
plot(t_last, y_last(:,1), 'b-', 'LineWidth', 1.5);
hold on;
plot(t_last, y_last(:,3), 'r-', 'LineWidth', 1.5);
ylabel('Volume (mL)');
title('Volume Ventrikel');
legend('LV', 'RV');
grid on;

subplot(3,2,4);
plot(t_last, y_last(:,2), 'b-', 'LineWidth', 1.5);
hold on;
plot(t_last, y_last(:,4), 'r-', 'LineWidth', 1.5);
ylabel('Volume (mL)');
title('Volume Atrium');
legend('LA', 'RA');
grid on;

subplot(3,2,5);
plot(t_last, validation.Dlv_all, 'b-', 'LineWidth', 1.5);
ylabel('Diameter (cm)');
xlabel('Waktu (s)');
title('Diameter Ventrikel Kiri');
grid on;

subplot(3,2,6);
plot(t_last, validation.Drv_all, 'r-', 'LineWidth', 1.5);
ylabel('Diameter (cm)');
xlabel('Waktu (s)');
title('Diameter Ventrikel Kanan');
grid on;

fprintf('   Visualisasi selesai!\n\n');

%% 8. SAVE RESULTS
fprintf('Menyimpan hasil...\n');

results = struct();
results.patient_data = patient_data;
results.optimized_params = optimized_params;
results.validation = validation;
results.time = t_last;
results.state = y_last;

save('data/simulation_results.mat', 'results');

fprintf('Hasil disimpan di: data/simulation_results.mat\n\n');
fprintf('==============================================\n');
fprintf('  SIMULASI SELESAI!\n');
fprintf('==============================================\n');
