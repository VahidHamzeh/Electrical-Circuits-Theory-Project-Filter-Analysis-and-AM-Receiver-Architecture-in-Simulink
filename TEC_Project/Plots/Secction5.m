R = 1.5e3; 
C = 2.5e-6; 
R3 = 2.2e3; 
R4 = 2.8e3;

Q = 0.25 + 0.25 * (R4 / R3);
f0 = 1 / (4 * pi * R * C);
k = R4 / (R3 + R4);
fL = f0 * sqrt(1 + (1 / (4 * Q^2))) - (1 / (2 * Q));
fH = f0 * sqrt(1 + (1 / (4 * Q^2))) + (1 / (2 * Q));

numerator = [1 0 1 / (4 * R^2 * C^2)];
denominator = [1, (2 * R3) / (R * C * (R4 + R3)), 1 / (4 * R^2 * C^2)];

sys = tf(numerator, denominator);

w = logspace(0, 6, 1000); 
[H, w] = freqs(numerator, denominator, w);

figure;
set(gcf, 'Color', 'k');
subplot(2,1,1);
semilogx(w / (2 * pi), 20 * log10(abs(H)), 'Color', [0.2, 0.8, 0.6], 'LineWidth', 2); 
title('Magnitude Response (Band-Stop)', 'FontSize', 14, 'Color', 'w');
xlabel('Frequency (Hz)', 'FontSize', 12, 'Color', 'w');
ylabel('Magnitude (dB)', 'FontSize', 12, 'Color', 'w');
grid on;
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'GridColor', [0.5, 0.5, 0.5], 'Color', 'k', 'XColor', 'w', 'YColor', 'w');

subplot(2,1,2);
semilogx(w / (2 * pi), angle(H) * (180/pi), 'Color', [0.8, 0.2, 0.6], 'LineWidth', 2); 
title('Phase Response', 'FontSize', 14, 'Color', 'w');
xlabel('Frequency (Hz)', 'FontSize', 12, 'Color', 'w');
ylabel('Phase (Degrees)', 'FontSize', 12, 'Color', 'w');
grid on;
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'GridColor', [0.5, 0.5, 0.5], 'Color', 'k', 'XColor', 'w', 'YColor', 'w');

fs = 50 * f0;
t = 0:1/fs:0.1;
signal = sin(2 * pi * f0 * t) + cos(2* pi * f0 * t) + sin(10 * pi * f0 * t) + cos(8 * pi * f0 * t);
output = lsim(sys, signal, t);

figure;
set(gcf, 'Color', 'k');
plot(t, signal, 'Color', [0.2, 0.8, 0.6], 'LineWidth', 2); hold on;
plot(t, output, 'Color', [0.8, 0.2, 0.6], 'LineWidth', 2);
legend('Input Signal', 'Output Signal', 'FontSize', 12, 'TextColor', 'w');
title('Time-Domain Response', 'FontSize', 14, 'Color', 'w');
xlabel('Time (s)', 'FontSize', 12, 'Color', 'w');
ylabel('Amplitude', 'FontSize', 12, 'Color', 'w');
grid on;
set(gca, 'FontSize', 12, 'FontWeight', 'bold', 'GridColor', [0.5, 0.5, 0.5], 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
hold off;

R_vals = [1500 2000 2500];
C_vals = [2.5e-6 3.5e-6 4.5e-6];

results = []; 
f0_vals = []; 
Q_vals = []; 

for i = 1:length(R_vals)
    for j = 1:length(C_vals)
        r = R_vals(i);
        c = C_vals(j);

        f0 = 1 / (4 * pi * r * c);
        Q = 0.25 + 0.25 * (R4 / R3);
        fL = f0 * sqrt(1 + (1 / (4 * Q^2))) - (1 / (2 * Q));
        fH = f0 * sqrt(1 + (1 / (4 * Q^2))) + (1 / (2 * Q));

        results = [results; r, c, f0, Q, fL, fH];
        f0_vals = [f0_vals; f0]; 
        Q_vals = [Q_vals; Q]; 
    end
end

result_table = array2table(results, 'VariableNames', {'R', 'C', 'f0', 'Q', 'fL', 'fH'});
disp(result_table);

figure;
set(gcf, 'Color', 'k');
for i = 1:min(5, size(results, 1)) 
    r = results(i, 1);
    c = results(i, 2);
    
    f0 = 1 / (4 * pi * r * c);
    numerator = [1 0 1 / (4 * r^2 * c^2)];
    denominator = [1, (2 * R3) / (r * c * (R4 + R3)), 1 / (4 * r^2 * c^2)];
    
    sys_new = tf(numerator, denominator);
    
    output_new = lsim(sys_new, signal, t);
    
    subplot(5,1,i);
    plot(t, signal, 'Color', [0.2, 0.8, 0.6], 'LineWidth', 2); hold on;
    plot(t, output_new, 'Color', [0.8, 0.2, 0.6], 'LineWidth', 2);
    title(['Response for R = ', num2str(r), ' Ohm, C = ', num2str(c), ' F'], 'FontSize', 12, 'Color', 'w');
    xlabel('Time (s)', 'FontSize', 10, 'Color', 'w');
    ylabel('Amplitude', 'FontSize', 10, 'Color', 'w');
legend('Input Signal', 'Output Signal', 'FontSize', 10, 'TextColor', [0, 0, 0]);
    grid on;
    set(gca, 'FontSize', 10, 'FontWeight', 'bold', 'GridColor', [0.5, 0.5, 0.5], 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
end
hold off;

figure;
set(gcf, 'Color', 'k');
for i = 1:min(5, size(results, 1))
    r = results(i, 1);
    c = results(i, 2);
    
    f0 = 1 / (4 * pi * r * c);
    numerator = [1 0 1 / (4 * r^2 * c^2)];
    denominator = [1, (2 * R3) / (r * c * (R4 + R3)), 1 / (4 * r^2 * c^2)];
    
    sys_new = tf(numerator, denominator);
    
    w = logspace(0, 6, 1000); 
    [H, w] = freqs(numerator, denominator, w);
    
    subplot(5,2,2*i-1);
    semilogx(w / (2 * pi), 20 * log10(abs(H)), 'Color', [0.2, 0.8, 0.6], 'LineWidth', 2);
    title(['Magnitude Response for R = ', num2str(r), ' Ohm, C = ', num2str(c), ' F'], 'FontSize', 12, 'Color', 'w');
    xlabel('Frequency (Hz)', 'FontSize', 10, 'Color', 'w');
    ylabel('Magnitude (dB)', 'FontSize', 10, 'Color', 'w');
    grid on;
    set(gca, 'FontSize', 10, 'FontWeight', 'bold', 'GridColor', [0.5, 0.5, 0.5], 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
    
    subplot(5,2,2*i);
    semilogx(w / (2 * pi), angle(H) * (180/pi), 'Color', [0.8, 0.2, 0.6], 'LineWidth', 2);
    title(['Phase Response for R = ', num2str(r), ' Ohm, C = ', num2str(c), ' F'], 'FontSize', 12, 'Color', 'w');
    xlabel('Frequency (Hz)', 'FontSize', 10, 'Color', 'w');
    ylabel('Phase (Degrees)', 'FontSize', 10, 'Color', 'w');
    grid on;
    set(gca, 'FontSize', 10, 'FontWeight', 'bold', 'GridColor', [0.5, 0.5, 0.5], 'Color', 'k', 'XColor', 'w', 'YColor', 'w');
end