clc; clear; close all;

% Given data
m = 10;          % kg
k = 1000;        % N/m
F0 = 50;         % N
x0 = 0.1;        % m
v0 = 10;         % m/s
wn = sqrt(k/m);  % Natural frequency (rad/s)

% Excitation frequencies
omega_list = [5 15];

for i = 1:length(omega_list)
    omega = omega_list(i);

    % Frequency ratio
    beta = omega / wn;

    % Steady-state amplitude (undamped)
    X = (F0/k) / (1 - beta^2);

    % Phase angle
    if omega < wn
        phi = 0;
    else
        phi = pi;
    end

    % Magnification factor
    Rd = 1 / abs(1 - beta^2);

    % Time vector
    t = linspace(0, 5, 1000);

    % Homogeneous solution coefficients from initial conditions
    A = x0 - X * sin(-phi);
    B = (v0 - X * omega * cos(-phi)) / wn;

    % Total and steady-state responses
    x_total = A * cos(wn * t) + B * sin(wn * t) + X * sin(omega * t - phi);
    x_steady = X * sin(omega * t - phi);

    % Display results
    fprintf('\nFor ω = %.1f rad/s:\n', omega);
    fprintf('  β  = %.3f\n', beta);
    fprintf('  X  = %.4f m\n', abs(X));
    fprintf('  Rd = %.3f\n', Rd);
    fprintf('  φ  = %.3f rad\n', phi);

    % Plotting
    figure;
    plot(t, x_total, 'b', 'LineWidth', 1.2); hold on;
    plot(t, x_steady, 'r--', 'LineWidth', 1.2);
    grid on;
    xlabel('Time (s)');
    ylabel('Displacement (m)');
    title(sprintf('Response for ω = %.1f rad/s', omega));
    legend('Total response', 'Steady-state response');

end


% Given data
m = 10;          % kg
k = 1000;        % N/m
c = 80;          % N·s/m (damping coefficient)
F0 = 50;         % N
x0 = 0.1;        % m
v0 = 10;         % m/s
wn = sqrt(k/m);  % Natural frequency (rad/s)

% Damping parameters
zeta = c / (2 * sqrt(k * m));      % Damping ratio
wd = wn * sqrt(1 - zeta^2);        % Damped natural frequency

% Excitation frequencies
omega_list = [5 15];

for i = 1:length(omega_list)
    omega = omega_list(i);
    
    % Frequency ratio
    beta = omega / wn;
    
    % Steady-state amplitude (damped)
    X = (F0/k) / sqrt((1 - beta^2)^2 + (2*zeta*beta)^2);
    
    % Phase angle
    phi = atan2(2*zeta*beta, 1 - beta^2);
    
    % Magnification factor
    Rd = 1 / sqrt((1 - beta^2)^2 + (2*zeta*beta)^2);
    
    % Time vector
    t = linspace(0, 5, 1000);
    
    % Homogeneous solution coefficients from initial conditions
    A = x0 - X * sin(-phi);
    B = (v0 + zeta*wn*A - X*omega*cos(-phi)) / wd;
    
    % Total and steady-state responses
    x_transient = exp(-zeta*wn*t) .* (A * cos(wd*t) + B * sin(wd*t));
    x_steady = X * sin(omega * t - phi);
    x_total = x_transient + x_steady;
    
    % Display results
    fprintf('\nFor ω = %.1f rad/s:\n', omega);
    fprintf('  β  = %.4f\n', beta);
    fprintf('  X  = %.6f m\n', X);
    fprintf('  Rd = %.4f\n', Rd);
    fprintf('  φ  = %.4f rad (%.2f°)\n', phi, rad2deg(phi));
    
    % Plotting
    figure;
    plot(t, x_total, 'b', 'LineWidth', 1.2); hold on;
    plot(t, x_steady, 'r--', 'LineWidth', 1.2);
    grid on;
    xlabel('Time (s)');
    ylabel('Displacement (m)');
    title(sprintf('Response for ω = %.1f rad/s (ζ = %.3f)', omega, zeta));
    legend('Total response', 'Steady-state response');
end