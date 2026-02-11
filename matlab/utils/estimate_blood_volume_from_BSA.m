function [TBV_est, UBV_est, SBV_est] = estimate_blood_volume_from_BSA(BSA, age_months, sex)
% ESTIMATE_BLOOD_VOLUME_FROM_BSA - Estimasi volume darah dari BSA
% Berdasarkan linear regression dari literatur pediatrik
%
% Input:
%   BSA         - Body Surface Area (m^2)
%   age_months  - Usia dalam bulan
%   sex         - 'M' atau 'F'
%
% Output:
%   TBV_est - Total Blood Volume (mL)
%   UBV_est - Unstressed Blood Volume (mL) - ~70% dari TBV
%   SBV_est - Stressed Blood Volume (mL) - ~30% dari TBV
%
% Referensi:
% - Raes et al. (2006) - BMC Pediatrics: Blood volume in children
% - Linderkamp et al. (1977) - Eur J Paediatr: Blood volume estimation
%
% CATATAN: Ini adalah ESTIMASI awal. Model akan mengoptimasi
% parameter sirkulasi (Vblood) untuk mendapatkan nilai yang lebih akurat.

%% PERSAMAAN REGRESI LINEAR DARI LITERATUR

% Berdasarkan Raes et al. (2006) - Tabel 3
% Linear regression: BV = slope × BSA + intercept

% Untuk anak-anak (kombinasi male & female)
% Slope dan intercept dari regresi BV vs BSA
if strcmpi(sex, 'M')
    % Male: BV (ml) = 2836 × BSA (m^2) - 669
    slope = 2836;
    intercept = -669;
else
    % Female: BV (ml) = 2846 × BSA (m^2) - 1
    slope = 2846;
    intercept = -1;
end

%% HITUNG TOTAL BLOOD VOLUME (TBV)
TBV_est = slope * BSA + intercept;

% Pastikan tidak negatif
if TBV_est < 0
    warning('Estimated TBV is negative! Using minimum value of 500 mL');
    TBV_est = 500;  % Minimum reasonable value
end

%% HITUNG UNSTRESSED BLOOD VOLUME (UBV)
% UBV adalah volume darah yang tidak aktif berkontribusi pada sirkulasi
% Biasanya ~70% dari TBV (Frank-Starling mechanism)
UBV_fraction = 0.70;  % 70% dari TBV
UBV_est = TBV_est * UBV_fraction;

%% HITUNG STRESSED BLOOD VOLUME (SBV)
% SBV adalah volume darah yang aktif dalam sirkulasi
% Biasanya ~30% dari TBV
SBV_est = TBV_est - UBV_est;  % 30% dari TBV

%% KOREKSI UNTUK USIA (opsional)
% Untuk bayi dan anak sangat muda, volume darah per kg lebih tinggi
% Tapi karena kita sudah menggunakan BSA, koreksi ini minimal

if age_months < 12
    % Bayi < 1 tahun: volume darah relatif lebih tinggi
    correction_factor = 1.1;  % +10%
    TBV_est = TBV_est * correction_factor;
    UBV_est = UBV_est * correction_factor;
    SBV_est = SBV_est * correction_factor;
elseif age_months < 24
    % Anak 1-2 tahun: sedikit lebih tinggi
    correction_factor = 1.05;  % +5%
    TBV_est = TBV_est * correction_factor;
    UBV_est = UBV_est * correction_factor;
    SBV_est = SBV_est * correction_factor;
end

%% DISPLAY INFO (opsional)
% fprintf('   Estimasi Volume Darah dari BSA:\n');
% fprintf('   BSA: %.2f m^2\n', BSA);
% fprintf('   TBV (Total): %.0f mL\n', TBV_est);
% fprintf('   UBV (70%%): %.0f mL\n', UBV_est);
% fprintf('   SBV (30%%): %.0f mL\n', SBV_est);

end
