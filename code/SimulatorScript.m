%% Main SCRIPT of QueueBANSim Simulator
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

close all;
clear;
clc;

%% Service time distribution
    % Weibull
    lambdaW_s=Ban([2.13 -0.3 0.2],1);
    k_s=1/2;
    E_Ts=lambdaW_s*gamma(1+1/k_s);
    var_Ts=(lambdaW_s^2)*(gamma(1+2/k_s)-(gamma(1+1/k_s))^2);
    E_Ts2=var_Ts+E_Ts^2;
    mu=1/E_Ts;
    E_Ts3=(lambdaW_s^3)*(gamma(1+3/k_s));

%% Interarrival distribution
% LogNormal
    muL_a=Ban([1 1 2]);
    sigmaL_a=Ban([1 2 1]);
    E_Ta=exp(muL_a+sigmaL_a^2/2)*Ban(1,1);
    var_Ta=(exp(muL_a*2+sigmaL_a^2*2)-exp(muL_a*2+sigmaL_a^2))*Ban(1,2);
    E_Ta2=var_Ta+E_Ta^2;
    lambda=1/E_Ta;
    E_Ta3=exp(muL_a*3+(sigmaL_a^2)*9/2)*Ban(1,3);

rho = lambda / mu; % utilization coefficient


total_arrivals = 10000; % number of arrivals
num_simu = 5; % number of simulations
use_factor=40/100;
ED = zeros(num_simu,1,'like',BanArray); % average total delay E[T]=E[Tw]+E[Ts]

%I run the simulation num_sim times
for i=1:num_simu
    % Select the proper gg1simulation method, according to the
    % scheduling policy
    [ED(i).bArr,mean_queue_size] = gg1simulation_GPDLIFO(muL_a,sigmaL_a,lambdaW_s,k_s,total_arrivals,use_factor);
end

EQ=ED*lambda;

%Results
% mean delay from simulation
ED_mean=mean(ED);

% Theoretical mean delay bounds
boundsup1=(var_Ta+var_Ts)*lambda/(2*(Ban(1)-rho))+E_Ts; 
boundinf1=(rho*(rho-2)+var_Ts*(lambda^2))/(lambda*2*(Ban(1)-rho))+E_Ts; 
if boundinf1<Ban(0)
    boundinf1=Ban(0);
end
boundinf11=var_Ts/(E_Ta*(-rho+1)*2)-E_Ts/2+E_Ts; 
if boundinf11<Ban(0)
    boundinf11=Ban(0);
end
% Theoretical delay approximations
ca2=var_Ta/(E_Ta^2);
cb2=var_Ts/(E_Ts^2);

app1=rho*(ca2+cb2)/(2*mu*(Ban(1)-rho))+E_Ts; 
app2=(lambda*(Ban(1)+cb2)/(1/(rho^2)+cb2))*(var_Ts+var_Ta)/(2*(Ban(1)-rho))+E_Ts; 
appH1=mu*(var_Ta*rho^2+var_Ts/rho)/(2*(E_Ta-E_Ts)); 
appH2=rho*(ca2+(cb2/rho))/(2*mu*(Ban(1)-rho))+E_Ts; 
appH3=appH1/lambda; 
sho=-2*(Ban(1)-rho)/(rho*(ca2+cb2/rho));
esho=exp(sho);
appKobayashi=esho/(mu*(Ban(1)-esho))+E_Ts; 
kramerfact=rho*(ca2+cb2)/(2*mu*(Ban(1)-rho));
if ca2<Ban(1)
    appKramer=kramerfact*exp(-2*(Ban(1)-rho)*(Ban(1)-ca2)^2/(3*rho*(ca2+cb2)))+E_Ts;
else
    appKramer=kramerfact*exp(-(Ban(1)-rho)*(ca2-Ban(1))/(ca2+4*cb2))+E_Ts;
end

% Average number of customers in the queue from Little's law
EQ_mean=mean(EQ);
 

