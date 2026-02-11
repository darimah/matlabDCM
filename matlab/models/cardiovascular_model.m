function dydt = cardiovascular_model(t, y, params)
% CARDIOVASCULAR_MODEL - Model sistem kardiovaskular lengkap
% Berdasarkan Bozkurt et al. (2022)
%
% Input:
%   t      - waktu (s)
%   y      - state vector [Vlv, Vla, Vrv, Vra, pao, Qao, pas, Qas, ...]
%   params - struktur parameter model
%
% Output:
%   dydt   - turunan state vector

% Ekstrak state variables
Vlv = y(1);   % Volume ventrikel kiri (mL)
Vla = y(2);   % Volume atrium kiri (mL)
Vrv = y(3);   % Volume ventrikel kanan (mL)
Vra = y(4);   % Volume atrium kanan (mL)
pao = y(5);   % Tekanan aorta (mmHg)
Qao = y(6);   % Aliran aorta (mL/s)
pas = y(7);   % Tekanan arteri sistemik (mmHg)
Qas = y(8);   % Aliran arteri sistemik (mL/s)
pvs = y(9);   % Tekanan vena sistemik (mmHg)
ppo = y(10);  % Tekanan arteri pulmonal (mmHg)
Qpo = y(11);  % Aliran arteri pulmonal (mL/s)
pap = y(12);  % Tekanan arteriol pulmonal (mmHg)
Qap = y(13);  % Aliran arteriol pulmonal (mL/s)
pvp = y(14);  % Tekanan vena pulmonal (mmHg)

% Ekstrak parameter
Ees_lv = params.Ees_lv;
Ees_rv = params.Ees_rv;
V0_lv = params.V0_lv;
V0_rv = params.V0_rv;
Alv = params.Alv;
Arv = params.Arv;
Blv = params.Blv;
Brv = params.Brv;
Klv = params.Klv;
Krv = params.Krv;
llv = params.llv;
lrv = params.lrv;

% Parameter sirkulasi
Rao = params.Rao;
Cao = params.Cao;
Ras = params.Ras;
Cas = params.Cas;
Rvs = params.Rvs;
Cvs = params.Cvs;
Rpo = params.Rpo;
Cpo = params.Cpo;
Rap = params.Rap;
Cap = params.Cap;
Rvp = params.Rvp;
Cvp = params.Cvp;

% Parameter katup (fixed)
Rmv_f = 0.002;    % Mitral forward
Rmv_b = 1e16;     % Mitral backward (ideal diode)
Rav_f = 0.002;    % Aortic forward
Rav_b = 1e16;     % Aortic backward
Rtv_f = 0.001;    % Tricuspid forward
Rtv_b = 1e16;     % Tricuspid backward
Rpv_f = 0.001;    % Pulmonary forward
Rpv_b = 1e16;     % Pulmonary backward

% Parameter atrium (fixed)
Kla = 2.0;
Kra = 2.0;
lla = 4.0;  % cm
lra = 4.0;  % cm
Emax_la = 0.3;  % mmHg/mL
Emin_la = 0.2;  % mmHg/mL
Emax_ra = 0.3;  % mmHg/mL
Emin_ra = 0.2;  % mmHg/mL

% Inertance (fixed, negligible)
Lao = 1e-5;
Las = 1e-5;
Lpo = 1e-5;
Lap = 1e-5;

% Waktu dalam siklus jantung
T = params.T;
t_cycle = mod(t, T);

%% FUNGSI AKTIVASI

% Ventrikel
T1 = params.T1;
T2 = params.T2;
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

% Atrium (delayed activation)
Ta = 0.8 * T;
D = 0.04;  % delay
t_atrial = mod(t - D, T);
if t_atrial < Ta
    fact_la = 0;
    fact_ra = 0;
else
    fact_la = 1 - cos(2*pi*(t_atrial-Ta)/(T-Ta));
    fact_ra = fact_la;
end

% Elastance atrium
Ela = Emin_la + 0.5 * (Emax_la - Emin_la) * fact_la;
Era = Emin_ra + 0.5 * (Emax_ra - Emin_ra) * fact_ra;

%% TEKANAN VENTRIKEL KIRI

% Active component
plv_a = Ees_lv * (Vlv - V0_lv) * fact_lv;

% Passive component
plv_p = Alv * (exp(Blv * Vlv) - 1);

% Total pressure
plv = plv_a + plv_p;

%% TEKANAN VENTRIKEL KANAN

% Active component
prv_a = Ees_rv * (Vrv - V0_rv) * fact_rv;

% Passive component
prv_p = Arv * (exp(Brv * Vrv) - 1);

% Total pressure
prv = prv_a + prv_p;

%% TEKANAN ATRIUM

% Radius atrium
rla = sqrt(6*Vla / (4*pi*Kla*lla));
rra = sqrt(6*Vra / (4*pi*Kra*lra));

% Zero pressure radius (estimasi)
rla_0 = 0.5;  % cm
rra_0 = 0.5;  % cm

% Pressure
pla = Ela * (4/6) * pi * Kla * lla * (rla^2 - rla_0^2);
pra = Era * (4/6) * pi * Kra * lra * (rra^2 - rra_0^2);

%% ALIRAN KATUP

% Mitral valve
if pla > plv
    Qmv = (pla - plv) / Rmv_f;
else
    Qmv = (pla - plv) / Rmv_b;
end

% Aortic valve
if plv > pao
    Qav = (plv - pao) / Rav_f;
else
    Qav = (plv - pao) / Rav_b;
end

% Tricuspid valve
if pra > prv
    Qtv = (pra - prv) / Rtv_f;
else
    Qtv = (pra - prv) / Rtv_b;
end

% Pulmonary valve
if prv > ppo
    Qpv = (prv - ppo) / Rpv_f;
else
    Qpv = (prv - ppo) / Rpv_b;
end

%% PERSAMAAN DIFERENSIAL

% Ventrikel
dVlv_dt = Qmv - Qav;
dVrv_dt = Qtv - Qpv;

% Atrium
dVla_dt = (pvp - pla) / Rvp - Qmv;  % Simplified: Qvp = (pvp-pla)/Rvp
dVra_dt = (pvs - pra) / Rvs - Qtv;  % Simplified: Qvs = (pvs-pra)/Rvs

% Aorta
dpao_dt = (Qav - Qao) / Cao;
dQao_dt = (pao - pas - Rao*Qao) / Lao;

% Systemic arteries
dpas_dt = (Qao - Qas) / Cas;
dQas_dt = (pas - pvs - Ras*Qas) / Las;

% Systemic veins
dpvs_dt = (Qas - (pvs-pra)/Rvs) / Cvs;

% Pulmonary artery
dppo_dt = (Qpv - Qpo) / Cpo;
dQpo_dt = (ppo - pap - Rpo*Qpo) / Lpo;

% Pulmonary arterioles
dpap_dt = (Qpo - Qap) / Cap;
dQap_dt = (pap - pvp - Rap*Qap) / Lap;

% Pulmonary veins
dpvp_dt = (Qap - (pvp-pla)/Rvp) / Cvp;

%% OUTPUT
dydt = zeros(14, 1); % jumlah 14 harus sesuai dengan lin 170 di main_simulation
dydt(1) = dVlv_dt;
dydt(2) = dVla_dt;
dydt(3) = dVrv_dt;
dydt(4) = dVra_dt;
dydt(5) = dpao_dt;
dydt(6) = dQao_dt;
dydt(7) = dpas_dt;
dydt(8) = dQas_dt;
dydt(9) = dpvs_dt;
dydt(10) = dppo_dt;
dydt(11) = dQpo_dt;
dydt(12) = dpap_dt;
dydt(13) = dQap_dt;
dydt(14) = dpvp_dt;

end
