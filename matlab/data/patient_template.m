%% TEMPLATE DATA PASIEN
% File ini adalah template untuk input data pasien
% Berdasarkan Protokol DCM
%
% Cara menggunakan:
% 1. Copy file ini dan rename sesuai nama pasien (misal: pasien_001.m)
% 2. Isi semua field dengan data dari ekokardiografi
% 3. Jalankan file ini untuk membuat struktur patient_data
% 4. Save ke .mat file atau gunakan langsung di main_simulation.m

%% INFORMASI PASIEN
patient_data = struct();

% Identitas
patient_data.name = 'Pasien 001';
patient_data.medical_record = 'RM-XXXXX';
patient_data.date = '2026-02-11';

%% PARAMETER DEMOGRAFI / KLINIS

% Usia (bulan)
patient_data.age_months = 102;  % 8 tahun 6 bulan

% Jenis Kelamin ('M' atau 'F')
patient_data.sex = 'M';

% Antropometri
patient_data.height_cm = 130;  % cm
patient_data.weight_kg = 25;   % kg

% Body Surface Area (BSA) - gunakan rumus Mosteller
% BSA = sqrt((height_cm × weight_kg) / 3600)
patient_data.BSA = sqrt((patient_data.height_cm * patient_data.weight_kg) / 3600);

% Ross Classification (I, II, III, atau IV)
patient_data.ross_class = 'I';

% Mitral Regurgitation (moderate-to-massive: true/false)
patient_data.mitral_regurgitation = false;

% Voltage Limb Leads (low: true/false)
patient_data.voltage_low = false;

% Vasoactive Drugs (membutuhkan: true/false)
patient_data.vasoactive_drugs = false;

%% PARAMETER HEMODINAMIK (dari Ekokardiografi)

% Heart Rate (bpm)
patient_data.HR = 101;

% Tekanan Aorta (mmHg)
patient_data.Pao_sys = 109;   % Sistolik
patient_data.Pao_dias = 60;   % Diastolik

% Volume Ventrikel Kiri (mL)
patient_data.Vlv_dias = 100;  % LVEDV - End-Diastolic Volume
patient_data.Vlv_sys = 48;    % LVESV - End-Systolic Volume

% Volume Ventrikel Kanan (mL)
patient_data.Vrv_dias = 83;   % RVEDV
patient_data.Vrv_sys = 26;    % RVESV

% Diameter Ventrikel Kiri (cm) - dari M-Mode
patient_data.Dlv_dias = 4.6;  % LVEDD
patient_data.Dlv_sys = 3.4;   % LVESD

% Diameter Ventrikel Kanan (cm) - basal diameter
patient_data.Drv_dias = 2.7;  % RVEDD
patient_data.Drv_sys = 1.7;   % RVESD

% Panjang Sumbu Panjang Ventrikel (cm)
patient_data.llv_sys = 5.9;   % Sistol
patient_data.llv_dias = 7.1;  % Diastol
patient_data.llv = (patient_data.llv_sys + patient_data.llv_dias) / 2;  % Rata-rata

patient_data.lrv_sys = 5.1;
patient_data.lrv_dias = 6.5;
patient_data.lrv = (patient_data.lrv_sys + patient_data.lrv_dias) / 2;

% Cardiac Output (L/min)
patient_data.CO = 5.3;

%% PARAMETER VALIDASI (jika tersedia)

% Fractional Shortening (%)
patient_data.FS_measured = 26;

% Ejection Fraction (%)
patient_data.EF_measured = 52;

%% HITUNG PARAMETER TURUNAN

% Mean Arterial Pressure (mmHg)
patient_data.MAP = (patient_data.Pao_sys + 2*patient_data.Pao_dias) / 3;

% Stroke Volume (mL)
patient_data.SV = patient_data.Vlv_dias - patient_data.Vlv_sys;

% Cardiac Index (L/min/m^2)
patient_data.CI = patient_data.CO / patient_data.BSA;

% Z-scores (jika ada data normatif)
% patient_data.zscore_LVEDV = ...;
% patient_data.zscore_LVEDD = ...;

%% KLASIFIKASI DCM

% Kriteria DCM (berdasarkan z-score > 2 atau EF < 45%)
if patient_data.EF_measured < 45
    patient_data.DCM_severity = 'Severe';
elseif patient_data.EF_measured < 55
    patient_data.DCM_severity = 'Mild';
else
    patient_data.DCM_severity = 'Normal';
end

%% DISPLAY SUMMARY
fprintf('========================================\n');
fprintf('  DATA PASIEN\n');
fprintf('========================================\n');
fprintf('Nama         : %s\n', patient_data.name);
fprintf('RM           : %s\n', patient_data.medical_record);
fprintf('Usia         : %.1f tahun\n', patient_data.age_months/12);
fprintf('BSA          : %.2f m^2\n', patient_data.BSA);
fprintf('----------------------------------------\n');
fprintf('HR           : %d bpm\n', patient_data.HR);
fprintf('BP           : %d/%d mmHg\n', patient_data.Pao_sys, patient_data.Pao_dias);
fprintf('CO           : %.1f L/min\n', patient_data.CO);
fprintf('----------------------------------------\n');
fprintf('LVEDV        : %.1f mL\n', patient_data.Vlv_dias);
fprintf('LVESV        : %.1f mL\n', patient_data.Vlv_sys);
fprintf('EF           : %d%%\n', patient_data.EF_measured);
fprintf('FS           : %d%%\n', patient_data.FS_measured);
fprintf('----------------------------------------\n');
fprintf('DCM Severity : %s\n', patient_data.DCM_severity);
fprintf('========================================\n\n');

%% SAVE DATA
% Uncomment untuk save ke file .mat
% save('data/pasien_001.mat', 'patient_data');
% fprintf('Data saved to: data/pasien_001.mat\n');
