% cryoung 10052020

% Function:

% Usage:

function filteredEMG = CY_EMGFilter(emg_data) %,start,stop)


% Data
raw_data = emg_data;
filteredEMG = cell(length(emg_data),1);

for i = 1:length(emg_data)
    % 1Hz Highpass Filter
    dt_D = 0.000519231;
    fcut = 1;
    order = 4;
    type = 'hp';
    hp_data = ZeroLagButtFiltfilt(dt_D,fcut,order,type,raw_data{i});

    % 20Hz-450Hz Bandpass Filter
    fcut = [20, 450];
    type = 'bp';
    bp_data = ZeroLagButtFiltfilt(dt_D,fcut,order,type,hp_data);

    % Moving RMS 
    % Unsure about the values for these with the Delsys Sensors
    time_window = 0.0005;                  
    window_size = round(time_window/dt_D);   
    movRMS = dsp.MovingRMS(window_size);   
    rms_data = movRMS(bp_data);

    % 60Hz Lowpass Filter
    fcut = 60;
    order = 2;
    type = 'lp';
    fin_data = ZeroLagButtFiltfilt(dt_D,fcut,order,type,rms_data);

    % Normalize
    norm_data = abs(mean(fin_data));
    filteredEMG{i} = fin_data./norm_data;
end
end
