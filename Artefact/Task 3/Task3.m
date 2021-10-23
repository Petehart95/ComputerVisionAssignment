% CMP9135M - Computer Vision - Assessment Item 1 - 12421031 - Peter Hart

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Task 3: Object Tracking %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc; % Reset environment

currentDir = pwd; % Get the current directory
aDir = strcat(currentDir,'\dataset\a.csv'); % Save input file locations
bDir = strcat(currentDir,'\dataset\b.csv');
xDir = strcat(currentDir,'\dataset\x.csv');
yDir = strcat(currentDir,'\dataset\y.csv');

x = csvread(aDir);y = csvread(bDir); % Load noisy coordinates
xr = csvread(xDir);yr = csvread(yDir); % Load real coordinates

dt = 0.1; 
z = [x;y];
totalFrames = length(x);

[px py] = kalmanTracking(z);

e = (x - px) + (y - py);
mean_e = mean(abs(x - px) + abs(y - py));
std_e = std(abs(x - px) + abs(y - py)); %std(e) / sqrt(length(e)); 
rms = rms(e);%sqrt(mean_e).^2;

disp(strcat("Mean Error: ", num2str(mean_e)));
disp(strcat("Standard Error: ", num2str(std_e)));
disp(strcat("RMS Error: ", num2str(rms)));

% Plot the Trajectory
plot(xr,yr,'b-');
hold on;
plot(x,y,'r-');
plot(px,py,'g-');
legend('Real Trajectory','Noisy Trajectory','Estimated Trajectory');
hold off;


function [px py] = kalmanTracking(z)
    % Track a target with a Kalman filter
    % z: observation vector
    % Return the estimated state position coordinates (px,py)

    dt = 0.1; N = length(z); %  time interval; number of samples

    R = [0.3 0; % Observation noise
         0 0.3]; 
    H = [1 0 0 0; % Cartesian observation model
         0 0 1 0]; 
    F = [1 dt 0 0; % CV motion model
         0 1 0 0; 
         0 0 1 dt; 
         0 0 0 1]; 
    Q = [0.1 0 0 0; % Motion noise
         0 0.2 0 0; 
         0 0 0.1 0; 
         0 0 0 0.2]; 

    P = Q; % Initial state covariance
    x = [0 0 0 0]'; % Initial state 
    s = zeros(4,N); % Current state

    for i = 1 : N
        [xp Pp] = kalmanPredict(x, P, F, Q);
        [x P] = kalmanUpdate(xp, Pp, H, R, z(:,i));
        s(:,i) = x; % Save current state
    end
    px = s(1,:); 
    py = s(3,:); % Contain the velocities on x and y respectively
end

function [xp, Pp] = kalmanPredict(x, P, F, Q)
    % Prediction step of Kalman filter.
    % x: state vector
    % P: covariance matrix of x
    % F: matrix of motion model
    % Q: matrix of motion noise
    % Return predicted state vector xp and covariance Pp
    xp = F * x; % predict state
    Pp = F * P * F' + Q; % predict state covariance
end

function [xe Pe] = kalmanUpdate(x, P, H, R, z)
% Update step of Kalman filter.
    % x: state vector
    % P: covariance matrix of x
    % H: matrix of observation model
    % R: matrix of observation noise
    % z: observation vector
    % Return estimated state vector xe and covariance Pe
    S = H * P * H' + R; % innovation covariance
    K = P * H' * inv(S); % Kalman gain
    zp = H * x; % predicted observation
    xe = x + K * (z - zp); % estimated state
    Pe = P - K * S * K'; % estimated covariance
end

% end of script