function [ Axy,Sxy,XPh,f ] = A4crosspec( t,eta1,eta2 )

% Generating single-sided cross spectra
% Input:
% t = time vector
% eta1 = time series of signal1
% eta2 = time series of signal2
% Output:
% Axy = 1-sided amplitude cross spectrum
% Sxy = 1-sided power cross spectrum
% XPh = phase shift
% f = frequency vector

% Parameters for frequency domains
nfft = 2*length(t)-1; % Length of signal
dt = t(2)-t(1); % Sampling rate [s]
fs = 1/dt; % Sampling frequency [Hz]
fN = fs/2; % Nyquist frequency [Hz]
fo = 1/(nfft*dt); % Fundmental frequency [Hz]
f = fo*(0:(nfft+1)/2-1)'; % Frequency vector [Hz]

% Auto spectra (Axx and Sxx)
Axx1 = fft(eta1,nfft)/nfft; % 2-sided Axx(f) for eta1 (complex)
Axx2 = fft(eta2,nfft)/nfft; % 2-sided Axx(f) for eta2 (complex)
Axy2 = sqrt(Axx1.*conj(Axx2)); % 2-sided Axy(f)
Axy = 2*abs(Axy2(1:(nfft+1)/2)); % 1-sided Axy(f) (real)
Sxy = Axy.^2/(2*fo); % 1-sided Sxy(f)
XPh = angle(Axx1(1:(nfft+1)/2)./Axx2(1:(nfft+1)/2)); % Phase shift  (PH11,12,13)
end