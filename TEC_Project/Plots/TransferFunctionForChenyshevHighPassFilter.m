omega_0 = 10;
epsilons = [0.05, 0.1, 0.2];

omega = linspace(-2 * omega_0, 2 * omega_0, 400);
s = 1j * omega;  % s = jω

figure;
hold on;

for epsilon = epsilons
    H_s = 1 ./ sqrt(1 + (epsilon * (2 * (s / (1j * omega_0)).^2 - 1)).^2);
    plot(omega, abs(H_s), 'DisplayName', ['ε = ', num2str(epsilon)]);
end

xlabel('frequency (ω)');
ylabel('|H(jω)|');
title('Transfer function H(s)');
legend show;
grid on;
hold off;