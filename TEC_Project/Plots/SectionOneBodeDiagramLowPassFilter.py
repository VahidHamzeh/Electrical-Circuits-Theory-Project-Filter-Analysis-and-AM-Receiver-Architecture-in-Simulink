import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

K = 1
wn = 1
Q_values = [0.5, 0.7071, 1, 2, 10]  

w = np.logspace(-2, 2, 1000)

for Q in Q_values:
    num = [K * wn**2]
    den = [1, wn / Q, wn**2]
    system = signal.TransferFunction(num, den)
    
    w, mag, phase = signal.bode(system, w)
    
    plt.semilogx(w, mag, label=f'Q = {Q}')
    
plt.title('Bode Magnitude Plot')
plt.xlabel('Frequency [rad/s]')
plt.ylabel('Magnitude [dB]')
plt.legend()
plt.grid()
plt.show()

for Q in Q_values:
    num = [K * wn**2]
    den = [1, wn / Q, wn**2]
    system = signal.TransferFunction(num, den)
    w, mag, phase = signal.bode(system, w)
    plt.semilogx(w, phase, label=f'Q = {Q}')
    
plt.title('Bode Phase Plot')
plt.xlabel('Frequency [rad/s]')
plt.ylabel('Phase [degrees]')
plt.legend()
plt.grid()
plt.show()