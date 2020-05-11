% nrokh 04.01.2020
% cryoung edit 10052020
% 
% EDIT: -added 'ginput' in line 33 associated with output in line 13,
%       preallocation for start and stop in lines 15 and 16, storing data
%       in line 35 and 36, and closing the plot at the end of the code.
%
%       -also removed 'datacursormode on' because of ginput use
%
% this function is used in emg_main.m and imports raw EMGs that the user 
% selects, removes 0.1% of outliers and displays a plot of all EMGs input.
% takes a variable string input and outputs an Nx1 pre-selected EMG cell

function [emgsegment,start,stop] = NR_emgimport_edit(raw_data)

% Preallocate cells to have a column for each input
store = cell(length(raw_data), 1); 
start = zeros(length(raw_data),1);
stop = zeros(length(raw_data),1);

for i = 1:length(raw_data)        % loop through the number of cells
    emgraw = raw_data{i}(:,2:end);
    
    % use rmoutliers function to remove 0.1 percentile of outliers by mean
    emg_rmOutliers = rmoutliers(emgraw, 'percentiles', [0.1 99.9]);
    
    % after removing outliers, save emg data in cell column
    store{i} = emg_rmOutliers;
    
    % display individual plots 
    subplot(length(raw_data), 1, i)
    plot(store{i})
    title('Imported raw EMG with 1% of outliers removed')
    [x,~] = ginput(2);
    start(i) = x(1);
    stop(i) = x(2);
end
close all;

emgsegment = cell(length(store), 1); % preallocate mat

    for i = 1:length(store)
        emgsegment{i} = store{i}(start(i):stop(i),:);
    end

end

