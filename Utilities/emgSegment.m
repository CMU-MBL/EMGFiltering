% nrokh 04.01.2020
% cryoung edit 11052020
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Inputs  = raw_data: the raw data from the sensors in a cell array.
% Outputs = emgsegment: a segment of the raw data in a cell array.
%           start: an array of the start indicies selected.
%           stop: an array of the stop indicies selected.
% 
% This function only saves the data within two data points that are
% selected by the user. End points for the segmentation are created by 
% clicking at the x-value for each of the plots that appear when callled.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [emgsegment,start,stop] = emgSegment(raw_data)

% Preallocate cells to have a column for each input
rows = length(raw_data);    % Used for creating the data columns below
store = cell(rows, 1);      % Cell column for data without outliers
start = zeros(rows,1);      % Array column for start times
stop = zeros(rows,1);       % Array column for stop times
emgsegment = cell(rows, 1); % Cell column for output

% Section 1: Update data and 
for i = 1:rows              % Loop through the number of cells
    emgraw = raw_data{i}(:,2:end);
    
    % Use rmoutliers function to remove 0.1 percentile of outliers by mean
    emg_rmOutliers = rmoutliers(emgraw, 'percentiles', [0.1 99.9]);
    
    % Saves EMG data without outliers
    store{i} = emg_rmOutliers;
    
    % Displays plots for the start/stop times to be selected
    subplot(rows, 1, i)
    plot(store{i})
    title('Imported raw EMG with 1% of outliers removed')
    [x,~] = ginput(2);
    start(i) = x(1);
    stop(i) = x(2);
end

close all; 

for i = 1:rows              % Loop through the number of cells
    % Segments and saves updated data
    emgsegment{i} = store{i}(start(i):stop(i),:);
end

end

