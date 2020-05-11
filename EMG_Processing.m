% cryoung 11052020
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The purpose of this script is to streamline the post-processing of raw
%   data collected during experiments. This script will execute the 
%   following commands:
% 
%   Section 1:
%       -Change the folder to the one containing the desired data for
%           filtering.
%       -Import data to the Workspace.
%   Section 2:
%       -Change the folder to the one called "Utilities".
%       -Segments the data using 'emgSegment.m'.
%       -Filters the segmented data from 'emgSegment.m' using
%           'emgFilter.m'.
%   Section 3:
%       -Change the folder to the desired location for the filtered data.
%       -Adds the time column back to the data
%       -Creates a .csv file of the segmented, filtered data.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Section 1: Change current folder to data folder and import desired data

% The folder path leads to folder that contains the raw data
cd('C:\Users\Carl Young\Documents\Work\SURF S20\Data\')

% Filename input
filename = {'DELSYS_trial1_CY.xlsx';'DELSYS_trial2_CY.xlsx';...
    'DELSYS_trial3_CY.xlsx'};
fileNum = length(filename);

% Imports and saves the raw data before moving to original folder
raw_data = cell(fileNum,1);
raw_table = cell(fileNum,1);
for i = 1:fileNum
    raw_table{i} = readtable(filename{i});
    raw_data{i} = table2array(raw_table{i});
end

%% Section 2: Returns to Utilities folder and filters data

cd('C:\Users\Carl Young\Documents\Work\SURF S20\Code\Utilities\')

% Prompts user for start times and segments
[emgsegment,start,stop] = emgSegment(raw_data);

% Filter data
filteredEMG = emgFilter(emgsegment);

%% Section 3: Changes to new folder and saves the filtered data

cd('C:\Users\Carl Young\Documents\Work\SURF S20\Filtered Data\')

for i = 1:length(filteredEMG)
    % Extracting the headers from the original .xlsx files
    VarNames = raw_table{i}.Properties.VariableNames;

    % Turning arrays back into tables
    trial = array2table(filteredEMG{i});
    trial.Properties.VariableNames = VarNames(2:7);
    trial.X_s_ = raw_data{i}(start(i):stop(i),1);

    % Creating the files
    writetable(trial,sprintf('%s',strrep(filename{i},...
        'CY.xlsx','CY_filtered.csv')));
end
