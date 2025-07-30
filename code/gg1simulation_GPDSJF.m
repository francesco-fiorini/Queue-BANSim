%% QueueBANSim
% GG1 queue simulation with SJF policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay, mean_queue_size] = gg1simulation_GPDSJF(muL_a, sigmaL_a, lambdaW_s, k_s, total_arrivals, use_factor)
    % GG1 queue simulation with non-preemptive SJF policy using BanArray
    

    % Initialize time arrays as BanArray
    arrival_time       = zeros(total_arrivals, 1, 'like', BanArray);   % arrival times
    enterservice_time  = zeros(total_arrivals, 1, 'like', BanArray);   % service start times
    departure_time     = zeros(total_arrivals, 1, 'like', BanArray);   % departure times

    % Generate service times and interarrival times
    service_time = randWeibullEuclidea(lambdaW_s, k_s, total_arrivals);           % service time for each job (BanArray)
    interarrival_support = randLogNormEuclidea(muL_a, sigmaL_a, total_arrivals) * Ban(1,1);

    % Build cumulative arrival times
    arrival_time(1).bArr = interarrival_support(1);
    for i = 2:total_arrivals
        arrival_time(i).bArr = arrival_time(i-1) + interarrival_support(i);
    end

    % Vector to track which jobs have been scheduled
    served = false(total_arrivals, 1);

    % First job: starts service immediately upon arrival
    enterservice_time(1).bArr = arrival_time(1);
    departure_time(1).bArr    = enterservice_time(1) + service_time(1);
    served(1)                  = true;

    % Main loop: schedule next arrivals using non-preemptive SJF
    for i = 2:total_arrivals
        % Time when server becomes free (end of previous job)
        t_free = departure_time(i-1);

        if t_free <= arrival_time(i)
            % Server is idle upon arrival: job i starts immediately
            enterservice_time(i).bArr = arrival_time(i);
        else
            % Server is busy: select shortest job from queue
            min_srv    = Ban(1, 10);   % large initial Ban value
            selected_j = 0;

            % Search among jobs that have arrived and not yet served
            for j = 1:(i-1)
                if arrival_time(j) <= t_free && ~served(j)
                    if service_time(j) < min_srv
                        min_srv    = service_time(j);
                        selected_j = j;
                    end
                end
            end

            if selected_j > 0
                % Schedule the selected job at t_free
                enterservice_time(selected_j).bArr = t_free;
                departure_time(selected_j).bArr    = t_free + service_time(selected_j);
                served(selected_j)                 = true;
            end

            % Schedule arrival job i to start at t_free
            enterservice_time(i).bArr = t_free;
        end

        % Compute departure time of job i and mark as served
        departure_time(i).bArr = enterservice_time(i) + service_time(i);
        served(i)              = true;
    end

    % Compute delays and performance metrics
    delay = departure_time - arrival_time;          % time in system for each job
    mean_queue_size = sum(double(delay)) / double(departure_time(total_arrivals));
    mean_delay      = mean(double(delay));
end
