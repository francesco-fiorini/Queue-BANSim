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
    
    % vettore di flag “non ancora servito”
    served = false(total_arrivals,1);


    served(1)            = true;

% --- 3) Loop sui successivi arrivi ---
    for i = 2:total_arrivals
    
        t_free = departure_time(i-1);  % quando il server si libera
    
        if t_free <= arrival_time(i)
            % server libero: il job i parte subito
            enterservice_time(i).bArr = arrival_time(i);
    
        else
            % server occupato: cerco in coda il job SJF
            min_srv    = Ban(1,10);  % “valore infinito” in Ban
            selected_j = 0;
    
            for j = 1:i-1
                % filtro solo i job già arrivati E non ancora serviti
                if arrival_time(j) <= t_free && ~served(j)
                    if service_time(j) < min_srv
                        min_srv    = service_time(j);
                        selected_j = j;
                    end
                end
            end
    
            if selected_j > 0
                % programma il job selezionato
                enterservice_time(selected_j).bArr = t_free;
                departure_time(selected_j).bArr    = t_free + service_time(selected_j);
                served(selected_j)           = true;
            end
    
            % poi programma il job i (parte appena il server si libera)
            enterservice_time(i).bArr = t_free;
        end
    
        % in ogni caso chiudo il job i
        departure_time(i).bArr = enterservice_time(i) + service_time(i);
        served(i)         = true;
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
