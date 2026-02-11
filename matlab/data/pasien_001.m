%% DATA PASIEN 001
% Copy dari patient_template.m dan isi dengan data real
% Setelah diisi, jalankan file ini lalu jalankan main_simulation.m

%% INFORMASI PASIEN
patient_data = struct();

% Identitas
patient_data.name = 'Pasien 001';
patient_data.medical_record = 'RM-XXXXX';
patient_data.date = '2026-02-12';

%% PARAMETER DEMOGRAFI / KLINIS

% Usia (bulan)
patient_data.age_months = 120;  % Ganti dengan usia pasien

% Jenis Kelamin ('M' atau 'F')
patient_data.sex = 'M';  % Ganti dengan jenis kelamin pasien

% Antropometri
patient_data.height_cm = 135;  % Ganti dengan tinggi pasien
patient_data.weight_kg = 28;   % Ganti dengan berat pasien

% Body Surface Area (BSA) - otomatis dihitung
patient_data.BSA = sqrt((patient_data.height_cm * patient_data.weight_kg) / 3600);

% Ross Classification (I, II, III, atau IV)
patient_data.ross_class = 'II';  % Ganti sesuai klasifikasi

% Mitral Regurgitation (moderate-to-massive: true/false)
patient_data.mitral_regurgitation = false;  % Ganti sesuai kondisi

% Voltage Limb Leads (low: true/false)
patient_data.voltage_low = false;  % Ganti sesuai EKG

% Vasoactive Drugs (membutuhkan: true/false)
patient_data.vasoactive_drugs = false;  % Ganti sesuai terapi

%% PARAMETER HEMODINAMIK (dari Ekokardiografi) - WAJIB!

% Heart Rate (bpm)
patient_data.HR = 95;  % ← ISI DARI ECHO

% Tekanan Aorta (mmHg)
patient_data.Pao_sys = 100;   % ← ISI DARI ECHO (Sistolik)
patient_data.Pao_dias = 55;   % ← ISI DARI ECHO (Diastolik)

% Volume Ventrikel Kiri (mL)
patient_data.Vlv_dias = 120;  % ← ISI DARI ECHO (LVEDV)
patient_data.Vlv_sys = 65;    % ← ISI DARI ECHO (LVESV)

% Volume Ventrikel Kanan (mL)
patient_data.Vrv_dias = 90;   % ← ISI DARI ECHO (RVEDV)
patient_data.Vrv_sys = 35;    % ← ISI DARI ECHO (RVESV)

% Diameter Ventrikel Kiri (cm) - dari M-Mode
patient_data.Dlv_dias = 5.0;  % ← ISI DARI ECHO (LVEDD)
patient_data.Dlv_sys = 3.8;   % ← ISI DARI ECHO (LVESD)

% Diameter Ventrikel Kanan (cm) - OPSIONAL
% Jika tidak ada di echo, biarkan NaN
patient_data.Drv_dias = NaN;  % Atau isi jika ada
patient_data.Drv_sys = NaN;   % Atau isi jika ada

% Panjang Sumbu Panjang Ventrikel (cm) - WAJIB!
% CATATAN: Gunakan KONSTAN sesuai asumsi Bozkurt 2022
patient_data.llv = 6.8;       % ← ISI DARI ECHO
patient_data.llv_sys = 6.8;   % Sama dengan llv (konstan)
patient_data.llv_dias = 6.8;  % Sama dengan llv (konstan)

patient_data.lrv = 6.0;       % ← ISI DARI ECHO
patient_data.lrv_sys = 6.0;   % Sama dengan lrv (konstan)
patient_data.lrv_dias = 6.0;  % Sama dengan lrv (konstan)

% Cardiac Output (L/min)
patient_data.CO = 4.2;  % ← ISI DARI ECHO

%% PARAMETER VALIDASI (jika tersedia)

% Fractional Shortening (%)
% Jika tidak ada, hitung: FS = ((LVEDD - LVESD) / LVEDD) × 100
patient_data.FS_measured = ((patient_data.Dlv_dias - patient_data.Dlv_sys) / patient_data.Dlv_dias) * 100;

% Ejection Fraction (%)
patient_data.EF_measured = 46;  % ← ISI DARI ECHO

%% HITUNG PARAMETER TURUNAN (otomatis)

% Mean Arterial Pressure (mmHg)
patient_data.MAP = (patient_data.Pao_sys + 2*patient_data.Pao_dias) / 3;

% Stroke Volume (mL)
patient_data.SV = patient_data.Vlv_dias - patient_data.Vlv_sys;

% Cardiac Index (L/min/m^2)
patient_data.CI = patient_data.CO / patient_data.BSA;

%% KLASIFIKASI DCM (otomatis)

if patient_data.EF_measured < 45
    patient_data.DCM_severity = 'Severe';
elseif patient_data.EF_measured < 55
    patient_data.DCM_severity = 'Mild';
else
    patient_data.DCM_severity = 'Normal';
end

%% DISPLAY SUMMARY
fprintf('========================================\n');
fprintf('  DATA PASIEN 001\n');
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
fprintf('EF           : %.1f%%\n', patient_data.EF_measured);
fprintf('FS           : %.1f%%\n', patient_data.FS_measured);
fprintf('----------------------------------------\n');
fprintf('DCM Severity : %s\n', patient_data.DCM_severity);
fprintf('========================================\n\n');

fprintf('✓ Data pasien siap!\n');
fprintf('Sekarang jalankan: >> main_simulation\n\n');
