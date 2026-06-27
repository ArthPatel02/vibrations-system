% System parameters
m = 10;              % kg
k = 1000;            % N/m
x0 = 0.1;            % initial displacement (m)
v0 = 10;             % initial velocity (m/s)

omega_n = sqrt(k/m); % natural frequency (rad/s)
c_c = 2*m*omega_n;   % critical damping (Ns/m)

% Time vector
t = linspace(0, 2, 1000);   % 0 to 2 seconds

%% 1) Undamped case (c=0, zeta=0)
x_undamped = x0*cos(omega_n*t) + (v0/omega_n)*sin(omega_n*t);

%% 2) Underdamped case (c=100)
c = 50;
zeta = c/c_c;
omega_d = omega_n*sqrt(1 - zeta^2);
x_underdamped = exp(-zeta*omega_n*t).*( x0*cos(omega_d*t) + (v0+zeta*omega_n*x0)/omega_d * sin(omega_d*t) );

%% 3) Critically damped case (c = c_c)
c = c_c;
x_critical = ( x0 + (v0 + omega_n*x0)*t ) .* exp(-omega_n*t);

%% 4) Overdamped case (c=400)
c = 400;
zeta = c/c_c;
s1 = -omega_n*(zeta + sqrt(zeta^2 - 1));
s2 = -omega_n*(zeta - sqrt(zeta^2 - 1));
A = (v0 - s2*x0)/(s1 - s2);
B = (s1*x0 - v0)/(s1 - s2);
x_overdamped = A*exp(s1*t) + B*exp(s2*t);

%% Plot all responses together
figure;
plot(t, x_undamped, 'b-', 'LineWidth', 1.5); hold on;
plot(t, x_underdamped, 'r-', 'LineWidth', 1.5);
plot(t, x_critical, 'g-', 'LineWidth', 1.5);
plot(t, x_overdamped, 'm-', 'LineWidth', 1.8);
grid on;
xlabel('Time (s)'); ylabel('Displacement (m)');
title('Free Vibration Responses of SDOF System');
legend('Undamped (c=0)', 'Underdamped (c=100)', ...
       'Critical (c=200)', 'Overdamped (c=400)', ...
       'Location','best');