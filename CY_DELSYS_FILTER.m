%cryoung 03052020

clc;
clear all; %#ok<CLALL>
close all;

%% Importing all the Data
% To change the time interval that is observed and filtered, adjust the
% index. 
%
% Example: timeDelsys1 = table2array(Delsys1(start_time:end_time,1)
%           LRFDelsys1 = table2array(Delsys1(start_time:end_time,2:7)
%
% Trial 1 Range: [18925 75483]
% Trial 2 Range: [36360 110391]
% Trial 3 Range: [19700 90552]
%
% Filenames
filename1 = 'DELSYS_trial1_CY.xlsx';
filename2 = 'DELSYS_trial2_CY.xlsx';
filename3 = 'DELSYS_trial3_CY.xlsx';

% Trial 1 Delsys Data
Delsys1 = readtable(filename1); 
timeDelsys1 = table2array(Delsys1(:,1));
LRFDelsys1 = table2array(Delsys1(:,2:7)); 

% Trial 2 Delsys Data
Delsys2 = readtable(filename2);
timeDelsys2 = table2array(Delsys2(:,1));
LRFDelsys2 = table2array(Delsys2(:,2:7));

% Trial 3 Delsys Data
Delsys3 = readtable(filename3);
timeDelsys3 = table2array(Delsys3(:,1)); 
LRFDelsys3 = table2array(Delsys3(:,2:7));

%% Filter the Delsys Data 
% The varaibles are all labeled for the Left Rectus Femoris, but they do
% not actually correspond with this. They are for all the muscles in the
% trial.
%
% Highpass Delsys
dt_D = 0.000519231;
fcut = 1;
order = 4;
type = 'hp';
lrfd_hp1 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,LRFDelsys1);
lrfd_hp2 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,LRFDelsys2);
lrfd_hp3 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,LRFDelsys3);

% Bandpass Delsys
fcut = [20, 450];
type = 'bp';
lrfd_bp1 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,lrfd_hp1);
lrfd_bp2 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,lrfd_hp2);
lrfd_bp3 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,lrfd_hp3);

% Moving RMS Delsys
% Unsure about the values for these with the Delsys Sensors
time_window = 0.0005;                  
window_size = round(time_window/dt_D);   
movRMS = dsp.MovingRMS(window_size);   
lrfd_rms1 = movRMS(lrfd_bp1);
lrfd_rms2 = movRMS(lrfd_bp2);
lrfd_rms3 = movRMS(lrfd_bp3);

% Lowpass Delsys
fcut = 60;
order = 2;
type = 'lp';
lrfd_fin1 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,lrfd_rms1);
lrfd_fin2 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,lrfd_rms2);
lrfd_fin3 = ZeroLagButtFiltfilt(dt_D,fcut,order,type,lrfd_rms3);

% Normalized Delsys
normDelsys1 = abs(mean(lrfd_fin1));
normDelsys2 = abs(mean(lrfd_fin2));
normDelsys3 = abs(mean(lrfd_fin3));
lrfd_norm1 = lrfd_fin1./normDelsys1;
lrfd_norm2 = lrfd_fin2./normDelsys2;
lrfd_norm3 = lrfd_fin3./normDelsys3;

%% Saving the filtered data into .csv files
% Extracting the headers from the original .xlsx files
VarNames1 = Delsys1.Properties.VariableNames;
VarNames2 = Delsys2.Properties.VariableNames;
VarNames3 = Delsys3.Properties.VariableNames;

% Turning arrays back into tables
% trial1.X_s_ = ... adds another column to append the time to the data
trial1 = array2table(lrfd_norm1);
trial1.Properties.VariableNames = VarNames1(2:7);
trial1.X_s_ = timeDelsys1;
trial2 = array2table(lrfd_norm2);
trial2.Properties.VariableNames = VarNames2(2:7);
trial2.X_s_ = timeDelsys2;
trial3 = array2table(lrfd_norm3);
trial3.Properties.VariableNames = VarNames3(2:7);
trial3.X_s_ = timeDelsys3;

% Creating the files
writetable(trial1,'DELSYS_trial1_CY_filtered.csv')
writetable(trial2,'DELSYS_trial2_CY_filtered.csv')
writetable(trial3,'DELSYS_trial3_CY_filtered.csv')

%% Sanity Check
% Verifies that the plots are how they should look
% 
subplot(3,1,1)
plot(timeDelsys1,lrfd_norm1)
% xlim([18925 75483])
title('Trial 1')
subplot(3,1,2)
plot(timeDelsys2,lrfd_norm2)
% xlim([36360 110391])
title('Trial 2')
subplot(3,1,3)
plot(timeDelsys3,lrfd_norm3)
% xlim([19700 90552])
title('Trial 3')
