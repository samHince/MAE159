
% Week 2 sample calculations
% Written by Sam Hince
% 04/05/2021

% Note on the use of MATLAB: I would normally tackle problems like this in
% in R, however in the interest of clear communication with others and ease
% of grading I will use MATLAB for the bulk of this class. 

clc;
clear;

%% Input parameters
Pax = 214;
W_Cargo = 3000;     %lbs
Range = 3900;       %nmi
TOFL = 6300;        %ft
AP = 140;           %kts
M_Cruise = 0.80;
Alt = 35000;        %feet

Aisles = 1;
Sweep = 35;         %degree
Engines = 2;        

%% Constants
% kinematic viscosity, pressure, ect...
rho_sea = 0.002377;
rho_hot = 0;
rho_15000 = 0;
rho_20000 = 0;
rho_35000 = 0;