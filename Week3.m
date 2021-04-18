clc;
clear;

%% should have been part of last week :(

% use TOFL = 10,000, 4 engine

%fig 5 -> number

fig_5_soln = 325;
WS_TO = 128.2305;
Cl_TO = 1.795661;
sigma = 0.953;
%

WT_7 = (fig_5_soln / WS_TO) * sigma * Cl_TO;
V_lo = 1.2 * ((296 * WS_TO) / (sigma * Cl_TO))^0.5; % kts

M_lo = (V_lo / 661) / sigma^0.5; %%%%%%%%%%%%%%%%%  mistake in my hand clacs...
M_lo_7 = 0.7 * M_lo

% pause here

%%
% from JT9D % fig 2:22b

TSLST = 45500
T_7 = 37500

W_to_T = WT_7 * (T_7 / TSLST);


%%

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

% Engine_Mount_Factor(s) =   

%% find eqn

% wing
tc_bar = tc + 0.03;

if (fus_mount_eng)
    kw = 1.03; %#ok<UNRCH>
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
% a*x^1.95+b*x^.....+DD=0        
% See Discussion Video for detailed quadratic solver example        

% if JT8D % Write Logic Statement to choose engine type            
%     W_TO=...        
% elseif JT9D            
% W_TO=...        
%     end
% S =...        
%     b =...        
%     Chord_average =...        
%     T =...        
% T_Engine =...    

%% Drag Calculation        % This sectio is pretty self explanatory; there are no loops here.        Length = ...        Diameter = ...        W_Fusleage =...        W_Landing =...        W_Pylon =...        W_Total =...        W_Power =...        W_Fuel =...        W_Payload =...        W_FixE =...            a =W_Total;            B =W_Fusleage;            C =W_Landing+W_Pylon+W_Power+W_Fuel+.035-1;            DD =W_Payload+W_FixE;       %% You rewrite the Weight fraction formula as some quadratic:         % a*x^1.95+b*x^.....+DD=0        % See Discussion Video for detailed quadratic solver example        if JT8D % Write Logic Statement to choose engine type            W_TO=...        elseif JT9D            W_TO=...        end        S =...        b =...        Chord_average =...        T =...        T_Engine =...    %% Drag Calculation        % This sectio is pretty self explanatory; there are no loops here.