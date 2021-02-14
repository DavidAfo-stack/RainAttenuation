
% PREDICTION OF RAIN ATTENUATION DISTRIBUTION IN NIGERIA USING ANN
%
clear;clc;

%% rainfall (mm) for 2007 to 2016

Rainfall=[921.335	927.315	913.39	1302	1690	1693	1839	1766	1686.5	1607
760.18	773.04	755.35	976	1196	1279	1722	1501	1441	1382
487.415	476.04	474.215	610	745	799	981	890	914	938
624.685	614.615	628.185	922	1216	1040	1169	1105	1089	1072
318.72	303.08	308.22	441	573	430	669	550	560	569
1232.895	1197.59	1220.835	1669	2117	2131	2478	2305	2246	2186
];

%{
%==== Horizontal polarization
Attenuation=[1.0386	1.0267	1.0546	0.5292	0.2914	0.2902	0.236	0.2614	0.2929	0.3291
1.4358	1.3977	1.4504	0.9361	0.6318	0.5496	0.2783	0.3861	0.4237	0.465
2.6866	2.7657	2.7787	1.9972	1.4819	1.3241	0.9272	1.1035	1.0532	1.0057
1.9334	1.9787	1.918	1.0377	0.6108	0.8319	0.6619	0.7403	0.7616	0.7851
4.2717	4.4783	4.4089	3.0301	2.1781	3.12	1.7475	2.3013	2.2466	2.1989
0.5936	0.6302	0.6058	0.3005	0.1626	0.1596	0.1037	0.1281	0.1379	0.1488
];
%}

%{
%==== Vertical polarization
Attenuation=[0.9152	0.9047	0.9293	0.4663	0.2568	0.2557	0.2079	0.2303	0.2581	0.29
1.2651	1.2315	1.278	0.8249	0.5567	0.4843	0.2452	0.3402	0.3733	0.4097
2.3673	2.437	2.4484	1.7598	1.3058	1.1667	0.817	0.9723	0.928	0.8862
1.7036	1.7435	1.69	0.9143	0.5382	0.7331	0.5832	0.6523	0.6711	0.6918
3.7639	3.946	3.8848	2.67	1.9192	2.7491	1.5398	2.0278	1.9796	1.9375
0.523	0.5553	0.5338	0.2648	0.1432	0.1407	0.0914	0.1129	0.1215	0.1311
];
%}


%==== mean attenuation
Attenuation=[0.9769	0.9657	0.9920	0.4978	0.2741	0.2730	0.2220	0.2459	0.2755	0.3096
1.3505	1.3146	1.3642	0.8805	0.5943	0.5170	0.2618	0.3632	0.3985	0.4374
2.5270	2.6014	2.6136	1.8785	1.3939	1.2454	0.8721	1.0379	0.9906	0.9460
1.8185	1.8611	1.8040	0.9760	0.5745	0.7825	0.6226	0.6963	0.7164	0.7385
4.0178	4.2122	4.1469	2.8501	2.0487	2.9346	1.6437	2.1646	2.1131	2.0682
0.5583	0.5928	0.5698	0.2827	0.1529	0.1502	0.0976	0.1205	0.1297	0.1400
];




%%
% PREPROCESSING
% =============
%
%-------------------------------------------------------------------------
% The inputs are normalized between -1 and +1 using the function mapminmax
%-------------------------------------------------------------------------
[dP, ps] = mapminmax(Rainfall); 
[dT, ts] = mapminmax(Attenuation);

disp('End of preprocessing.');disp(' ');

%======= Select data of 2007-2013 to train ANN
Pn = dP(:,1:7); % input data (rainfall)
Tn = dT(:,1:7); % target output (attenuation)


%    DEFINING THE NETWORK
%    ====================

%    The load prediction network will have 10 TANSIG
%    neurons in its hidden layer.

disp('Creating the network object...');disp(' ');

[R,Q] = size(Pn);
[S2,Q]= size(Tn); 

S1 = 10; %hidden neurons
net = newff(minmax(Pn),[S1 S2],{'tansig' 'tansig'},'trainlm');

disp('Network created.');

%    TRAINING THE NETWORK WITHOUT NOISE
%    ==================================

net.performFcn = 'mse';        % Mean-Squared Error performance function
%net.trainParam.lr = 0.005;    % Learning rate
net.trainParam.goal = 1e-2;    % Sum-squared error goal.
net.trainParam.show = 50;      % Frequency of progress displays (in epochs).
net.trainParam.epochs = 100;  % Maximum number of epochs to train.
%net.trainParam.mc = 0.05;      % Momentum constant.

[net,tr] = train(net,Pn,Tn); %training proper


disp('End of training.');


%% PREDICT FOR 2014-2016

disp('Testing ANN');

Pn = dP(:,8:end); % input data (rainfall for 2014-2016)

%==== predict attenuation for 2014-2016 using trained ANN 
Rn = sim(net,Pn);
  
Rnp = mapminmax('reverse',Rn,ts);  %denormalize predicted data


%%
%COMPUTE TRAINING SET ERROR
 % En1 = dT(:,8:end) - Rn; %error

  En = Attenuation(:,8:end) - Rnp; %error

  (mse(En(1,3)))
%%
%save 'objann' net tr ps ts En


