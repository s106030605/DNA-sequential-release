%define objective function
function loss =objective(p)

close all;
%function handle to pass p through masterODE_wrap function and obtain numerical
%model by solving nonlinear differential equation
p_all = masterODE_wrap(p);

%return simulation numerical data of concentration over time
%dataSim = csvread('S2_p1234_50.csv');
dataSim = p_all;
timeSim= dataSim(1,:);
startT_Sim  = zeros(4,1);
finishT_Sim = zeros(4,1);

%dataExp = csvread('payload1234_concen.csv');
global dataExp;
timeExp= dataExp(1,:)*2;
startT_Exp  = zeros(4,1);
finishT_Exp = zeros(4,1);


global simTimeStore;
global simTindex;
for i = 1  : 4  
    data=dataSim(1+i,:);
    % Call the function and get the threshold times
    [time20, time80] = start_finish_time(data);
    fprintf('Sim Time when data reaches 20%%: %d\n', timeSim(time20));%timeSim(time20)
    fprintf('Sim Time when data reaches 80%%: %d\n', timeSim(time80));
    startT_Sim(i)=timeSim(time20);
    finishT_Sim(i)= timeSim(time80);
    simTimeStore (simTindex*4+i,1) = timeSim(time20);
    simTimeStore (simTindex*4+i,2) = timeSim(time80);
    
    
    data=dataExp(1+i,:);
    %disp(data)
    [time20, time80] = start_finish_time(data);
    fprintf('Exp Time when data reaches 20%%: %d\n', timeExp(time20));
    fprintf('Exp Time when data reaches 80%%: %d\n', timeExp(time80));
    startT_Exp(i)= timeExp(time20);
    finishT_Exp(i)=timeExp(time80);
end


simTindex = simTindex + 1; 


%objective function to minimize the square of the difference
%between the numerical data and experimental data
A = (startT_Exp-startT_Sim).^2 + (finishT_Exp-finishT_Sim).^2;
%disp(startT_Exp); 
%disp(startT_Sim); 
%disp(startT_Exp-startT_Sim);
%disp((startT_Exp-startT_Sim).^2);
%disp(sum((startT_Exp-startT_Sim).^2));
%%disp((finishT_Exp-finishT_Sim).^2)
%disp(sum((finishT_Exp-finishT_Sim).^2));
%disp(finishT_Exp);
%disp(finishT_Sim);
loss = sum(A);
disp('Loss function')
disp(loss)
end