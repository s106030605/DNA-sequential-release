% Sample time series data (replace this with your own data)
%time = 1:100;
%data = 0.02*time + randn(1, 100);


function [time20, time80] = start_finish_time(data)
    % Calculate the maximum value of the time series
    maxValue = max(data);

    % Define the thresholds for 10% and 90%
    threshold20 = 0.2 * maxValue;
    threshold80 = 0.8 * maxValue;

    % Find the indices where the data crosses the thresholds
    index20 = find(data >= threshold20, 1, 'first');
    index80 = find(data >= threshold80, 1, 'first');

    % Get the corresponding times
    time20 = index20; % You can replace this with the actual time vector if available
    time80 = index80; % You can replace this with the actual time vector if available
end

