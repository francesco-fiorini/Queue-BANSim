%% QueueBANSim
% GG1 queue simulation with SJF policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay, mean_queue_size] = gg1simulation_GPDSJF(muL_a, sigmaL_a, lambdaW_s, k_s, total_arrivals, use_factor)

    % Initialize arrays with BanArray type
    arrival_time = zeros(total_arrivals, 1, 'like', BanArray);
    enterservice_time = zeros(total_arrivals, 1, 'like', BanArray);
    departure_time = zeros(total_arrivals, 1, 'like', BanArray);
    service_time = randWeibullEuclidea(lambdaW_s, k_s, total_arrivals);
    arrival_time_support = randLogNormEuclidea(muL_a, sigmaL_a, total_arrivals) * Ban(1,1);

    % Set first arrival time and generate cumulative arrival times
    arrival_time(1).bArr = arrival_time_support(1);
    for i = 2:total_arrivals
        arrival_time(i).bArr = arrival_time(i-1) + arrival_time_support(i);
    end

    % Simulation variables
    waiting_queue = [];          % Indices of waiting jobs
    current_time = Ban(0);       % Current simulation time
    server_busy = false;         % Server status
    next_departure = Ban(0);     % Time of next departure

    % Process arrivals
    for i = 1:total_arrivals
        % Check for departures before handling arrival
        while server_busy && next_departure < arrival_time(i)
            current_time = next_departure;
            server_busy = false;

            % Serve next job from waiting queue if not empty
            if ~isempty(waiting_queue)
                % Find shortest service time job
                min_service = service_time(waiting_queue(1));
                selected_job = waiting_queue(1);
                for k = 2:length(waiting_queue)
                    if service_time(waiting_queue(k)) < min_service
                        min_service = service_time(waiting_queue(k));
                        selected_job = waiting_queue(k);
                    end
                end

                % Remove job from queue and schedule it
                waiting_queue = waiting_queue(waiting_queue ~= selected_job);
                enterservice_time(selected_job).bArr = current_time;
                departure_time(selected_job).bArr = current_time + service_time(selected_job);
                next_departure = departure_time(selected_job);
                server_busy = true;
            end
        end

        % Handle new arrival
        if ~server_busy
            enterservice_time(i).bArr = arrival_time(i);
            departure_time(i).bArr = enterservice_time(i) + service_time(i);
            next_departure = departure_time(i);
            server_busy = true;
        else
            waiting_queue = [waiting_queue, i];
        end
    end

    % Process remaining jobs in queue
    while ~isempty(waiting_queue)
        if server_busy
            current_time = next_departure;
            server_busy = false;
        end

        % Find shortest service time job
        min_service = service_time(waiting_queue(1));
        selected_job = waiting_queue(1);
        for k = 2:length(waiting_queue)
            if service_time(waiting_queue(k)) < min_service
                min_service = service_time(waiting_queue(k));
                selected_job = waiting_queue(k);
            end
        end

        % Remove job from queue and schedule it
        waiting_queue = waiting_queue(waiting_queue ~= selected_job);
        enterservice_time(selected_job).bArr = current_time;
        departure_time(selected_job).bArr = current_time + service_time(selected_job);
        next_departure = departure_time(selected_job);
        server_busy = true;
    end

    % Calculate metrics
    delay = zeros(total_arrivals, 1, 'like', BanArray);
    for i = 1:total_arrivals
        delay(i).bArr = departure_time(i) - arrival_time(i);
    end

    % Sum delays
    sum_delay = delay(1);
    for i = 2:total_arrivals
        sum_delay = sum_delay + delay(i);
    end

    % Find last departure
    last_departure = departure_time(1);
    for i = 2:total_arrivals
        if last_departure < departure_time(i)
            last_departure = departure_time(i);
        end
    end

    % Compute results
    mean_queue_size = sum_delay / last_departure;
    mean_delay = sum_delay / total_arrivals;
end
