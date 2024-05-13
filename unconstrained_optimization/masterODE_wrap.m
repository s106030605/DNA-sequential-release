

%https://github.com/MishaRubanov/SchulmanLab/tree/main/SimCRN-MATLAB
%clear all %#ok<CLALL>
%close all
%clc

function p_all=masterODE_wrap(p)


%INPUT VARIABLES
%signal means Trigger
runTime=15*3600;%The time to run the simulation for (s)
runIdeal=1;
run3SM=0;

cSignal1=0.1125;%uM #without source 
%cPayload=[0.1,0.1,0.1,0.1];%uM figSI1.1
cPayload=[0.05,0.05,0.05,0.05];%uM figSI1.1
%cPayload=[0.011,0.010,0.011,0.008];%uM figSI1.1
%cPayload=[0.010,0.015,0.020,0.025];%uM figSI1.9
%cPayload=[0.025,0.025,0.025,0.015,0.025,0.005,0.025];%uM figSI1.11
numStages=4; %4;7 for figSI1.11 
convertFactor=1.5;%ratio of [convert] to [payload]
includeClock=1;%1;
cSource=2;%uM  %c for source and initiator
%to consider occlusion
includeOcclusionIn3SM=1;%1*1;
%to consider reactant impurities
impurityFactorIn3SM=1;%1*0.1;

%%
if runIdeal
    %Ideal CRN calculations
    %kPayload=4; %3(2022) 4 (2020) ;%uM^-1 s^-1 (7nt toe)    uM^-1 s^-1 = 10^6 M^-1 s^-1
    %kConvert=0.02 %0.05;(2022)  0.02(2020);%uM^-1s^-1 (4nt toe)
    %kSource= 0.2*10^-5; %0.5*10^-6; %(2022)  %0.2*10^-5 (2020);%uM^-1s^-1 (0nt toe) 
    %kSource=0.2/(3600*24); %100nM^/day  (0.1uM) figSI11.10  uM^-1s^-1 (0nt toe)  fig.SI.1.10: 0.1 0.2
    %Construct CRN
    kPayload = p(1);
    kConvert = p(2);
    kSource = p(3);
    
    crn=simCRN();
    if includeClock
        
        
        crn.addRxn({'source','initiator'},{'signal1'},kSource,0);
        %bimolecular
        clock
                %crn.addRxn({},{'signal1'},(0.200)/(24*3600),0);%unimolecular
        clock
        crn.setConcentration('source',cSource);
        crn.setConcentration('initiator',cSource);
    else
        crn.setConcentration('signal1',cSignal1);
    end

    for i=1:numStages
        %payload
        
        crn.addRxn({['signal',num2str(i)],['payload',num2str(i)]},...
            {['output',num2str(i)]},kPayload,0);
        crn.setConcentration(['payload',num2str(i)],cPayload(i));
        
        %convert
        %cConvert=[0.5,0.15,0.075];%uM figSI1.1
        cConvert=[0.45,0.3,0.15];%uM 100nM
        %cConvert=[0.3375,0.1875,0.0375];%uM 100nM
        %cConvert=[0.1125,0.075,0.0375];%uM figSI1.1
        %cConvert=[0.1125,0.075,0.0375];%uM figSI1.1
        %cConvert=[0.090,0.0676,0.0375];%uM figSI1.9
        %cConvert=[0.180,0.1425,0.105,0.0825,0.045,0.0375];%uM figSI1.11
        if i<numStages
            %we don't need a convert reaction for the final stage
        
            crn.addRxn({['signal',num2str(i)],['convert',num2str(i)]},...
                {['signal',num2str(i+1)]},kConvert,0);
            
            %crn.setConcentration(['convert',num2str(i)],...
            %    convertFactor*sum(cPayload(i+1:end)));

            crn.setConcentration(['convert',num2str(i)],...
                (cConvert(i)));  
            %uM figSI1.9
        %uM
    end
end

    
    crn.runSim(runTime,@ode45);
    
    %plots
    %species2Plot={'output1','output3','output5','output7'};
    species2Plot={'output1','output2','output3','output4'};
    figure('Position', [10 10 6*300 1.25*300]);
    hold on
        
    plotColors={[203,32,39]/255,[0,174,239]/255,[0,166,81]/255,[0,0,0],[1,0,0]};

    for i=1:length(species2Plot)
          
           
        plot(crn.time/3600,crn.conc(crn.getSpeciesIdsByNames(species2Plot{i}),:)*1000,...
            'LineWidth',3,'Color',plotColors{i});
    end

    legend(species2Plot);
    xlabel('time (hr)');
    ylabel('Concentration (nM)');
    set(gca, 'FontSize',21);
end



%return the 4 stages concentration
%output_csv(crn);   


t=crn.time/60;
%p1=crn.conc(crn.getSpeciesIdsByNames(species2Plot{1}),:)*1000;
%p2=crn.conc(crn.getSpeciesIdsByNames(species2Plot{2}),:)*1000;
%p3=crn.conc(crn.getSpeciesIdsByNames(species2Plot{3}),:)*1000;
%p4=crn.conc(crn.getSpeciesIdsByNames(species2Plot{4}),:)*1000;
p1=crn.conc(5,:)*1000;
p2=crn.conc(9,:)*1000;
p3=crn.conc(13,:)*1000;
p4=crn.conc(17,:)*1000;
p_all = vertcat(t,p1, p2, p3, p4);
writematrix(p_all, './Simulation_p1234_50nM.csv');


end
 