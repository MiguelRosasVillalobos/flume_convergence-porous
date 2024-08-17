% Codigo para Kr (Mansard and Funke)
% Inicio
clc; 
clear all;
% Definir el nombre del archivo
filename = 'Kr_lci.csv';
cases = 6;

% Asegurarse de que el archivo esté vacío o crear uno nuevo
if exist(filename, 'file')
    delete(filename);
end

% Escribir encabezados (opcional)
headers = {'"Kr"', '"a"'};
fid = fopen(filename, 'w');
fprintf(fid, '%s,%s\n', headers{:});
fclose(fid);

% Definir el cell array de nombres de archivos
files = {'freesurface_caselc0_025.txt';
         'freesurface_caselc0_02.txt';
         'freesurface_caselc0_01.txt';
         'freesurface_caselc0_009.txt';
         'freesurface_caselc0_007.txt';
         'freesurface_caselc0_005.txt'};

a = [1,2,3,4,5,6];


for cas=1:cases

%Datos
% WAVE  = load([files(cas)]);
WAVE = readmatrix(files{cas});

% Test information
X1P = [0, 0.07549, 0.15098]    ; % Distance between the probe P and 1 [m]    [CCCCCCC]
D   = 0.3            ; % Water depth [m]
TP  = 0.7              ; % Wave period [s] CAMBIA SEGUN LOS DATOS
LN  = A2wave_itr( D,TP ) ; % Wavelength [m]
W   = 2*pi/TP            ; % Circular frequency [rad/s]

%tiempo (s)
TIME = WAVE(:,4);

%Elevación (m)
ELEV  = [WAVE(:,1),WAVE(:,2),WAVE(:,3)]  ;

% Parámetro para el dominio del tiempo
DT = TIME(10)-TIME(9) ; % Tasa de muestreo [s]
FS = 1/DT             ; % Frecuencia de muestreo [Hz]

% Extraer onda compuesta (co-wave)
TS = 20   ; % TS = Punto de inicio

% Inicio Elevación
for j = 1:3
    COWV(:,j) = ELEV(ceil(TS*FS):end,j);
end

% Inicio Tiempo
TC = TIME(ceil(TS*FS):end)   ; % vector de tiempo
T  = TC-TC(1)                ; % vector de tiempo (común)

% Análisis de espectros
% Paso 1 y 2 (Mansard and Funke)
for j = 1:3
    [ AXX(:,j),SXX(:,j),APH(:,j),FA(:,j),HMO(j), HMO2(:,j) ]...
        = A3autospec( T,COWV(:,j) );
end

% Paso 3 y 4 (Mansard and Funke)
for j = 1:3
    [ AXY(:,j),SXY(:,j),XPH(:,j),FX(:,j) ]...
        = A4crosspec( T,COWV(:,1),COWV(:,j) );
end

% Paso 5 y 6 (Mansard and Funke)
for j = 1:3
    B(:,j) = HMO2(:,j).*cos(XPH(:,j)) + 1i*HMO2(:,j).*sin(XPH(:,j));
end 

% Paso 7 (Mansard and Funke)
Bk = 2*pi*X1P(1,2)/LN; 
Yk = 2*pi*X1P(1,3)/LN;

% Paso 8 (Mansard and Funke)
Dk = 2*(sin(Bk)^2 + sin(Yk)^2 + sin(Yk-Bk)^2)  ;
R1k = sin(Bk)^2 + sin(Yk)^2                    ;
Q1k = sin(Bk)*cos(Bk) + sin(Yk)*cos(Yk)        ;
R2k = sin(Yk) * sin(Yk-Bk)                     ;
Q2k = sin(Yk) * cos(Yk-Bk) - 2*sin(Bk)         ;
R3k = -sin(Bk) * sin(Yk-Bk)                    ;
Q3k = sin(Bk)*cos(Yk-Bk) - 2*sin(Yk)           ;

% Paso 9 (Mansard and Funke)
ZIk = 1/Dk *(B(:,1)*(R1k+1i*Q1k)+B(:,2)*(R2k+1i*Q2k)+B(:,3)*(R3k+1i*Q3k));
ZRk = 1/Dk *(B(:,1)*(R1k-1i*Q1k)+B(:,2)*(R2k-1i*Q2k)+B(:,3)*(R3k-1i*Q3k));
ABSZIk = abs(ZIk);
ABSZRk = abs(ZRk);

% Paso 10 (Mansard and Funke)
DF = FA(2,1)-FA(1,1);
NSI = (ABSZIk.^2)/(2*DF);
NSR = (ABSZRk.^2)/(2*DF);

% Paso 11 (Mansard and Funke)
KR = ABSZRk./ABSZIk;

% Paso 12 (Mansard and Funke)
CF12 = SXY(:,2)./sqrt(SXX(:,1).*SXX(:,2));
CF13 = SXY(:,3)./sqrt(SXX(:,1).*SXX(:,3));

% Altura de la ola incidente y reflejada
NS = 16;
HI = 4*sqrt(sum(NSI(NS:end))*DF)
HR = 4*sqrt(sum(NSR(NS:end))*DF)        % Para una señal SIN Ruido (Ideal)
% HR = 2.27*sqrt(sum(NSR(NS:end))*DF)     % Para una señal CON Ruido (Real)

% Coeficiente de reflexión
KR2 = (HR/HI)*100

% Añadir estos datos al archivo CSV
    dlmwrite(filename, [KR2,a(cas)], '-append');
clear WAVE COWV AXX SXX APH FA HMO HMO2 AXY SXY XPH FX B
end
%

% Arreglar la parte de los graficos si se puede (VER)
% Display of reflection analysis
% Titles of the plots
% TT1 = ['Espectros medidos of'];
% TT2 = ['Espectros calculados'];

% Lables of the Hmo
% ML1 = ['P1: H_{mo1} = ',num2str(round(HMO(1)*1000)/1000),' m'];
% ML2 = ['P2: H_{mo2} = ',num2str(round(HMO(2)*1000)/1000),' m'];
% ML3 = ['P3: H_{mo3} = ',num2str(round(HMO(3)*1000)/1000),' m'];

% Lables of HI, HR, and KR
% MLI  = ['S_I: H_{I} = ',num2str(round(HI*1000)/1000),' m'];
% MLR  = ['S_R: H_{R} = ',num2str(round(HR*1000)/1000),' m'];
% MLKR = ['K_R = ',num2str(round(HR/HI*10000)/100),' %'];

% Plot 1: Measured spectra
% figure (1)
% for j = 1:3
%     plot(FA(:,j),(AXX(:,j)*4));
%     hold on
% end

% xlim([1,2]);
% ylim([0,0.05]);
% xlabel('f [Hz]');
% ylabel('S_{\eta\eta} [m^2/Hz]');
% legend(num2str(ML1),num2str(ML2),num2str(ML3));
% title(num2str(TT1));
% hold off
% grid on
% pbaspect([1 1 1]) % Equal axis lengths in all directions

% Plot 2: Computed spectra
% figure(2)
% Spectra of HI and HR
% yyaxis left % y-axis of HI and HR
% title(num2str(TT2));
% plot(FA(:,1),(NSI(:,1)*10));
% hold on
% plot(FA(:,1),(NSR(:,1)*10));
% xlim([1,1.4]);
% ylim([0,0.05]);
% xlabel('f [Hz]');
% ylabel('S_{\eta\eta} [m^2/Hz]');

% Spectrum of KR
% yyaxis right % y-axis of KR
% plot(FA(:,1),KR*100,'-.');
% xlim([1,2]);
% ylim([0,60]);
% ylabel('K_R [%]');
% legend(num2str(MLI),num2str(MLR),num2str(MLKR));
% hold off
% grid on
% pbaspect([1 1 1]) % Equal axis lengths in all directions
