%% QueueBANSim
% GG1 queue simulation with SRPT policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay, mean_queue_size] = gg1simulation_GPDSRPT(...
        muL_a, sigmaL_a, lambdaW_s, k_s, total_arrivals, use_factor)

    % --- 1) Preallocation and time generation ---
    arrival_time      = zeros(total_arrivals,1,'like',BanArray);
    enterservice_time = zeros(total_arrivals,1,'like',BanArray);
    departure_time    = zeros(total_arrivals,1,'like',BanArray);
    
    % service_time and remaining_time as BanArray
    service_time   = randWeibullEuclidea(lambdaW_s, k_s, total_arrivals);
    remaining_time = service_time;  

    % log-normal interarrival, cumulative
    dt_support      = randLogNormEuclidea(muL_a, sigmaL_a, total_arrivals) * Ban(1,1);
    arrival_time(1).bArr = dt_support(1);
    for i = 2:total_arrivals
        arrival_time(i).bArr = arrival_time(i-1) + dt_support(i);
    end

    % --- 2) Simulation variables ---
    current_time   = Ban(0);
    next_arrival   = 1;
    next_departure = Ban(1,10);     % “infinity” for initial service
    in_service     = false;
    current_job    = 0;
    served_count   = 0;
    waiting_queue  = [];           % indices of jobs in queue

    % --- 3) Event loop until all jobs are served ---
    while served_count < total_arrivals
        % 3.1) Next event times
        if next_arrival <= total_arrivals
            t_arr = arrival_time(next_arrival);
        else
            t_arr = Ban(1,10);
        end
        t_dep = next_departure;

        % 3.2) Choose event: arrival vs departure
        if t_arr < t_dep
            % --- Arrival of job next_arrival ---
            current_time = t_arr;
            j = next_arrival;
            waiting_queue(end+1) = j;
            next_arrival = next_arrival + 1;

            if ~in_service
                % if server is free, immediately pick the shortest job
                [sel, waiting_queue] = popShortest(waiting_queue, remaining_time);
                current_job    = sel;
                in_service     = true;
                enterservice_time(sel).bArr = current_time;
                next_departure = current_time + remaining_time(sel);
            else
                % if server is busy, check for preemption
                if remaining_time(j) < remaining_time(current_job)
                    % 1) pause current job
                    remaining_time(current_job).bArr = ...
                        remaining_time(current_job) - (current_time - enterservice_time(current_job));
                    waiting_queue(end+1) = current_job;
                    % 2) start job j
                    current_job = j;
                    enterservice_time(j).bArr = current_time;
                    next_departure = current_time + remaining_time(j);
                    % 3) remove j from waiting_queue
                    waiting_queue = waiting_queue(waiting_queue~=j);
                end
            end

        else
            % --- Departure of current_job ---
            current_time = t_dep;
            departure_time(current_job).bArr = current_time;
            served_count = served_count + 1;
            in_service   = false;

            % if queue is not empty, pick the shortest job
            if ~isempty(waiting_queue)
                [sel, waiting_queue] = popShortest(waiting_queue, remaining_time);
                current_job    = sel;
                in_service     = true;
                enterservice_time(sel).bArr = current_time;
                next_departure = current_time + remaining_time(sel);
            else
                next_departure = Ban(1,10);
            end
        end
    end

    % --- 4) Metrics computation ---
    % delay per job
    delay = departure_time - arrival_time;
    % sum of delays (in Ban)
    sum_delay = delay(1);
    for i = 2:total_arrivals
        sum_delay = sum_delay + delay(i);
    end
    mean_delay = sum_delay / total_arrivals;

    % Little’s law: average jobs in system = sum of delays / total time
    T_end = departure_time(total_arrivals);
    mean_queue_size = sum_delay / T_end;

    % % variance of waiting times Tw = enterservice_time – arrival_time
    % Tw = enterservice_time - arrival_time;
    % mean_Tw = mean(Tw);
    % Tw2_mean = mean((Tw - mean_Tw).^2) * total_arrivals/(total_arrivals-1);
end

% ------------------------------------------------------------
% Helper: extracts from queue the index with minimum remaining_time
function [sel, new_queue] = popShortest(queue, remaining_time)
    sel = queue(1);
    minRT = remaining_time(sel);
    for idx = queue(2:end)
        if remaining_time(idx) < minRT
            sel   = idx;
            minRT = remaining_time(idx);
        end
    end
    new_queue = queue(queue~=sel);
end
