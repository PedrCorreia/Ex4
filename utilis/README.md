# Utilities - Blood Velocity Estimation Functions

This folder contains reusable MATLAB functions for blood velocity estimation from ultrasound signals.

## Functions

### 1. `simulate_ultrasound_data.m`
**Generate realistic ultrasound RF data with motion**

```matlab
[rf_data, params] = simulate_ultrasound_data(vz, Ntrials, 'param', value, ...)
```

**Inputs:**
- `vz` - Blood velocity (m/s)
- `Ntrials` - Number of lines to generate

**Optional Parameters:**
- `'f0'` - Center frequency (default: 3.0 MHz)
- `'M'` - Periods in pulse (default: 4)
- `'fs'` - Sampling frequency (default: 96 MHz)
- `'c'` - Speed of sound (default: 1540 m/s)
- `'fprf'` - PRF (default: 5 kHz)
- `'lg'` - Range gate length (default: 1 mm)
- `'Nc'` - Lines for estimate (default: 8)
- `'add_noise'` - Add noise flag (default: false)

**Outputs:**
- `rf_data` - Simulated RF data (n_samples × Ntrials)
- `params` - Structure with all parameters

**Method:**
1. Generate Gaussian random scatterers
2. Convolve with transducer pulse
3. Apply velocity-based time shift

**Used in:** Q7 (diagnostic validation)

---

### 2. `estimate_blood_velocity.m`
**Basic velocity estimation from two signals**

```matlab
velocity = estimate_blood_velocity(signal1, signal2, T_prf, c, fs)
```

**Inputs:**
- `signal1` - First ultrasound signal
- `signal2` - Second ultrasound signal  
- `T_prf` - Pulse repetition period (seconds)
- `c` - Speed of sound (m/s)
- `fs` - Sampling frequency (Hz)

**Output:**
- `velocity` - Blood velocity (m/s)

**Used in:** Q7 (diagnostic), Q8 (via averaged function)

---

### 3. `estimate_velocity_averaged.m`
**Averaged cross-correlation over multiple lines**

```matlab
velocity = estimate_velocity_averaged(data, T_prf, c, fs)
```

**Inputs:**
- `data` - Matrix of ultrasound data (n_samples × n_lines)
- `T_prf` - Pulse repetition period (seconds)
- `c` - Speed of sound (m/s)
- `fs` - Sampling frequency (Hz)

**Output:**
- `velocity` - Averaged blood velocity (m/s)

**Method:**
- Cross-correlates consecutive line pairs (1-2, 2-3, etc.)
- Averages all cross-correlation functions
- Finds maximum from combined correlation
- More robust to noise than single pair estimation

**Used in:** Q8

---

### 4. `estimate_velocity_segmented.m`
**Segmented velocity estimation for depth profiling**

```matlab
[velocities, segment_centers, depths] = estimate_velocity_segmented(data, T_prf, c, fs, segment_duration)
```

**Inputs:**
- `data` - Matrix of ultrasound data (n_samples × n_lines)
- `T_prf` - Pulse repetition period (seconds)
- `c` - Speed of sound (m/s)
- `fs` - Sampling frequency (Hz)
- `segment_duration` - Duration of each segment (seconds)

**Outputs:**
- `velocities` - Array of velocities for each segment (m/s)
- `segment_centers` - Time positions of segment centers (seconds)
- `depths` - Depth positions of segment centers (meters)

**Method:**
- Divides RF data into temporal segments
- Applies averaged cross-correlation to each segment
- Calculates depth: d = t × c / 2

**Used in:** Q9, Q10

---

## Simulation Parameters (Medical Ultrasound Standard)

The `simulate_ultrasound_data` function uses realistic parameters:

| Parameter | Symbol | Default Value | Description |
|-----------|--------|---------------|-------------|
| Center frequency | f₀ | 3.0 MHz | Transducer frequency |
| Periods in pulse | M | 4 | Sine wave cycles |
| Sampling frequency | fs | 96 MHz | ADC sampling rate |
| Speed of sound | c | 1540 m/s | In human tissue |
| PRF | fprf | 5 kHz | Pulse repetition frequency |
| Range gate | lg | 1 mm | Measurement window |
| Lines per estimate | Nc | 8 | For averaging |
| SNR | snr | 2 | Signal-to-noise ratio |

---

## Theory

### Cross-Correlation Method
All functions use cross-correlation to find the time delay between signals:

1. Compute: `[correlation, lags] = xcorr(signal2, signal1)`
2. Find maximum: `[~, max_idx] = max(correlation)`
3. Get delay: `delay_samples = lags(max_idx)`
4. Convert to time: `t_s = delay_samples / fs`

### Velocity Calculation

$$v = \frac{t_s \cdot c}{2 T_{prf}}$$

Where:
- $t_s$ = time delay from cross-correlation
- $c$ = speed of sound (1540 m/s)
- $T_{prf}$ = pulse repetition period
- Factor of 2 accounts for round-trip ultrasound travel

### Depth Calculation

$$d = \frac{t \cdot c}{2}$$

Where:
- $d$ = depth from transducer
- $t$ = time position
- Factor of 2 for round-trip travel

---

## Usage

All assignment scripts automatically add this folder to the path:

```matlab
addpath('../../utilis');
```

Then functions can be called directly:

```matlab
% Q7: Test with two signals
velocity = estimate_blood_velocity(sig1, sig2, T_prf, c, fs);

% Q8: Averaged estimation
velocity = estimate_velocity_averaged(data, T_prf, c, fs);

% Q9 & Q10: Segmented estimation
[velocities, centers, depths] = estimate_velocity_segmented(data, T_prf, c, fs, seg_dur);
```

---

## Dependencies

- MATLAB Signal Processing Toolbox (for `xcorr` function)
- Standard MATLAB functions only

---

## File Organization

```
utilis/
├── simulate_ultrasound_data.m          # Realistic RF simulation
├── estimate_blood_velocity.m           # Q7 (basic function)
├── estimate_velocity_averaged.m        # Q8 (averaged)
├── estimate_velocity_segmented.m       # Q9, Q10 (segmented)
└── README.md                           # This file
```

Each assignment folder (Q7-Q10) contains only the main script (Q7.m, Q8.m, Q9.m, Q10.m) which calls these utility functions.
