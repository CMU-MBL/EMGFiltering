% cryoung 1152020
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Inputs  = emg_data: the data in a cell array before filtering.
% Outputs = filteredEMG: the filtered data in a cell in a .csv format.
% 
% This function filters the data in a combination of ways to then conduct
% analysis during post-processing. There are 5 main sections of the filter:
% 
% 1. 1Hz Highpass Filter
% 2. 20Hz-450Hz Bandpass Filter
% 3. Moving RMS
% 4. 60Hz Lowpass Filter
% 5. Normalization
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function filteredEMG = emgFilter(emg_data)

% Data Preallocation 
raw_data = emg_data;
filteredEMG = cell(length(emg_data),1);

% Iterates through for each data set
for i = 1:length(emg_data)
    
    % 1. 1Hz Highpass Filter
    Fs = 2000;      
    dt = 1/Fs;      
    fcut = 1;       
    order = 4;
    type = 'hp';
    hp_data = ZeroLagButtFiltfilt(dt,fcut,order,type,raw_data{i});

    % 2. 20Hz-450Hz Bandpass Filter
    fcut = [20, 450];
    type = 'bp';
    bp_data = ZeroLagButtFiltfilt(dt,fcut,order,type,hp_data);

    % 3. Moving RMS 
    % Variables using the built-in library
    time_window = 0.0005;                  
    window_size = round(time_window/dt);   
    movRMS = dsp.MovingRMS(window_size);   
    rms_data = movRMS(bp_data);

    % 4. 60Hz Lowpass Filter
    fcut = 60;
    order = 2;
    type = 'lp';
    fin_data = ZeroLagButtFiltfilt(dt,fcut,order,type,rms_data);

    % 5. Normalization
    norm_data = abs(mean(fin_data));
    filteredEMG{i} = fin_data./norm_data;
    
end
end
