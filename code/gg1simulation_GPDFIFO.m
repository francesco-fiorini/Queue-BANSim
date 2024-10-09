%% QueueBANSim
% GG1 queue simulation with FIFO policy
% Author: Francesco Fiorini
% Mail: francesco.fiorini@phd.unipi.it

function [mean_delay,mean_queue_size] = gg1simulation_GPDFIFO(muL_a,sigmaL_a,lambdaW_s,k_s,total_arrivals,use_factor)   
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

     enterservice_time(1).bArr=arrival_time(1);
     departure_time(1).bArr =enterservice_time(1)+ service_time(1); %the first departure time coincides with the first service time, because
     % the queue is assumed empty for the first user

     % Simulation process
     for i=2:total_arrivals
         if departure_time(i - 1) < arrival_time(i)  %this means that the queue server is already empty!
             enterservice_time(i).bArr = arrival_time(i); %it is immediately served
         else
             enterservice_time(i).bArr = departure_time(i - 1); %it will enter into the server when the previous user leaves the queue
         end
         departure_time(i).bArr = enterservice_time(i) + service_time(i); % update the departure time

     end

     delay = departure_time - arrival_time; %total delay
     sum = delay(1);
     for i = 2:total_arrivals
         sum = sum + delay(i);
     end
     mean_queue_size = sum/ departure_time(total_arrivals);
     mean_delay = mean(delay);

end
