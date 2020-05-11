% nrokh 04.01.2020
% 
% this function is used in emg_main.m and pulls only selected ranges from
% the prefilled emgdata cell using user-defined start and stop indices.
% emgdata, start, stop should all be the same column dimension

function store = selectTimes(emgdata, start, stop)
store = cell(length(emgdata), 1); % preallocate mat

    for i = 1:length(emgdata)
        store{i} = emgdata{i}(start(i):stop(i),:);
    end
end
