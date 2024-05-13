use fminunc to do quasi-Newton optimization for finding optimal reaction rate constant, but it doesn't work.
(Please execute unconstrained_opt.m file)


unconstrained_opt.m: use fminuc to do unconstrained optimization
this function will read experimental data: Experiment_payload1234_concen.csv

objective.m: the objective function that takes the square error of starting and finishing time for 4 stages. 

masterODE_wrap.m: the kinetic modeling for 4 stages concentration using the ODE given reaction rate constant p.  
this will generate simulation data : Simulation_p1234_concen.csv

for more information: please refer to Scalise, Dominic, et al. "Programming the sequential release of DNA." ACS Synthetic Biology 9.4 (2020): 749-755. 

simCRN.m: a file necessary for masterODE_wrap   
odeabort.m:  a file necessary for masterODE_wrap  
odeprog.m:  a file necessary for masterODE_wrap  


start_finish_time.m: to determine the starting and finishing time where the concentration reach 20% and 80% of max value. 

payload1234_concen.csv list the 4 stage concentration over time (minutes). 

