%% QueueBANSim
% GG1 queue simulation with SIRO policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay,mean_queue_size] = gg1simulation_GPDSIRO(muL_a,sigmaL_a,lambdaW_s,k_s,total_arrivals,use_factor)
   
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
    
    % Simulation process for SIRO
    for i = 2:total_arrivals
        % Check if the system is free at the moment of arrival
        if departure_time(i - 1) <= arrival_time(i)
            enterservice_time(i).bArr = arrival_time(i);  % No waiting, enters immediately
        else
            % For SIRO, randomly select a user in the queue
            count_in_queue = 0;
            selected_user = 0;
    
            for j = 1:i-1
                % Check if user j is still in the queue and hasn't departed yet
                if arrival_time(j) <= departure_time(i - 1) && departure_time(i - 1)<departure_time(j)
                    count_in_queue = count_in_queue + 1;
                    % Randomly select this user with a probability based on the number of users in the queue
                    if rand() < 1/count_in_queue
                        selected_user = j;
                    end
                end
            end
    
            if selected_user > 0
                % Update the selected user's enter service and departure times
                enterservice_time(selected_user).bArr = departure_time(i - 1);
                departure_time(selected_user).bArr = enterservice_time(selected_user) + service_time(selected_user);
            end
    
            % Set the service entry time for the current user (current arrival)
            enterservice_time(i).bArr = departure_time(i - 1);
        end
    
        % Calculate the departure time for the current user
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
