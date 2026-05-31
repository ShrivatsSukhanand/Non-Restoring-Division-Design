# Non-Restoring-Division-Design
This design implements 17-bit signed integer division using the Non-Restoring algorithm, constrained such that the magnitude of the dividend is always greater than the divisor. Verified using a layered SystemVerilog testbench architecture on Aldec Riviera-PRO 2025.04 via (EDA Playground)[https://www.edaplayground.com/x/fiAu]

**Simulation**: Designed on Vivado 2025.2.1 and verified the simulations

**Synthesis** :  Synthesized using **Cadence Genus 21.14** | 45nm technology | 500 MHz target clock  

**Area**: The tool currently reports a total area of 0. This is suspected to be attributed to missing area definitions within the FOUNDRY files.

**Pre-synthesis Verification**: SystemVerilog layered testbench (transaction–monitor architecture), validated across 20 input vectors covering all signed/unsigned combinations.

**Manual Verification**

The output is a 36-bit value where the lower 17 bits represent the quotient and the next 17 bits represent the remainder. The remaining bits are padding for hexadecimal alignment.

The design was verified manually for all 4 sign combinations of 36875 and 26724 (quotient = 1, remainder = 10151):

| +/+ | +/- | -/+ | -/- |
|---|---|---|---|
| 0x04f4e0001 | 0x04f4fffff | 0x3b0b3ffff | 0x3b0b20001 |

All 4 combinations match the expected result governed by: `dividend = quotient × divisor + remainder`

The manual calculation is attached below:
<img width="860" height="1280" alt="WhatsApp Image 2026-05-01 at 17 07 35" src="https://github.com/user-attachments/assets/1ebf71ea-c72b-4530-b91d-9f7c84574f15" />

**Study: before vs after clock gating**
Clock Gating is a technique that blocks the clock signal to idle flip-flops, eliminating unnecessary switching activity and reduces the dynamic power.

The gating is enabled via `set_db lp_insert_clock_gating true`

## Overview

A comparative study of synthesis results before and after enabling automatic clock gating on a 34-bit non-restoring integer division unit. The reports cover power, area, and timing, please check the "Results from Genus" folder for detailed reports.

## Results Summary

### Power

| Category     | Before Gating | After Gating | Change       |
|--------------|---------------|--------------|--------------|
| Register     | 615.9 µW      | 426.4 µW     | **−30.8%**   |
| Logic        | 1817.8 µW     | 1916.5 µW    | +5.4%      |
| Clock        | 25.9 µW       | 82.5 µW      | +218% (ICG overhead) |
| **Total**    | **2459.6 µW** | **2425.4 µW**| **−1.4%**   |

- The Logic power increase is due to the 5 inserted ICG cells, as they are classified under logic, not register.
- The clock leakage and internal power consumption increase from 0, after gating.
- The register savings dominate, resulting in a net total power reduction.

### Area

| Metric      | Before Gating | After Gating | Change       |
|-------------|---------------|--------------|--------------|
| Cell Count  | 556           | 494          | **−11.2%**   |
| Cell Area   | N/A           | N/A          | (liberty file issue) |

- Cell count reduction is a side effect of Genus re-optimizing the netlist during ICG insertion — 5 ICG cells added, 67 cells eliminated through remapping.

### Timing

| Metric              | Before Gating          | After Gating            |
|---------------------|------------------------|-------------------------|
| Startpoint          | `reg[18]` (DFFX4)      | `reg[17]` (MDFFHQX4)    |
| CK→Q delay          | 151 ps                 | 133 ps                  |
| Data path           | 1548 ps                | 1604 ps (+56 ps)        |
| Setup constraint    | 50 ps                  | 25 ps (tighter)         |
| Required time       | 1900 ps                | 1925 ps                 |
| **Slack**           | **+352 ps**       | **+321 ps**      |

- Clock gating caused Genus to remap the launch FF to `MDFFHQX4` (ICG-compatible, faster CK→Q). However, netlist restructuring slightly elongated the combinational path. Timing closure maintained with positive slack throughout.
- **DFFX4**: Standard D-flip-flop with four times the baseline drive strength.
- **MDFFHQX4**: Multiplexed high-speed scan flip-flop with four times drive strength.

## Clock Gating Coverage

| Metric                        | Value        |
|-------------------------------|--------------|
| ICG cells inserted            | 5 (all RC)   |
| Flip-flops gated              | 58 / 60      |
| Gating coverage               | **96.67%**   |
| Average toggle saving         | **67.47%**   |
| Ungated FFs                   | 2            |

- The Ungated FF are due to ICG overhead > savings for tiny register groups, thus Genus ignores them.

## Key Takeaways

- **96.67% FF coverage** achieved with 5 RC ICG cells — near-complete gating.
- **Register power reduced by 30.8%** — The primary benefit of clock gating.
- **Logic power increased slightly** — ICG cells classified under logic; expected tradeoff.
- **Cell count dropped 11.2%** — Genus netlist optimization co-occurs with ICG insertion.
- **Timing closure is maintained** — tighter setup constraint (50→25 ps) still met with 321 ps slack.

## Tools & Flow

```
RTL (Verilog in Vivado for simulation (on PC)            →           Cadence Genus 21.14 (College lab)     →     Synthesis Reports
                     ↑                                                                ↑
Functional Verification on SystemVerilog Testbench Architecture       set_db lp_insert_clock_gating true 
```
