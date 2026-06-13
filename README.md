# Electrical Circuit Theory Final Project - Fall 1403
**Sharif University of Technology | Department of Electrical Engineering**

This repository contains the complete documentation, MATLAB scripts, and Simulink models for the final project of the **Electrical Circuit Theory** course, supervised by **Dr. R. Amiri**. The project encompasses a deep theoretical analysis of second-order analog filters and an end-to-end physical implementation of an Amplitude Modulation (AM) receiver system using the Simulink Simscape Electrical environment.

## Student Information
* **Name:** Vahid Hamzeh 
* **Student ID:** 402101577

---

## Project Structure
The project is divided into five core analytical and practical sections:

1. **Analysis of Low-Pass Filters (LPF):** Derivation of general second-order transfer functions, evaluation of steady-state gain, cutoff frequency calculations, and a comparative study of Sallen-Key topologies achieving Butterworth (maximally flat) and Chebyshev (steep roll-off with passband ripples) responses. Includes component sensitivity analysis ($\pm10\%$ component deviation) and step-response characterization across varying quality factors ($Q$).
2. **Analysis of High-Pass Filters (HPF):** Theoretical comparison of 1st/2nd order, Sallen-Key, Butterworth, Chebyshev, Elliptic (Cauer), and Bessel high-pass configurations. Design of a 100 Hz active 2nd-order Butterworth HPF and a 1 kHz high-pass filter, validated through frequency response and phase-shift simulations (10 Hz to 10 kHz).
3. **Analysis of Band-Pass Filters (BPF):** Structural classification and mathematical derivation (gain, $Q$-factor, and -3 dB cutoff frequencies) of active RLC, Rauch, Tow-Thomas Biquad, and cascaded passive RC-RC topologies. Features a practical filter design task meeting strict attenuation criteria (-26 dB at 10 Hz and -16 dB at 100 kHz) and an EEG signal processing application for brainwave band separation (Delta, Theta, Alpha, Beta, Gamma).
4. **Analysis of Band-Stop / Notch Filters:** Working principles of notch filters implemented by combining complementary low-pass and high-pass blocks. Study of configuration topologies including basic Twin-T, single op-amp active Twin-T, and narrow-band stop circuits optimized for biomedical artifact rejection and 50/60 Hz powerline noise suppression.
5. **System-Level AM Modulator and Demodulator Realization:** Implementation of physical, circuit-based filtering blocks inside Simulink to process and decode a noisy dual-channel multiplexed audio stream.

---

## Final Section: Simulink AM Receiver Architecture

In the final task, a multiplexed, upsampled, and corrupted AM signal (`y_sum`) is imported into the Simulink workspace. The receiver utilizes a fully physical **Simscape Electrical** topology to isolate the baseband channels and reconstruct the original audio message. 

### Circuit Layout and Processing Stages
The architecture is structured sequentially into four operational stages:
1. **Interference Rejection (Active Notch Filter):** A series RLC resonant branch is configured in parallel with the main signal node, tuned precisely to the interference frequency ($f = 440\text{ Hz}$) with a high quality factor ($Q = 100$). This stage completely shorts the high-amplitude pure cosine distortion to the electrical reference (ground).
2. **Signal Demultiplexing (Parallel Filtering):** The clean signal is routed into two separate Simscape sub-circuits via controlled voltage sources to eliminate cross-stage impedance loading:
   * **Baseband Pathway:** An RC low-pass filter extracts the raw low-frequency message (`y_lowpass`).
   * **Passband Pathway:** An RLC series band-pass filter isolates the modulated carrier spectrum centered around 11 kHz (`y_bandpass`).
3. **Coherent Demodulation (Carrier Recovery):** The extracted band-pass signal is converted back to a Simulink time-series and fed into a mathematical multiplier block. It is multiplied by a synchronized local carrier oscillator (`Sine Wave` set to an angular frequency of $2\pi \times 11000\text{ rad/s}$). A scaling factor of $4$ (`Gain` block) is applied to compensate for the demodulation attenuation and fully restore the original signal amplitude.
4. **Final Smoothing (Output LPF):** The post-multiplier signal passes through a final RC low-pass filter to reject high-frequency imaging products generated during multiplication, yielding the fully recovered audio signal (`y_output`).

### Simulink Model Schematic
*Below is the complete physical circuit topology mapped inside the Simulink sandbox:*

![Simulink Circuit Diagram](assets/SimulinkSimulaton.png)


---

## How to Execute the Project

### Prerequisites
* MATLAB R2024b or newer
* Simulink
* Simscape Electrical Toolbox

### Run Steps
1. Open and execute the primary MATLAB script `TEC_Proj.m`.
2. The script pre-calculates the normalized filter structures, generates the upsampled modulated audio matrix, and packs `y_sum` into a proper time-series object named `tosim`.
3. The script programmatically triggers the Simulink model simulation (`sim`). Simscape solves the physical network dynamics in real-time.
4. Upon completion, the script extracts the circuit state variables from the `out` object, automatically applies peak amplitude normalization to prevent clipping, and exports the final high-fidelity results as audio tracks.

### Generated Deliverables
* `output_signalsum.wav`: The raw, multiplexed input audio containing the 11 kHz AM carrier and the 440 Hz noise.
* `output_signal1_simulink.wav`: The fully recovered, clear audio signal reconstructed by the physical Simscape receiver.
* `output_signal2_simulink.wav`: The filtered baseband signal separated by the primary low-pass stage.

---
## Software Environment
* **Simulation Engine:** Simulink Variable-Step Solver (Continuous)
* **Physical Modeling Library:** Simscape Foundation Library / Electrical / Elements
