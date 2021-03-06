% Created by Sam Hince 
% 04/24/2021
% 
% First combined script MAE 159
    
clc;
clear;

% % specs
% lambda = 0.35;              % taper ratio 
% Lambda = 35;                % deg sweep angle
% AR = 8;                   % aspect ratio 
% fus_mount_eng = false;      % engine mounting position
% PAX = 275;                  % number of passengers
% abrest = 8;                 % passengers per row
% aisles = 2;                 % number of cabin isles
% W_cargo = 12000;             % cargo weight. total? or added to passengers?
% engines = 2;                % number of engines
% crew = 2;                   % number of crew members
% conventionalWing = false;   % conventional or supercritical wing design
% TOFL = 9000;                % take off field length 
% M = 0.8;                    % cruise mach number
% V_ap = 140;                 % approach velocity kts
% R_target = 6000;            % target range
% x = 0.65;                   % ??? fuel burned or something 

% specs long haul
lambda = 0.35;              % taper ratio 
Lambda = 35;                % deg sweep angle
AR = 8;                   % aspect ratio 
fus_mount_eng = false;      % engine mounting position
PAX = 275;                  % number of passengers
abrest = 8;                 % passengers per row
aisles = 2;                 % number of cabin isles
W_cargo = 12000;             % cargo weight. total? or added to passengers?
engines = 2;                % number of engines
crew = 2;                   % number of crew members
conventionalWing = false;   % conventional or supercritical wing design
TOFL = 9000;                % take off field length 
M = 0.8;                    % cruise mach number
V_ap = 140;                 % approach velocity kts
R_target = 6000;            % target range
x = 0.65;                   % ??? fuel burned or something 

% % specs hand calcs
% lambda = 0.35;              % taper ratio 
% Lambda = 35;                % deg sweep angle
% AR = 8;                   % aspect ratio 
% fus_mount_eng = false;      % engine mounting position
% PAX = 275;                  % number of passengers
% abrest = 8;                 % passengers per row
% aisles = 2;                 % number of cabin isles
% W_cargo = 12000;             % cargo weight. total? or added to passengers?
% engines = 2;                % number of engines
% crew = 2;                   % number of crew members
% conventionalWing = false;   % conventional or supercritical wing design
% TOFL = 9000;                % take off field length 
% M = 0.8;                    % cruise mach number
% V_ap = 140;                 % approach velocity kts
% R_target = 6000;            % target range
% x = 0.65;                   % ??? fuel burned or something 

% constants
eta = 1.5 * 2.5;            % ultimate load factor
sigma = 0.953;              % 
Cl_convergence = 0.0001;      %0.05;      % within 5%
Cl_not_converged = true;    % 
delta_fuel = 0;             % 

% master loops
counter = 0;
rec = [];
for Lambda = 20:5:50
    for AR = 8:0.1:14
        
        %% Week 2

        while(1) % range sizing loop

            % Week 1: 

            % 1:
            Cl = 0.5;

            while(Cl_not_converged)

                % 2:
                if(conventionalWing)
                    deltaMdiv = -0.159060144936781 * Cl^3 + 0.0683519211996528 * Cl^2 - 0.266803630282887 * Cl + 0.152362112031142;
                else
                    deltaMdiv = 0.816626867422931 * Cl^3 - 1.74260944498918 * Cl^2 + 1.01975051234658 * Cl - 0.169627700515125; % for supercritical
                end

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
                R_ao = R_target + 200 + (0.75 * V_cru); % check on this...????

                % 8:
                fuel_frac = 5.60704238288039e-13 * R_ao^3 - 1.23872189811619e-08 * R_ao^2 + 0.000126656869124797 * R_ao + 0.00496943980299271 + delta_fuel;

                % 9:
                fuel_frac = fuel_frac * (0.61/0.78);

                % 10:
                WS_TO = WS_LDG / (1 - (x * fuel_frac));

                % 11:
                WS_cru = 0.965 * WS_TO;

                % 12:
                Cl_cru = WS_cru / (1481 * 0.2360 * (M^2));

                % loop
                %if((abs(Cl_cru - Cl)/Cl) < Cl_convergence)
                if(abs(Cl_cru - Cl) > 0.00001)
                    Cl_not_converged = false;
                end
                
                if(Cl_cru > Cl)
                    Cl = Cl + 0.00001;
                elseif(Cl_cru < Cl)
                    Cl = Cl - 0.00001;
                end
                % Cl = Cl_cru;

            end
            Cl_not_converged = true; % reset

            %% TOFL = 10,000

            if(engines == 2)
                fig_5_soln = 2.07050223236593e-11 * TOFL^3 - 7.45528063196903e-07 * TOFL^2 + 0.0356296987076175 * TOFL - 28.5183454273923;
            elseif(engines == 4)
                fig_5_soln = 2.57638034330905e-11 * TOFL^3 - 9.00476589156602e-07 * TOFL^2 + 0.0409040479986367 * TOFL - 19.328192676859;
            end 


            WT_7 = (fig_5_soln / WS_TO) * sigma * Cl_TO;
            V_lo = 1.2 * ((296 * WS_TO) / (sigma * Cl_TO))^0.5; % kts

            M_lo = (V_lo / 661) / sigma^0.5; %%%%%%%%%%%%%%%%%  mistake in my hand clacs...
            M_lo_7 = 0.7 * M_lo;

            TSLST =  1783.69092191008 * 0^3 +  35254.9077204685 * 0^2 +  -47130.304093035 * 0 +  45493.0238331319;
            T_7 =  1783.69092191008 * M_lo_7^3 +  35254.9077204685 * M_lo_7^2 +  -47130.304093035 * M_lo_7 +  45493.0238331319;

            W_to_T = WT_7 * (T_7 / TSLST);

            %% Week 3

            % wing
            tc_bar = tc + 0.03;

            if (fus_mount_eng)
                kw = 1.03; 
                kts = 0.25;
            else
                kw = 1.00;
                kts = 0.17;
            end

            W_Wing_coef = (0.00945 * AR^0.8 * (1+lambda)^0.25 * kw * eta^0.5) / (tc_bar^0.4 * cosd(Lambda) * (WS_TO)^0.695);

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

            Wto = 400000; % guess
            error = 10;
            step = 5;

            while (abs(error) >= 10)

                if (error > 0)
                    Wto = Wto + step;
                else
                    Wto = Wto - step;
                end

                error = (W_Tail_and_Wing * Wto^1.195) + ...
                        (W_Fusleage_coef * Wto^0.235) + ...
                        ((W_Landing_coef + W_Pylon_coef + W_Power_coef + W_Fuel_coef + W_FixE_coef - 1) * Wto) + ...
                        (W_Payload + W_FixE);

            end

            S = Wto / WS_TO;
            b = sqrt(AR * S);
            c_bar = S / b; 
            T = Wto / W_to_T;
            T_e = T / engines;

            %% Drag

            RNK = 2.852e6 * 0.5; % at 30K ft

            % Wing
            Rn_wing = RNK * c_bar;
            cf_wing = (0.208 * Rn_wing^(-0.27845)) + 0.00101; % make into a function

            c_root = (1 + (lambda / 2)) * c_bar; % check eqn?
            S_wet = 2 * (S - (Diameter * c_root)) * 1.02;

            z = ((2 - (M^2)) * cosd(Lambda))/(sqrt(1-((M^2) * cosd(Lambda))));
            k_wing = 1 + (z * tc) + (100 * (tc^4));

            f_wing = k_wing * S_wet * cf_wing;

            % Fus
            Rn_fus = RNK * Length;
            cf_fus = (0.208 * Rn_fus^(-0.27845)) + 0.00101;

            S_wet_fus = 0.9 * pi * Diameter * Length;
            fineness_ratio = Length / Diameter;

            k_fus = -0.0013589267340066 * fineness_ratio^3 + 0.0349798326722644 * fineness_ratio^2 - 0.326799927455214 * fineness_ratio + 2.22004711321404;

            f_fus = k_fus * S_wet * cf_fus;

            % tail
            f_tail = 0.38 * f_wing;

            % Nacells
            S_wet_nc = 2.1 * sqrt(T_e) * engines;
            f_nc = 1.25 * 0.0027 * S_wet_nc; % ???

            % Pylons
            f_pylon = 0.2 * f_nc;

            % Total
            f = (f_wing + f_fus + f_tail + f_nc + f_pylon) * 1.06;
            C_D0 = f / S;
            e_var = 1 / (1.035 + 0.38 * C_D0 * pi * AR);


            %% Climb

            W = ((1 + 0.965) / 2) * Wto;
            sigma_climb = 0.5702;

            V_cl = 1.3 * (12.9 / (f * e_var)^0.25) * sqrt(W / (sigma_climb * b));

            Tr_cl = ((sigma_climb * f * V_cl^2)/296) + (94.1/(sigma_climb * e_var)) * (W/b)^2 * (1 / V_cl^2);

            % at 20k ft:
            Ta_JT9D = 15400; %remove hard code
            c = 0.65; %remove hard code

            Ta = (T_e / 45500) * Ta_JT9D;

            R_C = (101 * (Ta * engines - Tr_cl) / W) * V_cl;

            Time_cl = 35000 / R_C; % fix hard number

            Range_cl = V_cl * Time_cl / 60;

            W_f_cl = engines * Ta * c * Time_cl / 60;

            %% Range

            W_0 = Wto - W_f_cl;
            W_1 = (1 - fuel_frac) * Wto;

            Cl_avg = (((W_0 + W_1) / 2) / S) / (1481 * 0.2360 * M^2); % fix 0.2360

            C_Di = Cl_avg^2 / (pi * AR * e_var);

            C_D = C_D0 + C_Di + 0.0010;

            L_D = Cl_avg / C_D;

            T_r = ((W_0 + W_1) / 2) / L_D;

            T_r_JT9D = T_r * (45500 / T_e) / engines;

            if(M == 0.8)
                c = -3.06560814265018e-12 * T_r_JT9D^3 + 5.74104252722318e-08 * T_r_JT9D^2 - 0.000359687077287831 * T_r_JT9D + 1.36612937858716;
            elseif(M == 0.85)
                c = -1.32312728083244e-12 * T_r_JT9D^3 + 3.98265752145154e-08 * T_r_JT9D^2 - 0.000305169945014684 * T_r_JT9D + 1.34664881436086;
            else
                disp("No engine data for mach number")
            end

            V_cruise = M * 574; % fix haaack
            R_cruise = (V_cruise / c) * L_D * log(W_0 / W_1); %check log type -- natural --- check 158 notes

            R = Range_cl + R_cruise;

            if(R < (R_target - 50))
                delta_fuel = delta_fuel + 0.00001;
%                disp("Adding fuel")
            elseif(R > (R_target + 50))
                delta_fuel = delta_fuel - 0.00001;
%                disp("Removing fuel")
            else
                disp("DONE")
                break;
            end
            
        end

        %% Check on T_req at top of climb

        Cl_IC = (W_0 / S) / (1481 * 0.2360 * M^2); % fix 0.2360
        C_Di_IC = Cl_IC^2 / (pi * AR * e_var);
        C_D_IC = C_D0 + C_Di_IC + 0.0010;
        L_D_IC = Cl_IC / C_D_IC;
        T_r_IC = ((W_0 + W_1) / 2) / L_D_IC;
        T_r_JT9D_IC = T_r_IC * (45500 / T_e) / engines;

        T_avail_T_r_JT9D = 10000; % where did this come from? -- from max continuous thrust at 35k ft "nathan" - max cruise thjrust

        if(T_r_JT9D_IC < T_avail_T_r_JT9D)
%            disp("Top of climb check passed")
        elseif(T_r_JT9D_IC > T_avail_T_r_JT9D)
            % add fuel 
            disp("Top of climb check failed")
        else
            disp("This shouldnt happen")
        end

        %% Climb gradients

        %% Landing

        %% DOC

        % Block speed

        D = R_target * 1.15; % range with no reserve in statute miles
        T_gm = 0.25; % ground maneuver time (given) or use forula on pg 63? -- use formula 
        T_cl = Time_cl / 60; % climb time ????????????????????????????????????????????
        T_d = 0; % simple and mod? 
        T_am = 0.10; % air maneuver time (given)

        if(D < 1400)
            K_a = 7 + (0.015 * D);
        else
            K_a = 0.02 * D;
        end
        V_cr = V_cruise * 1.15; % TAS?
        D_c = Range_cl;
        D_d = 0;

        T_cr = (D + K_a + 20 - D_c - D_d) / V_cr;

        V_b = D / (T_gm + T_cl + T_d + T_cr + T_am);

        % Block time

        T_block = T_gm + T_cl + T_d + T_cr + T_am;

        % Block fuel

        F_gm = 0;
        F_cl = W_f_cl; 
        F_D = 0;
        Fcr_and_Fam = T_r * c * (T_cr + T_am);

        F_B = F_gm + F_cl + F_D + Fcr_and_Fam;

        % Flying operations costs

        % flight crew: 
        P = W_Payload / 2000; % tons
        if(crew == 2)
            Price_BLKHR = (17.849 * (V_cr * (Wto / 10e5))^0.3) + 40.83;
        elseif(crew == 3)
            Price_BLKHR = (24.261 * (V_cr * (Wto / 10e5))^0.3) + 57.62;
        else
            disp ("ERROR")
        end

        C_crew = Price_BLKHR / (V_b * P);

        % Fuel and Oil
        C_fuel = 0.0625; % /gal % = (0.40 / Gal) * (1/6.4/Gal)
        C_oil = 2.15; % /gal

        C_fuel_oil = (1.02 * F_B * C_fuel + engines * C_oil * T_block * 0.135) / (D * P);

        % Hull insurance 
        W_FCR = 0;
        W_a = Wto * (1 - fuel_frac) - W_Payload - W_FCR - (W_Power_coef * Wto);
        C_a = (2.4e6) + (87.5 * W_a);

        C_e = 590000 + 16 * T_e;

        IR_A = 0.01; % = insurance rate / $ value

        C_t = (engines * C_e) + C_a;

        U = 630 + 4000 / (1 + 1 / (T_block + 0.5));

        C_hull_ins = (IR_A * C_t) / (U * V_b * P);

        % Dirct Maintainance 
        % airframe

        K_FH_a = 4.9169 * (log10(W_a / 1000)) - 6.425;
        K_FC_a = 0.21256 * (log10(W_a / 1000))^3.7375;

        t_f = T_block - T_gm;
        R_L = 8.60; % 1975

        C_labor = ((K_FH_a * t_f + K_FC_a) / (V_b * T_block * P)) * (R_L) * (1 + 0.29 * (M - 1))^1.5;

        % material 
        C_FH_a = 1.5994 * C_a / 10e6 + 3.4263;
        C_FC_a = 1.9229 * C_a / 10e6 + 2.2504;

        C_material = (C_FH_a * t_f + C_FC_a) / (V_b * T_block * P);

        % engines
        K_FH_e = engines * (T_e / 10e3) / (0.82715 * (T_e / 10e3) + 13.639);
        K_FC_e = 0.20 * engines;

        C_engines = ((K_FH_e * t_f + K_FC_e) / (V_b * T_block * P)) * R_L;

        % eng material
        C_FH_e = (28.2353 * (C_e / 10e6) - 6.5176) * engines;
        C_FC_e = (3.6698 * (C_e / 10e6) + 1.3685) * engines;

        C_eng_mat = (C_FH_e * t_f + C_FC_e) / (V_b * T_block * P);

        % maintainance 
        maint_mult = 1;
        C_maintain = (C_labor + C_material + C_engines + C_eng_mat) * maint_mult;

        % depreciation 
        D_a = 14;
        C_depreciation = (1/(V_b * P)) * (C_t + 0.06 * (C_t - engines * C_e) + 0.30 * engines * C_e) / (D_a * U);

        % sum it up 
        DOC = C_crew + C_fuel_oil + C_hull_ins + C_labor + C_material + C_engines + C_eng_mat + C_maintain + C_depreciation;

     
        % record data
        counter = counter + 1;
        fprintf("Recording design %i", counter)
        rec = [rec; [DOC, AR, Lambda, Wto, aisles, abrest]];
        
    % end master loops    
    end
end

%% plots to make: 

% AR and Lambda vs DOC
marker = {'+','o','.','-'};   
hold on
for i = 20:5:30
    df = rec(rec(:,3)==i,:);
    plot(df(:,2), df(:,1), marker{(i-15)/5})
end
legend('+','o','.')
title('Line Plot of Sine and Cosine Between -2\pi and 2\pi')
xlabel('-2\pi < x < 2\pi') 
ylabel('Sine and Cosine Values') 
hold off

% AR and Lambda vd Weight
marker = {'+','o','.','-'};   
hold on
for i = 20:5:30
    df = rec(rec(:,3)==i,:);
    plot(df(:,2), df(:,4), marker{(i-15)/5})
end
legend('+','o','.')
title('Line Plot of Sine and Cosine Between -2\pi and 2\pi')
xlabel('-2\pi < x < 2\pi') 
ylabel('Sine and Cosine Values') 
hold off

% DOC for 1 vs 2 aisle

% Additional:
% # abreast vs DOC

% DOC vs advanced tech

% Weight vs DOC
% df = final plane
plot(df(:,4), df(:,1), ".")