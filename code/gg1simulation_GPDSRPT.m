%% QueueBANSim
% GG1 queue simulation with SJF policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay,mean_queue_size] = gg1simulation_GPDSRPT(muL_a,sigmaL_a,lambdaW_s,k_s,total_arrivals,use_factor)
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
    
    % Initialize service times and remaining processing times
    remaining_time = service_time;  % Initially, remaining time is equal to the service time
    
    % First job enters service immediately
    enterservice_time(1).bArr = arrival_time(1);
    departure_time(1).bArr = enterservice_time(1) + service_time(1);
    current_time = departure_time(1);  % Tracks the current time in the system
    
    % Simulation process for SRPT (preemptive SJF)
    for i = 2:total_arrivals
        % Manually find max between current_time and arrival_time(i)
        if current_time < arrival_time(i)
            current_time = arrival_time(i);  % Update current_time to the new arrival
        end

        % Check if the new job has a smaller service time than the remaining processing time
        if service_time(i) < remaining_time(i - 1) %preemption
            % Preempt the current job
            remaining_time(i - 1).bArr = remaining_time(i - 1) - (current_time - enterservice_time(i - 1)); % Update remaining time of the preempted job: subtract the time it has already spent in service from its original remaining time
            current_time = arrival_time(i);  % The new job starts immediately
            enterservice_time(i).bArr = current_time;
            departure_time(i).bArr = enterservice_time(i) + service_time(i);  % Update departure time of the new job
        else % no preemption
            % The new job waits in the queue
            % Manually find max between departure_time(i - 1) and arrival_time(i)
            if   arrival_time(i)<departure_time(i - 1)
                enterservice_time(i).bArr = departure_time(i - 1);  % No change, departure_time(i - 1) is larger
            else %server free
                enterservice_time(i).bArr = arrival_time(i);  % Update service entry time: it enters immediatly the server
            end
    
            departure_time(i).bArr = enterservice_time(i) + remaining_time(i);
        end
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
