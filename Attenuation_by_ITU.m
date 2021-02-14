
% RAIN ATTENUATION DISTRIBUTION IN NIGERIA
%
%%% ITU model
clear;clc;

%% rainfall (mm) for 2007 to 2016

Rainfall=[921.335	927.315	913.39	1302	1690	1693	1839	1766	1686.5	1607
760.18	773.04	755.35	976	1196	1279	1722	1501	1441	1382
487.415	476.04	474.215	610	745	799	981	890	914	938
624.685	614.615	628.185	922	1216	1040	1169	1105	1089	1072
318.72	303.08	308.22	441	573	430	669	550	560	569
1232.895	1197.59	1220.835	1669	2117	2131	2478	2305	2246	2186
];


%% Geographical parameters [Latitude, Longitude, Altitude(m)]

enugu_ps = [6.50,7.00,137.3]; % Enugu
ikeja_ps = [6.58,3.33,128.55]; % Ikeja
kano_ps = [12.05,8.53,475.8]; % Kano
lokoja_ps = [7.8,6.73,62.4]; % Lokoja
maidu_ps = [11.85,13.08,348.0]; % Maiduguri
portH_ps = [4.85,7.12,84.5]; % Port-Harcourt

Citygeo = [enugu_ps;ikeja_ps;kano_ps;lokoja_ps;maidu_ps;portH_ps];


%% ITU Parameters
p = 1e-2; % probability
theta = 10; % elevation of antenna (degree)
k = [0.0188,0.0168]; % horizontal, vertical
alpha = [1.217,1.200]; % horizontal, vertical 

%% Computation of Attenuation for Horizontal polarization
% ku-band 12GHz

%===== 
horAttenu = zeros(6,10); % preallocate to keep computed attenuation

for yr = 1:10
    
    for ct = 1:6
        
      cityrain = Rainfall(ct,yr); % city,year
      citylat = Citygeo(ct,1); % city latitude
      cityhalt = Citygeo(ct,3); % city altitude
      
      Rr = 17.08*cityrain^0.437; % rainfall rate for 0.01%
      hR = 5-0.075*(citylat-4); % effective rain height
      Ls = (hR - cityhalt)/sind(theta); % slant-path length
      Lg = Ls*cosd(theta); % horizontal projection
      Lo = 35*exp(-0.015*Rr); 
      r = 1/(1+Lg/Lo); % reduction factor
      gamma = k(1)*Rr*alpha(1); % specific attenuation [dB/km]
      A = gamma*Ls*r; % estimated attenuation
      ApE = A.*0.12.*p.^(-(0.546+0.043*log(p))); % Attenuation
      
      horAttenu(ct,yr) = ApE; 
    end
    
end
horAttenu



%% Computation of Attenuation for Vertical polarization
% ku-band 12 GHz

%===== 
verAttenu = zeros(6,10); % preallocate to keep computed attenuation

for yr = 1:10
    
    for ct = 1:6
        
      cityrain = Rainfall(ct,yr); % city,year
      citylat = Citygeo(ct,1); % city latitude
      cityhalt = Citygeo(ct,3); % city altitude
      
      Rr = 17.08*cityrain^0.437; % rainfall rate for 0.01%
      hR = 5-0.075*(citylat-4); % effective rain height
      Ls = (hR - cityhalt)/sind(theta); % slant-path length
      Lg = Ls*cosd(theta); % horizontal projection
      Lo = 35*exp(-0.015*Rr); 
      r = 1/(1+Lg/Lo); % reduction factor
      gamma = k(2)*Rr*alpha(2); % specific attenuation [dB/km]
      A = gamma*Ls*r; % estimated attenuation
      ApE = A.*0.12.*p.^(-(0.546+0.043*log(p))); % Attenuation
      
      verAttenu(ct,yr) = ApE; 
    end
    
end

verAttenu


