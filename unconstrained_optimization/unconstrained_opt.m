%clc,close all;clear;

function [lossHistory, p] = unconstrained_opt()

%inital guess for parameter 
kPayload=4; %3(2022) 4 (2020) ;%uM^-1 s^-1 (7nt toe)    uM^-1 s^-1 = 10^6 M^-1 s^-1
kConvert=0.012619; %0.05;(2022)  0.02(2020);%uM^-1 s^-1 (4nt toe)
kSource= 0.2*10^-5; %0.5*10^-6; %(2022)  %0.2*10^-5 (2020);%uM^-1s^-1 (0nt toe) 
p0 = [kPayload; kConvert; kSource];


%read experimental data
global dataExp;
dataExp = csvread('Experiment_payload1234_concen.csv');


global simTimeStore;
simTimeStore = zeros(24,2);
global simTindex;
simTindex = 0;  

    % Initialize loss history
    lossHistory = [];
    function stop = storeLoss(p, optimValues, state)
        stop = false;
        %if isequal(state, 'iter')
            lossHistory = [lossHistory; optimValues.fval];
        %end
    end


%objective function is the square of the difference of starting time and 
%finishing time btw simulation numerical data and experimental data
fun = @objective; %function handled crated
%identify unknown parameters

% Set options for fminunc, including specifying that it should display output
options = optimoptions('fminunc', 'OutputFcn', @storeLoss, 'Display', 'iter','MaxFunctionEvaluations', 5);





%the nonlinear function and the value of the function at the minimum 
%options = optimoptions('fminunc', 'TolFun', 1e-6, 'TolX', 1e-6, 'MaxIter', 1);
%[p, fval, exitflag, output] = fminunc(@(p) fun(p), p0, options);
%[p,fval] = fminunc(fun,p0);
[p, fval, exitflag, output] = fminunc(fun, p0, options);


% Access the parameter history from 'iteration_history'
    % Output loss history
disp('Loss history:');
disp(lossHistory);



%optimized parameter values
kPayload = p(1);
kConvert = p(2);
kSource = p(3);
disp(['kPayload: ' num2str(kPayload)]);
disp(['kConvert: ' num2str(kConvert)]);
disp(['kSource: ' num2str(kSource)]);

%csvwrite('simTimeStore.csv', simTimeStore);
end