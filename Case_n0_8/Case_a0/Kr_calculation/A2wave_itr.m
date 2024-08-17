function [ LEN ] = A2wave_itr( DEP,PRD )
% ************************* INTRO *************************** %
% Inputs: %
% DEP = water depth [m]; %
% PRD = wave period [s]; %
% Outputs: %
% LEN = wave length [m]; %
% *********************************************************** %
% initial wavelength for iteration (Fenton & McKee, 1990)
g = 9.81; % gravitational acceleration [m/s^-2]
EPS = 0.07; % step length [-]
NMAX = 10000; % maximum step [-]
Lp = (g*(PRD^2)/(2*pi))*(tanh((((2*pi/PRD)^2)*DEP/g)^(3/4)))^(2/3);
% derive wavelength by applying iteration
for N = 1:NMAX
    SUM = 0;
    LEN = (g*(PRD^2)/(2*pi))*tanh((2*pi*DEP)/(Lp));
    DIF = LEN-Lp;
    SUM = SUM+DIF^2;
    RMS = sqrt(SUM/(N));
    Lp  = LEN;
    if RMS < EPS
        break;
    end
end
if (N>0.75*NMAX)
    disp('Convergence does not achieved');
end