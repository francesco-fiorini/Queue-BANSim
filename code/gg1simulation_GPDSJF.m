%% QueueBANSim
% GG1 queue simulation with SJF policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay,mean_queue_size] = gg1simulation_GPDSJF(muL_a,sigmaL_a,lambdaW_s,k_s,total_arrivals,use_factor)
    
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

    % First user enters service immediately and departs after service
    enterservice_time(1).bArr = arrival_time(1);
    departure_time(1).bArr = enterservice_time(1) + service_time(1);
    
    % Simulation process for SJF (non-preemptive)
    for i = 2:total_arrivals
        % Check if the system is free at the moment of arrival
        if departure_time(i - 1) <= arrival_time(i)
            enterservice_time(i).bArr = arrival_time(i);  % No waiting, enters immediately
        else
            % Shortest Job First: find the job with the smallest service time among those waiting
            min_service_time = Ban(1,10);  % Initialize with a large number
            selected_job = 0;
    
            % Search for the job with the shortest service time that has not started service
            for j = 1:i-1
                if arrival_time(j) <= departure_time(i - 1) &&  departure_time(i - 1)<departure_time(j)
                    if service_time(j) < min_service_time
                        min_service_time = service_time(j);
                        selected_job = j;
                    end
                end
            end
    
            % If a job is found with the smallest service time, update its service time
            if selected_job > 0
                enterservice_time(selected_job).bArr = departure_time(i - 1);
                departure_time(selected_job).bArr = enterservice_time(selected_job) + service_time(selected_job);
            end
    
            % The current job will enter the queue and start service
            enterservice_time(i).bArr = departure_time(i - 1);
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
