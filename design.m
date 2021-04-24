% Created by Sam Hince 
% 04/24/2021
% 
% First combined script MAE 159
    
clc;
clear;

lambda = 0.35; %taper ratio 
Lambda = 35; %deg sweep angle
tc = 0.1089627; %from last week
AR = 7;
fus_mount_eng = false;
PAX = 350;
abrest = 10;
aisles = 2;

fuel_frac = 0.317387;
W_cargo = 60000;
engines = 4;
crew = 2;
WS = 128.2305; % WS_TO from last code
eta = 1.5 * 2.5; %ultimate load factor



% 



M = 0.8;
V_ap = 140; % approach velocity
R = 4600;

x = 0.65;
sigma = 0.953;

%% Week 2

% 1:
Cl = 0.5;

% 2:
deltaMdiv = -0.159060144936781 * Cl^3 + 0.0683519211996528 * Cl^2 - 0.266803630282887 * Cl + 0.152362112031142;
% y =  0.816626867422931 * x^3 +  -1.74260944498918 * x^2 +
% 1.01975051234658 * x +  -0.169627700515125 % for supercritical
% 3:
Mdiv = M + 0.004 - deltaMdiv;

% 4:
tc = -0.468381444795058 * Mdiv + 0.486152293564531;

% 5:
val = ((cos(Lambda * (pi/180)))^2) * (tc^2) * AR;

Cl_TO = 76.2582492901214 * val^3 - 61.4492995189543 * val^2 + 16.6191081923602 * val + 1.05034581648415;
Cl_LDG = 99.7981634232677 * val^3 - 64.1877534121205 * val^2 + 16.1389682391156 * val + 2.00840840536795;

% 6: 
WS_LDG = ((V_ap/1.3)^2) * ((0.953 * Cl_LDG) / (296)); % fix hard number

% 7:
V_cru = M * 576.4; % fix hard nbr
R_ao = R + 200 + (0.75 * V_cru);

% 8:
fuel_frac = 5.60704238288039e-13 * R_ao^3 - 1.23872189811619e-08 * R_ao^2 + 0.000126656869124797 * R_ao + 0.00496943980299271;

% 9:
fuel_frac = fuel_frac * (0.61/0.78);

% 10:
WS_TO = WS_LDG / (1 - (x * fuel_frac));

% 11:
WS_cru = 0.965 * WS_TO;

% 12:
Cl_cru = WS_cru / (1481 * 0.2360 * (M^2));

% loop

Cl = Cl_cru;

%% use TOFL = 10,000, 

if(engines == 2)
    fig_5_soln = 2.07050223236593e-11 * x^3 - 7.45528063196903e-07 * x^2 + 0.0356296987076175 * x - 28.5183454273923;
elseif(wngines == 4)
    fig_5_soln = 2.57638034330905e-11 * x^3 - 9.00476589156602e-07 * x^2 + 0.0409040479986367 * x - 19.328192676859;
end 


WT_7 = (fig_5_soln / WS_TO) * sigma * Cl_TO;
V_lo = 1.2 * ((296 * WS_TO) / (sigma * Cl_TO))^0.5; % kts

M_lo = (V_lo / 661) / sigma^0.5; %%%%%%%%%%%%%%%%%  mistake in my hand clacs...
M_lo_7 = 0.7 * M_lo

% pause here

%%
% from JT9D % fig 2:22b

TSLST = y =  1783.69092191008 * x^3 +  35254.9077204685 * x^2 +  -47130.304093035 * x +  45493.0238331319
T_7 = y =  1783.69092191008 * x^3 +  35254.9077204685 * x^2 +  -47130.304093035 * x +  45493.0238331319

W_to_T = WT_7 * (T_7 / TSLST);

%% Week 3



% Engine_Mount_Factor(s) =   

%% find eqn

% wing
tc_bar = tc + 0.03;

if (fus_mount_eng)
    kw = 1.03; 
    kts = 0.25;
else
    kw = 1.00;
    kts = 0.17;
end

W_Wing_coef = (0.00945 * AR^0.8 * (1+lambda)^0.25 * kw * eta^0.5) / (tc_bar^0.4 * cosd(Lambda) * (WS)^0.695);


% fuse
kf = 11.5; % only for PAX > 135
Length = (3.76 * (PAX / abrest)) + 33.2;
Diameter = (1.75 * abrest) + (1.58 * aisles) + 1;

W_Fusleage_coef = 0.6727 * kf * (Length * 1.1)^0.6 * (Diameter * 1.1)^0.72 * eta^0.3; % 10% for international

% other
W_Landing_coef = 0.040;     
W_Pylon_coef = 0.0555 / W_to_T;
W_Tail_and_Wing = (1 + kts) * W_Wing_coef;
W_Power_coef = 1 / (3.58 * W_to_T);
W_Fuel_coef = 1.0275 * fuel_frac;
W_Payload = (215 * PAX) + W_cargo;

stew = ceil(PAX / 50);
W_FixE = (132 * PAX) + (300 * engines) + (260 * crew) + (170 * stew);
W_FixE_coef = 0.035;

%% combine and solve
% A = W_Total;            
% B = W_Fusleage;            
% C = W_Landing+W_Pylon+W_Power+W_Fuel+.035-1;            
% D = W_Payload+W_FixE;       

Wto = 400000; % guess
error = 100;
step = 50;

while (error >= 100)
    
    if (error > 0)
        Wto = Wto + step
    else
        Wto = Wto - step
    end
    
    error = (W_Tail_and_Wing * Wto^1.195) + ...
            (W_Fusleage_coef * Wto^0.235) + ...
            ((W_Landing_coef + W_Pylon_coef + W_Power_coef + W_Fuel_coef + W_FixE_coef - 1) * Wto) + ...
            (W_Payload + W_FixE)

end