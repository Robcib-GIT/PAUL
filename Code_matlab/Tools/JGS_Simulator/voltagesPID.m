%% Voltages state feedback
%
% Jorge F. García-Samartín
% www.gsamartin.es
% 2024-01-18

close all

% Nets
if ~exist('net_vp', 'var') || ~exist('net_pv', 'var')
   load('./Results/1segment-NN/DatasetNN/prueba_DEF_BUENA_13.mat');
   net_vp = feedforwardnet(50);
   net_vp = train(net_vp, vol(1:700,:)', pos(1:700,:)');
   net_pv = feedforwardnet(50);
   net_pv = train(net_pv, pos(1:700,:)', vol(1:700,:)');
end

% Point
p = 4;
X = [-1 92.12 8
     6.12 96.27 7.87
     -5 89.9 2.73
     -8 91 -6
     ];
x0 = X(p,:)';

% Setup
PAUL_setup();
%Ur = [9 8 10]';
Ur = net_pv(x0);
% Default state is [13 10 11]
u = net_tpv([0 0 0]');
u = u(4:6);
q = [0 0 0]';
qd = net_vt(Ur);
tol = 0.2;
maxIt = 50;
Qmax = 100;
toWatch = 3;

% PID
Kp = 1;
Ki = 0.1;
Kd = 0.01;
dt = 0.1;
int_err = 0;

% For plotting
U = zeros(3, maxIt+1);
Q = zeros(3, maxIt+1);
E = zeros(3, maxIt+1);
T = zeros(1, maxIt+1);
    
% Loop
t1 = datetime('now');
for i = 1:maxIt

    % Timing
    t2 = datetime('now');
    T(:,i) = seconds(t2 - t1);
    t1 = t2;

    % Storing
    U(:,i) = u;
    Q(:,i) = q;

    % Error
    err = Ur - u;
    E(:,i) = err;
    if (norm(err, inf) < tol)
        U(:,i+1:end) = u .* ones(size(U(:,i+1:end)));
        Q(:,i+1:end) = q .* ones(size(Q(:,i+1:end)));
        E(:,i+1:end) = err .* ones(size(E(:,i+1:end)));
        break
    end

    % Controller
    pos_err = err;
    int_err = int_err + err*dt;
    if i > 1
        der_err = (err - E(:,i-1)) / dt;
    else
        der_err = 0;
    end
    %q = net_vt(Kp*pos_err + Ki*int_err + Kd*der_err); % PID
    if i > 1
        q = (Ur - u) / (U(:,i) - U(:,i-1)) * (Q(:,i) - Q(:,i-1)); % Gain Scheduling
        %q = 5 * u / (U(:,i) - U(:,i-1)) * (Q(:,i) - Q(:,i-1)); % Feedback linearisation
        %q = Q(:,i) .* (Ur - u) ./ (Ur - 2*u + U(:,i-1));
    else
        q = net_vt(err);
    end

    % Saturator
    %q = max(q, dt*1000);
    %q = q .* (sum(Q,2) < Qmax);
    q = min(q, Qmax);
    q = max(q, -Qmax);
    
    % System
    u0 = net_tpv(sum(Q,2) + q);
    % Checking accuracy of linealised at each tep model
%     if i > 1
%         u1 = u + (U(:,i) - U(:,i-1)) ./ (Q(:,i) - Q(:,i-1)) .* q;
%         disp(u0(4:6)-u1)
%     end
    u = u0(4:6);

end

% Storing
U(:,i+1) = u;
Q(:,i+1) = q;
E(:,i+1) = err;

figure
plot(U(toWatch,:))
hold on
plot(Ur(toWatch)*ones(length(U(toWatch,:))), 'b--')
xlim([0 maxIt+1])

figure
plot(Q(toWatch,:))
xlim([0 maxIt+1])

figure
plot(vecnorm(E))
xlim([0 maxIt+1])

xF = net_vp(u);
disp(norm(x0 - xF))