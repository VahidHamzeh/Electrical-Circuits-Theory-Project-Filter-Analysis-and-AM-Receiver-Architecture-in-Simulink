import numpy as np
import matplotlib.pyplot as plt

omega_0 = 10 
epsilons = [0.05, 0.1, 0.2]

omega = np.linspace(-2 * omega_0, 2 * omega_0, 400)
s = 1j * omega  # s = jω

plt.figure(figsize=(8, 5))

for epsilon in epsilons:
    H_s = 1 / np.sqrt(1 + (epsilon * (2 * (s / (1j * omega_0))**2 - 1))**2)
    plt.plot(omega, np.abs(H_s), label=f'ε = {epsilon}')

plt.xlabel('frequency (ω)')
plt.ylabel('|H(jω)|')
plt.title(' Transfer function H(s)')
plt.legend()
plt.grid()
plt.show()