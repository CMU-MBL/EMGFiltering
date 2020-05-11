% cryoung 09052020

%% HOW TO USE
%
% Section 1: 
%   -Change line 19 to the folder containing data
%   -Change line 22 to have names of files for filtering
%   -When prompted, select the start time of the segment desired,
%    followed by the stop time. (NOTE: every input is recorded,
%    click using the left mouse button ONLY)
% Section 2: (NR_emgimport_edit.m,CY_EMGFilter)
%   -Change line 36 to the folder containing code (should be start folder)
% Section 3:
%   -Change line 46 to the folder for the destination for the filtered data
%
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

%% Section 2: Returns to code folder and filters data

cd('C:\Users\Carl Young\Documents\Work\SURF S20\Code\')

% Prompts user for start times and segments
[emgsegment,start,stop] = NR_emgimport_edit(raw_data);

% Filter data
filteredEMG = CY_EMGFilter(emgsegment);

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




