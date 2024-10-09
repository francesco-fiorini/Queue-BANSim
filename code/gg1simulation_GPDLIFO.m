%% QueueBANSim
% GG1 queue simulation with LIFO policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay,mean_queue_size] = gg1simulation_GPDLIFO(muL_a,sigmaL_a,lambdaW_s,k_s,total_arrivals,use_factor)
    arrival_time = zeros(total_arrivals,1,'like',BanArray); % the time when the customer arrives
    enterservice_time = zeros(total_arrivals,1,'like',BanArray); % the time when the customer is served
    departure_time = zeros(total_arrivals,1,'like',BanArray); % the time when the customer leaves the queue
    
    % Initialization of service times and arrival time
    
    service_time=randWeibullEuclidea(lambdaW_s,k_s,total_arrivals);
    
    arrival_time_support=randLogNormEuclidea(muL_a,sigmaL_a,total_arrivals)*Ban(1,1);
    
    a1=arrival_time_support(1);
    arrival_time(1).bArr=a1;
    for i=2:total_arrivals
        atime=arrival_time_support(i);
        arrival_time(i).bArr= arrival_time(i - 1) + atime;
    end
    
    % Initialize
    enterservice_time(1).bArr = arrival_time(1);  % First user enters service immediately
    departure_time(1).bArr = enterservice_time(1) + service_time(1);  % First departure
    
    % Simulation process
    for i = 2:total_arrivals
        % Check if the system is free at the moment of arrival
        if departure_time(i - 1) <= arrival_time(i)
            % No jobs are in service, so the new job enters immediately
            enterservice_time(i).bArr = arrival_time(i);
        else
            % There are jobs in service, so LIFO applies
            enterservice_time(i).bArr = departure_time(i - 1);  % LIFO: last arrival enters after the previous job finishes
    
            % No need to update previous jobs, since the LIFO policy only changes the current job's service time
        end
        % Calculate the departure time for the current job
        departure_time(i).bArr = enterservice_time(i) + service_time(i);
    end
    
    % Calculate the total delay
    delay = departure_time - arrival_time;
    sum = delay(1);
    for i = 2:total_arrivals
        sum = sum + delay(i);
    end
    mean_queue_size = sum/ departure_time(total_arrivals);
    mean_delay = mean(delay);
    
end
