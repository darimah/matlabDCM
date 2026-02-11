 PDF To Markdown Converter
Debug View
Result View
Patient-Specific Modelling and Parameter Optimisation to Simulate Dilated Cardiomyopathy in Children
Original Article

Patient-Specific Modelling and Parameter Optimisation to Simulate
Dilated Cardiomyopathy in Children
SELIMBOZKURT ,1,2WALEEDPARACHA,^3 KAUSHIKIBAKAYA,^3 and SILVIASCHIEVANO^2
(^1) School of Engineering, Ulster University, Newtownabbey, UK; (^2) Institute of Cardiovascular Science, University College
London, London, UK; and^3 University College London Medical School, London, UK
(Received 6 May 2021; accepted 2 February 2022; published online 22 February 2022)
Abstract
Purpose—Lumped parameter modelling has been widely
used to simulate cardiac function and physiological scenarios
in cardiovascular research. Whereas several patient-specific
lumped parameter models have been reported for adults,
there is a limited number of studies aiming to simulate
cardiac function in children. The aim of this study is to
simulate patient-specific cardiovascular dynamics in children
diagnosed with dilated cardiomyopathy, using a lumped
parameter model.
Methods—Patient data including age, gender, heart rate, left
and right ventricular end-systolic and end-diastolic volumes,
cardiac output, systolic and diastolic aortic pressures were
collected from 3 patients at Great Ormond Street Hospital
for Children, London, UK. Ventricular geometrical data
were additionally retrieved from cardiovascular magnetic
resonance images. 23 parameters in the lumped parameter
model were optimised to simulate systolic and diastolic
pressures, end-systolic and end-diastolic volumes, cardiac
output and left and right ventricular diameters in the patients
using a direct search optimisation method.
Results—Difference between the haemodynamic parameters
in the optimised cardiovascular system models and clinical
data was less than 10%.
Conclusion—The simulation results show the potential of
patient-specific lumped parameter modelling to simulate
clinical cases. Modelling patient specific cardiac function
and blood flow in the paediatric patients would allow us to
evaluate a variety of physiological scenarios and treatment
options.
Keywords—Lumped parameter model, Patient-specific car-
diac function, Dilated cardiomyopathy, Paediatrics.

ABBREVIATIONS
p Pressure
Q Flow rate
V Volume
R Resistance
L Inertance
C Compliance
E Elastance
A Coefficient
B Coefficient
K Coefficient
D Diameter
r Radius
l Length
MV Mitral valve
AV Aortic valve
TV Tricuspid valve
PV Pulmonary valve
EF Ejection fraction
SV Stroke volume
EDV End-diastolic volume
CO Cardiac output
MAP Mean arterial pressure
f Function
h Step
n Iteration number
Subscripts
la Left atrium
lv Left ventricle
ra Right atrium
rv Right ventricle
ao Aorta
Address correspondence to Selim Bozkurt, School of Engineer-
ing, Ulster University, Newtownabbey, UK. Electronic mail:
s.bozkurt1@ulster.ac.uk

Cardiovascular Engineering and Technology, Vol. 13, No. 5, October 2022(Ó2022)pp. 712–
https://doi.org/10.1007/s13239-022-00611-

BIOMEDICAL
ENGINEERING
SOCIETY
1869-408X/22/1000-0712/0Ó2022 The Author(s)

712
as Systemic arterioles
vs Systemic veins
po Pulmonary arteries
ap Pulmonary arterioles
vp Pulmonary veins
mv Mitral valve
av Aortic valve
tv Tricuspid valve
pv Pulmonary valve
b Backward
f Forward
es End-diastolic
sys Systolic
dias Diastolic
v Ventricle
act Activation
0 Zero (pressure)
a Active
p Passive
ub Upper bound
lb Lower bound
m Model
pt Patient
blood Blood

INTRODUCTION
Lumped parameter modelling has been widely
adopted to simulate cardiac function and physiological
scenarios in cardiovascular research as they allow to
study complex conditions in a simplified manner. For
instance, heart failure has been simulated using this
method by reducing systolic elastance, which describe
the relationship between left ventricular pressure and
volume.^2 Ventricular wall mechanics have been mod-
elled using active and passive stresses on a fibre which
in turn have been utilised to simulate and heart failure
and mechanical circulatory support in adults.^5 Multi-
scale models which include cellular, protein and organ
level dynamics have also been utilised to simulate heart
failure in adults.^1 Atrial function in adults have been
simulated using a multi-scale model.^25 Dynamics of
heart valves have been modelled to simulate blood flow
through the healthy and diseased heart valves in
adults.^16 Lumped parameter models simulating heart
failure or heart valve dynamics have been utilised to
evaluate treatment techniques such heart pump sup-
port in adults. For instance, Gross et al.^12 evaluated
the effect of left ventricular assist device speed increase
during exercise in a model simulating heart failure. Liu
et al.^20 evaluated varying speed modulation algorithms
for continuous-flow left ventricular assist devices based
on a cardiovascular coupling numerical model. Mod-

elling of cardiac function and simulation of physio-
logical cases in adults have been studied extensively
and detailed information can be found in the litera-
ture.^18
Lumped parameter models simulating patient-
specific cardiac dynamics in adults have already been
developed. For instance, Ellwein et al.^7 developed a
patient-specific model of cardiovascular and respira-
tory systems during hypercapnia. Pope et al.^26 showed
how sensitivity analysis and subset selection can be
employed in a cardiovascular model to estimate system
parameters for healthy young and elderly subjects.
Neal and Bassingthwaighte^22 developed a method to
estimate subject-specific cardiac output and blood
volume during haemorrhage. There is a limited num-
ber of studies aiming to simulate physiological cases in
children where there is a need for such models. Schi-
avazzi et al.^29 estimated parameters of patient-specific
in single-ventricle lumped circulation models under
uncertainty. Goodwin et al.^10 developed a model sim-
ulating infant cardiovascular physiology for educa-
tional purposes. Sa ́ Couto et al.^28 developed a
cardiovascular system model to simulate neonatal
physiology. Giridharan et al.^9 developed a computer
model of the paediatric circulatory system to test
ventricular assist devices. Petukhov and Telyshev^24
developed a cardiovascular system model for paedi-
atric patients with congenital heart diseases. Bozkurt^3
developed a cardiovascular system model capable of
simulating cardiac function and heart chamber
dimensions over a cardiac cycle in adults and children.
Mostly, average models describing generalised
physiology in adults and children have been utilised to
simulate physiological scenarios such as heart failure.
However, causes of heart failure vary significantly
from patient to patient and indeed, several different
therapies, including digoxin, beta-blockers, diuretics or
angiotensin-converting enzyme inhibitors, are used to
improve heart failure.^14 Moreover, in children, clinical
decisions are often dependant on results recorded in
adult heart failure trials.^6 Therefore, treatment is
negatively affected as there are substantial difficulties
in adapting adult data to paediatric patients. Patient-
specific numerical models simulating cardiac function
may help to evaluate treatment options for children.
Our previous model^3 presents a concept model in
which the parameters were not optimized to simulate
patient-specific clinical data. It simulates hemody-
namic variables in adults and children within a physi-
ological interval. The aim in this study is to simulate
patient-specific cardiovascular dynamics in children
diagnosed with dilated cardiomyopathy using a new
optimisation strategy which can be applied without
computational cost for parameter identification.
BIOMEDICAL
ENGINEERING
Patient-Specific Modelling and Parameter Optimisation 713
MATERIALS AND METHODS
The following demographics and hemodynamic
parameters were collected from 3 patients diagnosed
with dilated cardiomyopathy at Great Ormond Street
Hospital for Children, London, UK, by searching the
clinical database: age, gender, heart rate, cardiac out-
put, left and right ventricular end-systolic and end-di-
astolic volumes, systolic and diastolic aortic pressures.
The patients were selected to simulate mild and severe
dilated cardiomyopathy in the left ventricle and
biventricular dysfunction.
Cardiac magnetic resonance images (1.5-Tesla
Magnetom Avanto scanner, Siemens Medical Solu-
tions, Erlangen, Germany) were reviewed for these
patients. The steady-state free precession sequences
acquired at both end-diastole, and end-systole, were
used to measure cardiac dimensions in Simpleware
ScanIP 2018 (Synopsis, CA, USA). Four-chamber
view was used to measure left and right ventricular
long axis length and right ventricular basal diameter;
the short-axis view was used to measure left ventricular
lateral-septal diameter.

Patient Information
In children, dilated cardiomyopathy is diagnosed
considering z-scores for ventricular ejection fraction,
ventricular volume and ventricular end-diastolic and
end-systolic diameters indexed on body surface area
and measurements of the ventricular systolic function
(z-score>2).^19 ,^31
Patient 1 (male, age at scan = 8 years 7 months,
body surface area = 0.94 m^2 ) was diagnosed with mild
dilated cardiomyopathy. There were no signs of left
ventricular hypertrophy, atrial dilation, atrio-ventric-
ular valve regurgitation, and outflow tracts’ obstruc-
tion. Both aortic and pulmonary valves were
competent, with no stenosis. The right ventricle had
normal global systolic function and volume. Cardiac
output was 5.3 L/min, and systolic and diastolic pres-
sures were 109 mmHg and 60 mmHg, respectively.
End-diastolic volume was 106 mmHg (z-score=2.1).
Patient 2 (female, age at scan = 10 years 8 months,
body surface area = 0.94 m^2 ) was diagnosed with
severe dilated cardiomyopathy. She presented with
global thinning of the myocardium with no left ven-
tricular hypertrophy. There was no left atrial dilatation
and no mitral regurgitation on volume measurements.
There was no left ventricular outflow tract obstruction
and the aortic valve had normal function. The right
atrium was not dilated. There was no tricuspid valve
regurgitation. There was no right ventricular outflow
tract obstruction. The pulmonary valve was competent
with no stenosis. Cardiac output was 2.6 L/min, and

systolic and diastolic pressures were 84 mmHg and 49
mmHg, respectively.
Patient 3 (male, age at scan = 15 years 2 months,
body surface area = 1.44 m^2 ) was diagnosed with
severe cardiomyopathy with biventricular dysfunction
and raised pulmonary pressure. The right atrium was
dilated, whilst the left atrial chamber remained normal.
There was 37% tricuspid valve regurgitation. The right
ventricular myocardium was moderately hypertro-
phied, with globally poor contractility and evidence of
severely impaired diastolic function. The right ventricle
was dilated at both end-diastole and end-systole. There
was no left ventricular hypertrophy. The left ventric-
ular chamber was of low-normal body surface area
indexed volume at end-diastole, and normal volume at
end-systole, appearing under-filled, with a global
impairment of systolic function. The pulmonary valve
was unobstructed whilst there was 11% pulmonary
valve regurgitation. The aortic valve was competent.
Cardiac output was 2.6 L/min, and systolic and dias-
tolic pressures were 118 mmHg and 64 mmHg,
respectively.
Cardiovascular System Model
The cardiovascular system model used in this study
simulates pressures, volumes and diameters in the
heart chambers, flow rate through the heart valves, and
pressures and flow rates in the systemic and pulmonary
circulations. The left ventricular pressure (plv) was de-
scribed using the active and passive contraction com-
ponents (plv,a, plv,p). The ventricular active pressure
component was described using systolic ventricular
elastance (Ees,lv), ventricular volume and zero-pressure
volume (Vlv,Vlv,0), and the activation function (fact,lv).
The ventricular passive pressure component (plv,p) was
modelled using an exponential relationship including
volume (Vlv) and additional coefficients (A,B). De-
tailed information about the cardiovascular system
model can be found in.^3
plv¼plv;aþplv;p ð 1 Þ
plv;a¼Ees;lvðVlvVlv; 0 Þfact;lvðtÞð 2 Þ
plv;p¼AeðBVlvÞ 1
hi
ð 3 Þ
Left ventricular volume (Vlv) was described using
the left ventricular radius (rlv), long axis length (llv)and
an additional coefficient (Klv), which includes effects of
the contraction in the long axis and scales the pro-
portion between the left ventricular radius and volume
over a cardiac cycle. Change of the left ventricular
radius (rlv) were described utilising the flow rates
BIOMEDICAL
ENGINEERING
714 BOZKURTet al.

through the aortic and mitral valves (Qav,Qmv), the left
ventricular volume (Vlv)and long axis length (llv), and
the coefficientKlv.

Vlv¼
2
3
pKlvr^2 lvllv ð 4 Þ
drlv
dt
¼
3 ðQmvQavÞ
4 pKlvllv
3 Vlv
2 pKlvllv
 1 = 2
ð 5 Þ
The left atrial pressure (pla) and volume (Vla) rela-
tionship was described using the elastance (Ela).

pla¼ElaðtÞðVlaVla; 0 Þð 6 Þ
The left atrial volume (Vla) was described using the
left atrial radius (rla) and long axis length (lla), and an
additional coefficient (Kla). Changes of the left atrial
radius (rla) were described utilising the flow rates
through the mitral valve and pulmonary vein (Qmv,
Qvp), the left atrial volume (Vla) and long axis length
(lla), and the coefficientKla.

Vla¼
2
3
pKlar^2 lalla ð 7 Þ
drla
dt
¼
3 ðQvpQmvÞ
4 pKlalla
3 Vla
2 pKlalla
 1 = 2
ð 8 Þ
The right atrium and ventricle were modelled in the
same way as the left atrium and ventricle, using the
different parameter values.
Heart valves were modelled using the pressure
across the valve and the characteristic resistances for
the forward and backward flows (Rmv,f,Rmv,b) to sim-
ulate regurgitant valve flow in the patients. The flow
rate expression through the mitral valve is provided
below.

Qmv¼
plaplv
Rmv;f
pla>plv
plaplv
Rmv;b
pla<plv
8
>>
<
>>
:
ð 9 Þ
The other heart valves were modelled in a similar
way using the appropriate parameter values.
The circulatory system included the aorta, the sys-
temic arteries and veins, and the pulmonary arteries
and veins. Blood flow in the circulatory system was
described using a lumped parameter model, which in-
cluded electrical analogues for resistance (R), compli-
ance (C) and inertia (L). The aortic blood pressure
(pao) and flow rate signals (Qao) are provided below.

dpao
dt
¼
QavQao
Cao
ð 10 Þ
dQao
dt
¼
paopasRaoQao
Lao
ð 11 Þ
hereQavandpasrepresent the aortic valve flow rate
and systemic arteriolar pressure, respectively, andCao,
RaoandLaorepresenting compliance, resistance and
inertance in the aorta, respectively. The electric-ana-
logue of the cardiovascular system model is repre-
sented in Figure 1.
Ejection fraction (EF) in the cardiovascular system
models were calculated as given below.
EF¼
SV
EDV
 100 ð 12 Þ
Here,SVandEDVare the ventricular stroke and
end-diastolic volumes.
Parameter Optimisation
Parameters were optimised for each patient to sim-
ulate systolic and diastolic pressures, end-systolic and
end-diastolic volumes, cardiac output, and left and
right ventricular diameters according to the retrieved
clinical data, using a direct search method.
Flowchart describing the optimisation algorithm is
given in Figure 2.
The objective function (f) in the optimisation pro-
cess aimed to minimise the difference in mean arterial
pressure (MAP) and cardiac output (CO) between
clinical data and the cardiovascular system model. The
optimisation algorithm was designed to find a quick
and effective solution for parameter estimation prob-
lem with multiple variables such as in the presented
cardiovascular system model. The utilised optimisation
method evaluates multiple variables in each simulation
and effectively finds optimal solutions without com-
putational cost.
The utilised electric analogue model of blood vessels
simulates blood flow by solving ordinary differential
equations for pressures and flow rates in each com-
partment. Heart chambers simulate pressure and vol-
ume which in turn affects the cardiac output the
cardiovascular system. Error functions and objective
function includes flow rate (CO) and pressure (MAP)
terms to ensure that objective function is sensitive to
the parameter set in thexvector. MAP in the cardio-
vascular system model is the time-averaged aortic
pressure (pao) over a cardiac cycle in each patient.
fðxÞ¼jjfMAPðxÞþfCOðxÞ ð 13 Þ
fMAPðxÞ¼
MAPptMAPmðxÞ
MAPpt
ð 14 Þ
BIOMEDICAL
ENGINEERING
Patient-Specific Modelling and Parameter Optimisation 715
fCOðxÞ¼
COptCOmðxÞ
COpt
ð 15 Þ
herefMAPandfCOare the relative error functions for
mean arterial pressure and cardiac output. The

parameter set (x) included left and right ventricular
end-systolic elastances (Ees,lv, Ees,rv), left and right
ventricular zero-pressure volumes (V0,lv, V0,rv), the
coefficients used in the passive pressure components of
the ventricular pressures (Alv,Arv,Blv,Brv), the com-
pliances and resistances of the aorta, systemic arteries,
and veins, pulmonary artery, arterioles and veins (Rao,
Cao,Ras,Cas,Rvs,Cvs,Rpo,Cpo,Rap,Cap,Rvp,Cvp)and
the circulating blood volume (Vblood).
x¼ Ees;lv;Ees;rv;V 0 ;lv;V 0 ;rv;Alv;Arv;Blv;Brv;Rao;Cao;

Ras;Cas;Rvs;Cvs;Rpo;Cpo;Rap;Cap;Rvp;Cvp;Vblood
T
ð 16 Þ
Upper and lower bounds of the optimised parame-
ters (xub,xlb) were chosen around the values from the
concept model published in.^3 Step-size (h) in the opti-
misation was defined using xub, xlb and iteration
number (n) in each simulation, and the parameters
were updated using the initial lower bounds of the
parameters and the step size, except for the coefficients
AandB. These were updated starting with the upper
bounds. Because arterial pressure and cardiac output
decrease with the increasing A and B. Step size (h)and
parameter updates are given in the Equations 17 - 19.
h¼ðxubxlbÞ=n ð 17 Þ
xi¼xlbþhi ð 18 Þ
Ai¼Aubhi ð 19 Þ
The optimisation algorithm was set to complete 10
iterations in one simulation. The upper and lower
bounds of the parameters were updated according to
the values of the objective and error functions. The
simulations were repeated to complete 10 iterations in
each simulation with updated upper and lower bounds
FIGURE 1. The electric analogue model of the of the cardiovascular system.R,LandCdenote resistance, inertance and
compliance,pand denote pressure,MV,AV,TVandPVare mitral, aortic, tricuspid and pulmonary valves,la,lv,raandrvdenote
left atrium and ventricle and right atrium and ventricle,ao,as,vsdenote aorta, systemic arterioles and systemic veins,po,ap,vp
pulmonary arteries, pulmonary arterioles and pulmonary veins.

FIGURE 2. Flowchart of the optimisation algorithm.

BIOMEDICAL
ENGINEERING
716 BOZKURTet al.

until f(x)£0.05, fMAP(x)‡-0.1 and fMAP(x)£0.1,
fCO(x)‡-0.1 andfCO(x)£0.1.
The left and right ventricular diameters were esti-
mated by optimising the coefficients inKlvandKrv.

k ¼½Klv;KrvT ð 20 Þ
The error function for the diastolic and systolic
diameters of the left and right ventricles were defined
as:

fDðkÞ¼
DptDmðkÞ
Dpt
ð 21 Þ
Upper and lower bounds of thekvector (kub,klb)
were chosen around the values from the concept model
published in.^3 Again, the step-size (h) in the optimisa-
tion was defined using kub, klb, and the iteration
number (n) in each simulation and the parameters were
updated using the initial lower bounds of the param-
eters and the step size.KlvandKrvdo not affect any
other variable but ventricular diameters, depending on
the ventricular volumes. Therefore, first ventricular

volumes were optimized and thenKlvandKrvwere
tuned according to the ventricular volumes. Initial
upper and lower bound of the parameters in thek
vector are reported in Table 2.
h¼ðkubklbÞ=n ð 22 Þ
ki¼klbþhi ð 23 Þ
Again, the optimisation algorithm was run to
complete 10 iterations in each simulation. The upper
and lower bounds of the parameters were updated
according to the values of the error functions. The
simulations were repeated to complete 10 iterations in
each simulation with updated upper and lower bounds
untilfD(k)>-0.1 andfD(k)£0.1. Initial upper and lower
bounds of the parameters in thexandkvectors are
reported in Table 1.
Blood volume optimised in this study is the circu-
lating blood volume. Total blood volume in children
for the studied ages changes between 2000 mL and
4000 mL.^27 However, most of the blood volume con-
sists of unstressed blood and constitutes a blood vol-
ume reserve.^11 Circulating blood volume is less than
the total blood volume, therefore, optimised values for
the circulating blood volume were less than the total
blood volume in the cardiovascular system models.
Patient-specific heart rates and left and right ven-
tricular long axis lengths (lv) were used as input values
TABLE 1. Initial upper and lower bounds of the parameters
in the x and k vectors in the cardiovascular system models (E,
V,AandBrepresent elastance, volume and the parameters
used in the passive properties in the ventricle models,R,C
andLrepresent resistance, compliance and inertance of the
blood vessels,Kis a coefficient in the ventricle models,
subscriptses,lv,rv, 0 represent end-systole, left and right
ventricles and initial value,ao,as,vs,po,ap,vpandblood
represent aorta, systemic arteries and veins, pulmonary
artery, arterioles and veins, and blood).

Model 1 Model 2 Model 3
ub lb ub lb ub lb
Ees,lv[mmHg/mL] 3.5 1.5 2.2 0.7 4.75 1.
Ees,rv[mmHg/mL] 2 1 1.6 0.8 0.8 0.
V0,lv[mL] 10 5 25 10 10 0
V0,rv[mL] 10 5 30 15 60 10
Alv[mmHg] 1.3 0.9 1.2 0.8 1.4 1
Arv[mmHg] 1.3 0.9 1.2 0.8 1 0.
Blv[1/mL] 0.03 0.02 0.025 0.015 0.03 0.
Brv[1/mL] 0.03 0.02 0.025 0.015 0.02 0.
Rao[mmHg s/mL] 0.058 0.038 0.17 0.12 0.51 0.
Cao[mL/mmHg] 0.273 0.173 0.273 0.173 0.3 0.
Ras[mmHg s/mL] 1.1 0.5 1.4 0.9 2.5 1.
Cas[mL/mmHg] 0.833 0.333 1.5 0.75 1.0 0.
Rvs[mmHg s/mL] 0.058 0.038 0.058 0.038 0.11 0.
Cvs[mL/mmHg] 16.35 11.35 20 12 10 5
Rpo[mmHg s/mL] 0.012 0.007 0.012 0.007 0.11 0.
Cpo[mL/mmHg] 2.583 1.333 1.6 0.6 2 1
Rap[mmHg s/mL] 0.158 0.138 0.158 0.138 1.5 0.
Cap[mL/mmHg] 0.103 0.053 0.153 0.103 1 0.
Rvp[mmHg s/mL] 0.058 0.038 0.058 0.038 0.11 0.
Cvp[mL/mmHg] 16.35 11.35 20 12 15 5
Vblood[mL] 750 550 700 550 650 550
Klv 2.0 1.0 2.0 1.0 2.0 1.
Krv 4.5 1.5 3.0 1.0 2.5 0.

TABLE 2. Parameters kept the same in the cardiovascular
system models (Kis a coefficient in the atria models,lis
longitudinal diameter of the atria,RandLare the resistance
and inertance, subscriptsla,ra,mv,av,tv,pv,ao,as,apand
porepresent left and right atria, mitral, aortic, tricuspid and
pulmonary valves, aorta, systemic arteries, pulmonary
arteries and pulmonary arterioles,fandbrepresent forward
and backward flow resistances in the heart valve models). *
shows backward flow resistances in the tricuspid valve and
pulmonary valves in Cardiovascular System Model simulating
reverse valve flow rate in Patient 3.
Parameter Parameter Value
Kla 2.
Kra 2.
lla[cm] 4.
lra[cm] 4.
Rmv,f[mmHg s/mL] 0.
Rmv,b[mmHg s/mL] 1.00E
Rav,f[mmHg s/mL] 0.
Rav,f[mmHg s/mL] 1.00E
Rtv,f[mmHg s/mL] 0.
Rtv,b[mmHg s/mL] 1.00E16 (0.55*)
Rpv,f[mmHg s/mL] 0.
Rpv,b[mmHg s/mL] 1.00E16 (3.5*)
Lao[mmHg s^2 /mL] 1.00E-
Las[mmHg s^2 /mL] 1.00E-
Lpo[mmHg s^2 /mL] 1.00E-
Lap[mmHg s^2 /mL] 1.00E-
BIOMEDICAL
ENGINEERING
Patient-Specific Modelling and Parameter Optimisation 717
in the model. Ventricular long axis lengths were kept
constant in the simulations and calculated using sys-
tolic and diastolic long axis lengths (lv,sys,lv,dias) in each
patient as:

lv¼
lv;sysþlv;dias
2
ð 24 Þ
The parameters used in in the compartments
describing atria, forward flow rate characteristics of
the heart valves and inertance in the blood vessels were
kept the same in all the models values because there
were no data available to optimise them. Heart valve
characteristics were assumed to be the same unless
there were insufficiency. Moreover, inertial properties
of blood had negligible effects on the CO and MAP.
The parameter values that were not optimised for each
specific case are reported in Table 2.
The optimisation and simulation processes were
carried out in Matlab Simulink R2017a. The set of
equations was solved using the ode15s solver. The
maximum step size was 1e-3 s and the relative toler-
ance was set to 1e-3.

RESULTS
Haemodynamic variables collected from the clinical
database and those from the numerical models simu-
lating each patient specific cardiac function are pro-
vided in Table 3.
Haemodynamic values from the patients and
numerical models were generally in good agreement.
The largest differences were for blood pressures, in
Patient 2 aortic pressure in diastole (6 mmHg); for
ventricular volumes, in Patient 3 for the left ventricle in
diastole (6 mL); for stroke volume, in Patient 1 for the
right ventricle (7 mL). Ventricular diameters were also
in good agreement, with the largest difference being 0.
cm in diastolic right ventricular diameter in Patient 3.
The upper and lower bounds of the parameters in thex
andkvectors obtained from the initial optimisation
and used in the second optimisation are given in Ta-
ble 4.
The difference between the upper and lower bounds
were narrowed down after the first optimisation with
the initial upper and lower bounds of the parameters.
The second optimisation allowed us to calculate opti-
mal values satisfying conditions defined in the objec-
tive function and the error functions for the
parameters in thexandkvectors, as given in the Ta-
TABLE 3. Input variables (HR,llv,lrv) and the simulated haemodynamic variables in the patients and simulation results in the
numerical models simulating patient specific cardiac function (HR,MAPandCOrepresent heart rate, mean arterial pressure and
cardiac output,p,V,SV,EF,Dandlrepresent pressure, volume, stroke volume, ejection fraction, diameter and length, subscripts
ao,lv,rv,sysanddiasrepresent aorta, left and right ventricles, systolic and diastolic phases respectively).

Patient 1 Model 1 Patient 2 Model 2 Patient 3 Model 3
HR [bpm] 101 101 69 69 80 80
llv,sys[cm] 5.9 – 6.3 – 7.3 –
llv,dias[cm] 7.1 – 6.7 – 7.7 –
llv[cm] – 6.5 – 6.5 – 7.
lrv,sys[cm] 5.1 – 6.7 – 7.1 –
lrv,dias[cm] 6.5 – 7.9 – 7.3 –
lrv[cm] – 5.8 – 7.3 – 7.
MAP [mmHg] 76.3 82.2 60.7 59.5 82.0 85.
CO [L/min] 5.3 5.15 2.6 2.7 2.6 2.
pao,sys[mmHg] 109 106 84 88 118 117
pao,dias[mmHg] 60 57 49 43 64 61
Vlv,sys[mL] 48 48 86 83 45 48
Vlv,dias[mL] 100 98 119 121 74 80
SVlv[mL] 52 50 33 38 29 32
Vrv,sys[mL] 26 29 51 47 134 135
Vrv,dias[mL] 83 79 84 85 183 182
SVrv[mL] 57 50 33 38 49 47
EFlv[%] 52 51 28 31 39 40
EFrv[%] 69 63 39 45 27 26
Dlv,sys[cm] 3.4 3.3 4.4 4.2 2.7 2.
Dlv,dias[cm] 4.6 4.7 4.9 5.1 3.5 3.
Drv,sys[cm] 1.7 1.7 2.5 2.3 4.8 4.
Drv,dias[cm] 2.7 2.8 2.9 3.1 5.1 5.

BIOMEDICAL
ENGINEERING
718 BOZKURTet al.

ble 5. The final value of the objective and error func-
tions are provided in Table 6.
The objective functionfwas£0.050 for all models in
the optimisation. Moreover, the error function re-
mained between -0.1 and 0.1. The plots of left and right
ventricular pressures, and aortic and pulmonary arte-
rial pressures from the three models are shown in
Figure 3.
Systolic and diastolic aortic pressures were around
106 mmHg and 57 mmHg correlating with the patient
data in Patient 1. Systolic right ventricle and pul-
monary arterial pressures were around 35 mmHg
whereas diastolic pulmonary arterial pressure was
around 20 mmHg. Reduced systolic left ventricular
and aortic pressures Patient 2 were simulated as in the
patient data. Right ventricular and pulmonary arterial
pressures were above 30 mmHg at systole, whilst
diastolic pulmonary arterial pressure was slightly
above 10 mmHg. Systolic left ventricular and aortic
pressures were around 118 mmHg in Patient 3. Both
systolic and diastolic pressures were remarkably high
in the right ventricle showing the effects of both sys-
tolic and diastolic dysfunctions in the right ventricle.
Left and right ventricular volumes and basal diameters

extracted from the models are plotted over 2 cardiac
cycles in Figure 4.
The left ventricular volume was larger than the right
ventricular volume during the entire cardiac cycle in
both Patient 1 and 2. The right ventricle was remark-
ably dilated in Patient 3, whereas the left ventricular
volume remained below 100 mL over the cardiac cycle.
Moreover, the right ventricular stroke volume was
larger than the left ventricular stoke volume in Patient
3 because of the reverse flow through the tricuspid and
pulmonary valves. Left ventricular basal diameter was
higher than the right ventricular basal diameter in
Patient 1 and 2, whilst right ventricular basal diameter
was relatively high in Patient 3.
The left and right ventricular pressure-volume loops
from the models are given in Figure 5.
The left ventricular pressure-volume loop shifted to
the right in Patient 1 and Patient 2 due to systolic
dysfunction in the left ventricle. In Patient 3, the right
ventricular pressure-volume loop shifted to the right,
indicating impaired right ventricular function.
TABLE 4. The upper and lower bounds of the parameters in the x and k vectors in the second optimisation (E,V,AandB
represent elastance, volume and the parameters used in the passive properties in the ventricle models,R,CandLrepresent
resistance, compliance and inertance of the blood vessels,Kis a coefficient in the ventricle models, subscriptses,lv,rv, 0
represent end-systole, left and right ventricles and initial value,ao,as,vs,po,ap,vpandbloodrepresent aorta, systemic arteries
and veins, pulmonary artery, arterioles and veins, and blood).

Model 1 Model 2 Model 3
ub lb ub lb ub lb
Ees,lv[mmHg/mL] 2.5 2.3 1.3 1 2.65 1.
Ees,rv[mmHg/mL] 1.5 1.4 1.12 0.96 0.38 0.
V0,lv[mL] 7.5 7 16 13 4 2
V0,rv[mL] 7.5 7 21 18 30 20
Alv[mmHg] 1.14 1.1 1.12 1.04 1.32 1.
Arv[mmHg] 1.14 1.1 1.12 1.04 0.82 0.
Blv[1/mL] 0.026 0.025 0.023 0.021 0.028 0.
Brv[1/mL] 0.026 0.025 0.023 0.021 0.018 0.
Rao[mmHg s/mL] 0.048 0.046 0.14 0.13 0.21 0.
Cao[mL/mmHg] 0.223 0.213 0.213 0.193 0.18 0.
Ras[mmHg s/mL] 0.8 0.74 1.1 1 1.6 1.
Cas[mL/mmHg] 0.583 0.533 1.05 0.9 0.52 0.
Rvs[mmHg s/mL] 0.048 0.046 0.046 0.042 0.05 0.
Cvs[mL/mmHg] 13.85 13.35 15.2 13.6 7 6
Rpo[mmHg s/mL] 0.0095 0.009 0.009 0.008 0.05 0.
Cpo[mL/mmHg] 1.958 1.833 1 0.8 1.4 1.
Rap[mmHg s/mL] 0.148 0.146 0.146 0.142 0.66 0.
Cap[mL/mmHg] 0.078 0.073 0.123 0.113 0.46 0.
Rvp[mmHg s/mL] 0.048 0.046 0.046 0.042 0.05 0.
Cvp[mL/mmHg] 13.85 13.35 15.2 13.6 9 7
Vblood[mL] 650 630 610 580 590 570
Klv 1.40 1.20 1.50 1.30 - -
Krv 1.80 1.50 1.40 1.00 1.10 0.

BIOMEDICAL
ENGINEERING
Patient-Specific Modelling and Parameter Optimisation 719
DISCUSSION
In this study, the parameters of a cardiovascular
system model which included the heart, and the sys-
temic and pulmonary circulations, were optimised to
simulate patient specific cardiac function in 3 paedi-
atric patients diagnosed with dilated cardiomyopathy.
In children, dilated cardiomyopathy is diagnosed
considering ventricular end-diastolic and end-systolic
diameters indexed on body surface area, and mea-
surements of the ventricular systolic function.^19 Left

ventricular systolic elastance (Ees,lv) in adults is around
2.5 mmHg/mL whereas it is reported to be above 3
mmHg/mL in children between 6 and 15 ages.^13 ,^15
Relatively high systolic elastance values in Patient 1
and Patient 3 show the effect of a mildly affected left
ventricular function; whilst for Patient 2, diagnosed
with severe left ventricular cardiomyopathy, left ven-
tricular systolic elastance (Ees,lv) was the lowest (Ta-
ble 5 ). A typical value right ventricular systolic
elastance (Ees,rv) is around 1 mmHg/mL in adults,^4
whilst 1.4 mmHg/mL has been used for children
between 8-12 years age.^3 1.040 mmHg/mL right ven-
tricular elastance (Ees,rv) shows impaired right ven-
tricular systolic function in Patient 2 (Table 5 ).
Moreover, 0.338 mmHg/mL right ventricular elastance
(Ees,rv) in Patient 3 (Table 5 ) shows severely impaired
right ventricular systolic function, correlating with the
clinical findings.
The parametersAandBwere used to describe the
passive ventricular pressure-volume relation. The same
intervals resulting in the same optimal values were used
for the left and right ventricles in the models simulating
cardiac function in Patient 1 and 2, in these patients,
only systolic dysfunction, which is related to active
contraction behaviour in the ventricles, has been
reported. Therefore, left and right ventricular passive
contraction properties were assumed to be similar in
these patients. Conversely, Patient 3 was diagnosed
with diastolic ventricular dysfunction in both ventri-
cles. Therefore, relatively large intervals for the coef-
ficientsAandBwere selected during the optimisation.
Relatively lowAandBvalues in the right ventricle
model of Patient 3 shows severely impaired diastolic
function in Patient 3, along with the systolic dysfunc-
tion.
Systemic vascular resistance increases in heart fail-
ure as a response to neurohumoral pathways to
maintain perfusion level.^17 Increased systemic arterio-
lar resistance (Ras) can be seen in Patient 2 and 3 as the
cardiac output and mean arterial pressure in these
patient were relatively low. Upper and lower bounds of
the other parameters were selected considering the
concept model and haemodynamic variables such as
ventricular volumes and arterial pressures reported in
the patient clinical data. For instance, the interval
between the upper and lower bounds in the ventricular
zero-pressure volumes (V 0 ) were selected higher for the
relatively high ventricular volumes clinically reported.
Moreover, the right ventricular zero-pressure volumes
(Vrv,0) were higher in the concept model reported in.^3
Therefore, ventricular zero-pressure volumes (V 0 ) were
the same for left and right ventricles in the cardiovas-
cular system model simulating Patient 1 where right
ventricular zero-pressure volumes (Vrv,0) were higher as
TABLE 5. Optimal values of the parameters in the x and k
vector (E,V,AandBrepresent elastance, volume and the
parameters used in the passive properties in the ventricle
models,R,CandLrepresent resistance, compliance and
inertance of the blood vessels,Kis a coefficient in the
ventricle models, subscriptses,lv, rv, 0 represent end-
systole, left and right ventricles and initial value,ao,as,vs,
po,ap,vpandbloodrepresent aorta, systemic arteries and
veins, pulmonary artery, arterioles and veins, and blood).

Model 1 Model 2 Model 3
Ees,lv[mmHg/mL] 2.480 1.150 2.
Ees,rv[mmHg/mL] 1.490 1.040 0.
V0,lv[mL] 7.450 14.500 3.
V0,rv[mL] 7.450 19.500 27.
Alv[mmHg] 1.104 1.080 1.
Arv[mmHg] 1.104 1.080 0.
Blv[1/mL] 0.025 0.022 0.
Brv[1/mL] 0.025 0.022 0.
Rao[mmHg s/mL] 0.048 0.135 0.
Cao[mL/mmHg] 0.222 0.203 0.
Ras[mmHg s/mL] 0.794 1.050 1.
Cas[mL/mmHg] 0.578 0.975 0.
Rvs[mmHg s/mL] 0.048 0.044 0.
Cvs[mL/mmHg] 13.800 14.400 6.
Rpo[mmHg s/mL] 0.009 0.009 0.
Cpo[mL/mmHg] 1.946 0.900 1.
Rap[mmHg s/mL] 0.148 0.144 0.
Cap[mL/mmHg] 0.078 0.118 0.
Rvp[mmHg s/mL] 0.048 0.044 0.
Cvp[mL/mmHg] 13.800 14.400 8.
Vblood[mL] 638 595 584
Klv 1.30 1.38 1.
Krv 1.68 1.20 0.

TABLE 6. Objective function and error functions for the
optimal parameter set

Model 1 Model 2 Model 3
f 0.048 0.019 0.
fMAP 0.076 0.019 0.
fCO 0.028 0.038 0
fDlv,sys 0.029 0.045 0
fDlv,dias 0.022 0.041 0
fDrv,sys 0 0.080 0.
fDrv,dias 0.037 0.069 0.

BIOMEDICAL
ENGINEERING
720 BOZKURTet al.

in the cardiovascular system model simulating Patients
2and3.
Thexvector contained 21 parameters and the k
vector contained 2 parameters. The optimal solution
depends on the selected upper and lower bounds (ub,
lb), and on the step-size (h). It may be possible to ob-
tain the global solution or local minima which provide
better solutions by changing the initial upper and lower
bounds, step size or interval for the error functions.
However, it should be noted that the aim of the study
was to simulate clinical conditions within the specified
limits for the error functions (fMAPandfCO) and show
that it could be possible to simulate clinical values in
the patients using lumped parameter models. Also,
relatively small step-sizes may allow to find an optimal
solution in one run, whilst larger step-sizes updates the
upper and lower bounds of the parameters and require
running the optimisation algorithm more than once.
Therefore, an initial simulation would be required for
relatively large upper and lower bound intervals to
narrow down the intervals for lower and upper bounds
of the parameters. A numerical model utilising rela-
tively large intervals for upper and lower bounds
would take more time to find an optimal solution. The

used optimisation method allowed us to optimise a
parameter set containing several parameters without
additional computational cost, as it utilised the
parameter values simultaneously to find the optimal
solution. Therefore, it is also suitable for low config-
uration computers.
Ventricular passive pressure component uses left
ventricular volume as its independent variable. Al-
though the ventricular pressures may not be zero at the
specified zero-pressure volumes (V 0 ) values, the utilised
model simulate left ventricular pressures within the
physiological limits. Utilising alsoV 0 in the ventricular
passive pressure component will allow ventricular
pressures to become zero at the specifiedV 0 values.^21
Patient-specific lumped parameter models simulat-
ing cardiac function in children can be used to evaluate
several different scenarios. In this study, dilated car-
diomyopathy was considered, but the framework pre-
sented could be easily adapted to simulate for example
restrictive or hypertrophic cardiomyopathy.^32 Another
application would be simulations of therapies, such as
ventricular assist device support that are becoming a
viable treatment option for end-stage heart failure
paediatric patients,^30 albeit often causing complica-
FIGURE 3. Left ventricular and aortic pressures (plv,pao) in the cardiovascular system models simulating cardiac function in (a)
Patient 1, (b) Patient 2 and (c) Patient 3, right ventricular and pulmonary arterial pressures (prv,ppo) in the cardiovascular system
models simulating cardiac function in (d) Patient 1, (e) Patient 2 and f) Patient 3.

BIOMEDICAL
ENGINEERING
Patient-Specific Modelling and Parameter Optimisation 721
tions which may require additional intervention.^8
Computational techniques have been utilised widely to
evaluate clinical scenarios in children.^23 In those cases,
where flow and pressure data cannot be retrieved from

conventional imaging modalities, patient specific
lumped parameter models, as presented in this study,
can be used to simulate patient specific boundary
conditions for finite element models.
FIGURE 4. Left and right ventricular volumes (Vlv,Vrv) in the cardiovascular system models simulating cardiac function in a)
Patient 1, b) Patient 2 and c) Patient 3, left and right ventricular basal diameters (Dlv,Drv) in the cardiovascular system models
simulating cardiac function in d) Patient 1, e) Patient 2 and f) Patient 3.

FIGURE 5. Left and right ventricular pressure-volume loops (lv, rv) in the cardiovascular system models simulating cardiac
function in (a) Patient 1, (b) Patient 2 and (c) Patient 3.

BIOMEDICAL
ENGINEERING
722 BOZKURTet al.

CONCLUSIONS
This study shows the potential of patient specific
lumped parameter models to simulate clinical cases of
dilated cardiomyopathy in children. Modelling patient
specific cardiac function and blood flow in paediatric
patients allows assessment of a variety of conditions
for better understanding of the complex hemodynamic
and cardiovascular function in these cases.

FUNDING
The authors received no specific funding for this work.

CONFLICT OF INTEREST
The authors declare no conflict of interest.
ETHICAL APPROVAL
Data was analysed in accordance with the guidelines
laid out in the Declaration of Helsinki. Ethical ap-
proval was obtained for the use of image data for
research purposes (UK REC 06/Q0508/124). All par-
ents/guardians gave written informed consent to par-
ticipate in this study.

OPEN ACCESS
This article is licensed under a Creative Commons
Attribution 4.0 International License, which permits
use, sharing, adaptation, distribution and reproduction
in any medium or format, as long as you give appro-
priate credit to the original author(s) and the source,
provide a link to the Creative Commons licence, and
indicate if changes were made. The images or other
third party material in this article are included in the
article’s Creative Commons licence, unless indicated
otherwise in a credit line to the material. If material is
not included in the article’s Creative Commons licence
and your intended use is not permitted by statutory
regulation or exceeds the permitted use, you will need
to obtain permission directly from the copyright
holder. To view a copy of this licence, visithttp://crea
tivecommons.org/licenses/by/4.0/.

REFERENCES
(^1) Bhattacharya-Ghosh, B., S. Bozkurt, M. C. M. Rutten, F.
N. van de Vosse, and V. Dı ́az-Zuccarini. An in silico case
study of idiopathic dilated cardiomyopathy via a multi-
scale model of the cardiovascular system.Comput. Biol.
Med.53:141–153, 2014.https://doi.org/10.1016/j.compbio
med.2014.06.013.
(^2) Bozkurt, S. In-silico modeling of left ventricle to simulate
dilated cardiomyopathy and cf-lvad support.J. Mech.
Med. Biol.17:1750034, 2016.https://doi.org/10.1142/S

(^3) Bozkurt, S. Mathematical modeling of cardiac function to
evaluate clinical cases in adults and children.PLoS ONE.
14:e0224663, 2019.https://doi.org/10.1371/journal.pone.

(^4) Brimioulle, S., P. Wauthy, P. Ewalenko, B. Rondelet, F.
Vermeulen, F. Kerbaul, and R. Naeije. Single-beat esti-
mation of right ventricular end-systolic pressure-volume
relationship. Am. J. Physiol. Heart Circ. Physiol.
284:H1625-1630, 2003.https://doi.org/10.1152/ajpheart.
023.2002.
(^5) Cox, L. G. E., S. Loerakker, M. C. M. Rutten, B. A. J. M.
D. Mol, and F. N. V. D. Vosse. A mathematical model to
evaluate control strategies for mechanical circulatory sup-
port.Artif. Org.33:593–603, 2009.https://doi.org/10.1111/
j.1525-1594.2009.00755.x.
(^6) Das, B. B. Current state of pediatric heart failure.Children
(Basel). 2018.https://doi.org/10.3390/children5070088.
(^7) Ellwein, L. M., S. R. Pope, A. Xie, J. J. Batzel, C. T.
Kelley, and M. S. Olufsen. Patient-specific modeling of
cardiovascular and respiratory dynamics during hyper-
capnia.Math Biosci.241:56–74, 2013.https://doi.org/10.
1016/j.mbs.2012.09.003.
(^8) George, A. N., T.-Y. Hsia, S. Schievano, and S. Bozkurt.
Complications in children with ventricular assist devices:
systematic review and meta-analyses.Heart Fail Rev.2021.
https://doi.org/10.1007/s10741-021-10093-x.
(^9) Giridharan, G. A., S. C. Koenig, M. Mitchell, M. Gartner,
and G. M. Pantalos. A computer model of the pediatric
circulatory system for testing pediatric assist devices.
ASAIO J.53:74–81, 2007.https://doi.org/10.1097/01.mat.
0000247154.02260.30.
(^10) Goodwin, J. A., W. L. van Meurs, C. D. Sa ́Couto, J. E. W.
Beneken, and S. A. Graves. A model for educational sim-
ulation of infant cardiovascular physiology.Anesth. Analg.
99:1655–1664, 2004.https://doi.org/10.1213/01.ANE.
134797.52793.AF.(table of contents).
(^11) Greenway, C. V., and W. W. Lautt. Blood volume, the
venous system, preload, and cardiac output. Can. J.
Physiol. Pharmacol.64:383–387, 1986.https://doi.org/10.
1139/y86-062.
(^12) Gross, C., F. Moscato, T. Schlo ̈glhofer, M. Maw, B.
Meyns, C. Marko, D. Wiedemann, D. Zimpfer, H. Schima,
and L. Fresiello. LVAD speed increase during exercise,
which patients would benefit the most? A simulation study.
Artif. Org.44:239–247, 2020.https://doi.org/10.1111/aor.

(^13) Heldt, T., E. B. Shim, R. D. Kamm, and R. G. Mark.
Computational modeling of cardiovascular response to
orthostatic stress.J. Appl. Physiol.92:1239–1254, 2002.h
ttps://doi.org/10.1152/japplphysiol.00241.2001.
(^14) Jayaprasad, N. Heart failure in children.Heart Views.
17:92–99, 2016.https://doi.org/10.4103/1995-705X.192556.
(^15) Kiani, A., and J. Gilani Shakibi. Normal value of left
ventricular end-systolic elastance in infants and children.
Iran. J. Med. Sci.28:169–172, 2015.
(^16) Korakianitis, T., and Y. Shi. Numerical simulation of
cardiovascular dynamics with healthy and diseased heart
valves.J Biomech.39:1964–1982, 2006.https://doi.org/10.
1016/j.jbiomech.2005.06.016.
BIOMEDICAL
ENGINEERING
Patient-Specific Modelling and Parameter Optimisation 723

(^17) Ledoux, J., D. M. Gee, and N. Leblanc. Increased
peripheral resistance in heart failure: new evidence suggests
an alteration in vascular smooth muscle function.Br. J.
Pharmacol.139:1245–1248, 2003.https://doi.org/10.1038/s
j.bjp.0705366.
(^18) Li, W. Biomechanics of infarcted left ventricle: a review of
modelling, Biomed.Eng. Lett.10:387–417, 2020.https://d
oi.org/10.1007/s13534-020-00159-4.
(^19) Lipshultz, S. E., Y. M. Law, A. Asante-Korang, E. D.
Austin, A. I. Dipchand, M. D. Everitt, D. T. Hsu, K. Y.
Lin, J. F. Price, J. D. Wilkinson, and S. D. Colan. Car-
diomyopathy in children: classification and diagnosis: a
scientific statement from the American Heart Association.
Circulation. 140(1):e9–e68, 2019.https://doi.org/10.1161/C
IR.0000000000000682.
(^20) Liu, H., S. Liu, and X. Ma. Varying speed modulation of
continuous-flow left ventricular assist device based on
cardiovascular coupling numerical model.Comput. Meth-
ods Biomech. Biomed. Eng.2020.https://doi.org/10.1080/
10255842.2020.1861601.
(^21) Migliavacca, F., G. Pennati, G. Dubini, R. Fumero, R.
Pietrabissa, G. Urcelay, E. L. Bove, T. Y. Hsia, and M. R.
de Leval. Modeling of the Norwood circulation: effects of
shunt size, vascular resistances, and heart rate.Am. J.
Physiol. Heart Circ. Physiol.280:H2076-2086, 2001.http
s://doi.org/10.1152/ajpheart.2001.280.5.H2076.
(^22) Neal, M. L., and J. B. Bassingthwaighte. Subject-specific
model estimation of cardiac output and blood volume
during hemorrhage.Cardiovasc Eng.7:97–120, 2007.http
s://doi.org/10.1007/s10558-007-9035-7.
(^23) Pennati, G., C. Corsini, T.-Y. Hsia, and F. Migliavacca.
Computational fluid dynamics models and congenital heart
diseases.Front. Pediatr.2013.https://doi.org/10.3389/fped.
2013.00004.
(^24) Petukhov, D. S., and D. V. Telyshev. A mathematical
model of the cardiovascular system of pediatric patients
with congenital heart defect.Biomed. Eng. 50:229–232,
2016.https://doi.org/10.1007/s10527-016-9626-y.
(^25) Pironet, A., P. C. Dauby, S. Paeme, S. Kosta, J. G. Chase,
and T. Desaive. Simulation of left atrial function using a
multi-scale model of the cardiovascular system.PLoS
ONE.8:e65146, 2013.https://doi.org/10.1371/journal.pon
e.0065146.
(^26) Pope, S. R., L. M. Ellwein, C. L. Zapata, V. Novak, C. T.
Kelley, and M. S. Olufsen. Estimation and identification of
parameters in a lumped cerebrovascular model.Math
Biosci Eng.6:93–115, 2009.https://doi.org/10.3934/mbe.
009.6.93.
(^27) Raes, A., S. Van Aken, M. Craen, R. Donckerwolcke, and
J. V. Walle. A reference frame for blood volume in children
and adolescents.BMC Pediatr.6:3, 2006.https://doi.org/
10.1186/1471-2431-6-3.
(^28) Sa ́Couto, C. D., W. L. van Meurs, J. A. Goodwin, and P.
Andriessen. A model for educational simulation of
neonatal cardiovascular pathophysiology.Simul Healthc.
1:4–9, 2006.https://doi.org/10.1097/01266021-200600010-

(^29) Schiavazzi, D. E., A. Baretta, G. Pennati, T.-Y. Hsia, and
A. L. Marsden. Patient-specific parameter estimation in
single-ventricle lumped circulation models under uncer-
tainty.Int. J. Numer. Method Biomed. Eng.33:e02799,
2017.https://doi.org/10.1002/cnm.2799.
(^30) Shin, Y. R., Y.-H. Park, and H. K. Park. Pediatric ven-
tricular assist device, Korean.Circ J.49:678–690, 2019.h
ttps://doi.org/10.4070/kcj.2019.0163.
(^31) Tsirka, A. E., K. Trinkaus, S.-C. Chen, S. E. Lipshultz, J.
A. Towbin, S. D. Colan, V. Exil, A. W. Strauss, and C. E.
Canter. Improved outcomes of pediatric dilated car-
diomyopathy with utilization of heart transplantation.J.
Am. Coll. Cardiol.44:391–397, 2004.https://doi.org/10.
16/j.jacc.2004.04.035.
(^32) Yuan, S.-M. Cardiomyopathy in the pediatric patients.
Pediatr. Neonatol.59:120–128, 2018.https://doi.org/10.
16/j.pedneo.2017.05.003.
Publisher’s Note Springer Nature remains neutral with re-
gard to jurisdictional claims in published maps and institu-
tional affiliations.
BIOMEDICAL
ENGINEERING
724 BOZKURTet al.

This is a offline tool, your data stays locally and is not send to any server!
Feedback & Bug Reports