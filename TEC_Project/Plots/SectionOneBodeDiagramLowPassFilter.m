K = 1;
wn = 1;
Q_values = [0.5, 0.7071, 1, 2, 10];

w = logspace(-2, 2, 1000);

figure;
hold on;
for Q = Q_values
    num = [K * wn^2];
    den = [1, wn / Q, wn^2];
    sys = tf(num, den);
    
    [mag, phase, wout] = bode(sys, w);
    
    semilogx(wout, 20*log10(squeeze(mag)), 'DisplayName', ['Q = ', num2str(Q)]);
end
title('Bode Magnitude Plot');
xlabel('Frequency [rad/s]');
ylabel('Magnitude [dB]');
legend show;
grid on;
hold off;

figure;
hold on;
for Q = Q_values
    num = [K * wn^2];
    den = [1, wn / Q, wn^2];
    sys = tf(num, den);
    
    [mag, phase, wout] = bode(sys, w);
    
    semilogx(wout, squeeze(phase), 'DisplayName', ['Q = ', num2str(Q)]);
end
title('Bode Phase Plot');
xlabel('Frequency [rad/s]');
ylabel('Phase [degrees]');
legend show;
grid on;
hold off;