function [ Axx,Sxx,Phi,f,Hmo,Hmo2 ] = A3autospec( t,eta )

% Generating single-sided auto amplitude and power spectra
% Input:
% t = time vector
% eta = time series of signal
% Output:
% Axx = 1-sided amplitude spectrum
% Sxx = 1-sided power spectrum
% Phi = phase angle
% f = frequency vector
% Hmo = significant wave height

% Parameters for frequency domains
nfft = 2*length(t)-1; % Length of signal
dt = t(2)-t(1); % Sampling rate [s]
fs = 1/dt; % Sampling frequency [Hz]
fN = fs/2; % Nyquist frequency [Hz]
fo = 1/(nfft*dt); % Fundmental frequency [Hz]
f = fo*(0:(nfft+1)/2-1)'; % Frequency vector [Hz]

% Auto spectra (Axx and Sxx)
Axx2 = fft(eta,nfft)/nfft; % 2-sided Axx(f) (complex)                  original
Axx = 2*abs(Axx2(1:(nfft+1)/2)); % 1-sided Axx(f) (real)                original
%Axx = abs(Axx2(1:(nfft+1)/2)); % 1-sided Axx(f) (real)                
Sxx = Axx.^2/(2*fo); % 1-sided Sxx(f)                        (S1,2,3)
Phi = angle(Axx2(1:(nfft+1)/2)); % Phase angle
Hmo = 4*sqrt(sum(Sxx*fo)); % Hmo
Hmo2 = sqrt(2*Sxx.*fo); % Hmok                               (A1,2,3)    original
end