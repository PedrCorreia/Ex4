# Assignment Solutions - Blood Velocity Estimation (Q7-Q10)

## 📁 Structure

Each question folder contains only one main script:
- `Q7/Q7.m` - Diagnostic and validation
- `Q8/Q8.m` - Plug flow averaged analysis
- `Q9/Q9.m` - Plug flow segmented analysis  
- `Q10/Q10.m` - Carotid artery analysis

**All reusable functions are in `../utilis/`**

## 🚀 Quick Start

```matlab
% Q7 - Validate estimation function
cd Q7
Q7

% Q8 - Averaged cross-correlation on plug flow
cd ../Q8
Q8

% Q9 - Segmented analysis on plug flow
cd ../Q9
Q9

% Q10 - Carotid artery velocity profile
cd ../Q10
Q10
```

## 📊 Overview

| Question | Data File | Method | Output |
|----------|-----------|--------|--------|
| Q7 | Simulated | Diagnostic tests | Validation plots |
| Q8 | plug_flow.mat (10 lines) | Averaged cross-correlation | Single velocity |
| Q9 | plug_flow.mat (10 lines) | Segmented (2 μs) | Velocity array |
| Q10 | carotis.mat (20 lines) | Segmented (2 μs) | Velocity profile |

## 🎯 Theory

**Velocity from delay:**
$$v = \frac{t_s \cdot c}{2 T_{prf}}$$

**Depth from time:**
$$d = \frac{t \cdot c}{2}$$

Where:
- $t_s$ = time delay (cross-correlation)
- $c$ = speed of sound (1540 m/s)
- $T_{prf}$ = pulse repetition period (200 μs)

## 📦 Functions (in ../utilis/)

1. **estimate_blood_velocity.m** - Basic two-signal estimation
2. **estimate_velocity_averaged.m** - Averaged over multiple lines
3. **estimate_velocity_segmented.m** - Depth-resolved profiling

See `../utilis/README.md` for detailed function documentation.

