function validation = validate_results(t, y, patient_data, params)
% VALIDATE_RESULTS - Validasi hasil simulasi dengan data klinis
%
% Input:
%   t            - vektor waktu (s)
%   y            - state matrix dari ODE solver
%   patient_data - data klinis pasien
%   params       - parameter model
%
% Output:
%   validation   - struktur hasil validasi

%% EKSTRAK STATE VARIABLES
Vlv = y(:,1);
Vla = y(:,2);
Vrv = y(:,3);
Vra = y(:,4);
pao = y(:,5);

%% HITUNG TEKANAN VENTRIKEL
n_points = length(t);
plv_all = zeros(n_points, 1);
prv_all = zeros(n_points, 1);

T = params.T;
T1 = params.T1;
T2 = params.T2;

for i = 1:n_points
    t_cycle = mod(t(i), T);
    
    % Activation function
    if t_cycle < T1
        fact_lv = (1 - cos(t_cycle/T1 * pi)) / 2;
        fact_rv = fact_lv;
    elseif t_cycle < T2
        fact_lv = (1 + cos((t_cycle-T1)/(T2-T1) * pi)) / 2;
        fact_rv = fact_lv;
    else
        fact_lv = 0;
        fact_rv = 0;
    end
    
    % Left ventricle pressure
    plv_a = params.Ees_lv * (Vlv(i) - params.V0_lv) * fact_lv;
    plv_p = params.Alv * (exp(params.Blv * Vlv(i)) - 1);
    plv_all(i) = plv_a + plv_p;
    
    % Right ventricle pressure
    prv_a = params.Ees_rv * (Vrv(i) - params.V0_rv) * fact_rv;
    prv_p = params.Arv * (exp(params.Brv * Vrv(i)) - 1);
    prv_all(i) = prv_a + prv_p;
end

%% HITUNG DIAMETER VENTRIKEL
% Left ventricle
rlv = sqrt(6*Vlv / (4*pi*params.Klv*params.llv));
Dlv_all = 2 * rlv;  % Diameter = 2 * radius

% Right ventricle (basal diameter ≈ radius karena geometri)
rrv = sqrt(3*Vrv / (pi*params.Krv*params.lrv));
Drv_all = rrv;  % Basal diameter

%% EKSTRAK NILAI END-SYSTOLIC DAN END-DIASTOLIC

% Find peaks and valleys
[~, idx_sys_lv] = min(Vlv);  % End-systole = minimum volume
[~, idx_dias_lv] = max(Vlv);  % End-diastole = maximum volume

% Left ventricle
Vlv_sys = Vlv(idx_sys_lv);
Vlv_dias = Vlv(idx_dias_lv);
plv_sys = plv_all(idx_sys_lv);
plv_dias = plv_all(idx_dias_lv);
Dlv_sys = Dlv_all(idx_sys_lv);
Dlv_dias = Dlv_all(idx_dias_lv);

% Right ventricle
Vrv_sys = Vrv(idx_sys_lv);
Vrv_dias = Vrv(idx_dias_lv);
prv_sys = prv_all(idx_sys_lv);
prv_dias = prv_all(idx_dias_lv);
Drv_sys = Drv_all(idx_sys_lv);
Drv_dias = Drv_all(idx_dias_lv);

% Aortic pressure
Pao_sys = max(pao);
Pao_dias = min(pao);
MAP = mean(pao);

%% HITUNG PARAMETER KLINIS

% Stroke Volume
SV_lv = Vlv_dias - Vlv_sys;  % mL
SV_rv = Vrv_dias - Vrv_sys;  % mL

% Ejection Fraction
EF_lv = (SV_lv / Vlv_dias) * 100;  % %
EF_rv = (SV_rv / Vrv_dias) * 100;  % %

% Cardiac Output
CO = SV_lv * params.HR / 1000;  % L/min

% Fractional Shortening
FS = ((Dlv_dias - Dlv_sys) / Dlv_dias) * 100;  % %

% Sphericity Index
SI_dias = params.llv / Dlv_dias;
SI_sys = params.llv / Dlv_sys;

%% HITUNG ERROR DENGAN DATA KLINIS

% Pressure errors
error_Pao_sys = abs(Pao_sys - patient_data.Pao_sys) / patient_data.Pao_sys * 100;
error_Pao_dias = abs(Pao_dias - patient_data.Pao_dias) / patient_data.Pao_dias * 100;

% Volume errors
error_Vlv_sys = abs(Vlv_sys - patient_data.Vlv_sys) / patient_data.Vlv_sys * 100;
error_Vlv_dias = abs(Vlv_dias - patient_data.Vlv_dias) / patient_data.Vlv_dias * 100;
error_Vrv_sys = abs(Vrv_sys - patient_data.Vrv_sys) / patient_data.Vrv_sys * 100;
error_Vrv_dias = abs(Vrv_dias - patient_data.Vrv_dias) / patient_data.Vrv_dias * 100;

% Diameter errors
error_Dlv_sys = abs(Dlv_sys - patient_data.Dlv_sys) / patient_data.Dlv_sys * 100;
error_Dlv_dias = abs(Dlv_dias - patient_data.Dlv_dias) / patient_data.Dlv_dias * 100;

% Cardiac output error
error_CO = abs(CO - patient_data.CO) / patient_data.CO * 100;

% Ejection fraction error
if isfield(patient_data, 'EF_measured')
    error_EF = abs(EF_lv - patient_data.EF_measured) / patient_data.EF_measured * 100;
else
    error_EF = NaN;
end

% Fractional shortening error
if isfield(patient_data, 'FS_measured')
    error_FS = abs(FS - patient_data.FS_measured) / patient_data.FS_measured * 100;
else
    error_FS = NaN;
end

%% OUTPUT STRUCTURE
validation = struct();

% Simulated values
validation.Pao_sys = Pao_sys;
validation.Pao_dias = Pao_dias;
validation.MAP = MAP;
validation.Vlv_sys = Vlv_sys;
validation.Vlv_dias = Vlv_dias;
validation.Vrv_sys = Vrv_sys;
validation.Vrv_dias = Vrv_dias;
validation.Dlv_sys = Dlv_sys;
validation.Dlv_dias = Dlv_dias;
validation.Drv_sys = Drv_sys;
validation.Drv_dias = Drv_dias;
validation.SV = SV_lv;
validation.EF = EF_lv;
validation.EF_rv = EF_rv;
validation.CO = CO;
validation.FS = FS;
validation.SI_dias = SI_dias;
validation.SI_sys = SI_sys;

% Errors
validation.error_Pao_sys = error_Pao_sys;
validation.error_Pao_dias = error_Pao_dias;
validation.error_Vlv_sys = error_Vlv_sys;
validation.error_Vlv_dias = error_Vlv_dias;
validation.error_Vrv_sys = error_Vrv_sys;
validation.error_Vrv_dias = error_Vrv_dias;
validation.error_Dlv_sys = error_Dlv_sys;
validation.error_Dlv_dias = error_Dlv_dias;
validation.error_CO = error_CO;
validation.error_EF = error_EF;
validation.error_FS = error_FS;

% Time series for plotting
validation.plv_all = plv_all;
validation.prv_all = prv_all;
validation.Dlv_all = Dlv_all;
validation.Drv_all = Drv_all;

end
