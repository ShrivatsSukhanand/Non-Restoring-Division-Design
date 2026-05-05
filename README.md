# Non-Restoring-Division-Design
This design implements 17-bit signed integer division using the Non-Restoring algorithm, constrained such that the magnitude of the dividend is always greater than the divisor. Verified using a layered SystemVerilog testbench architecture on Aldec Riviera-PRO 2025.04 via (EDA Playground)[https://www.edaplayground.com/x/fiAu]

Please check the Report_Netlist folder to find the reports and netlist

**Simulation**: Designed on Vivado 2025.2.1 and verified the simulations

**Synthesis** : Successfully mapped RTL to the 45nm Library using Cadence Genus, resulting in 488 cell count and netlist was obtained

**Timing** : Achieved closure at a 3.5ns clock period (approx. 285MHz) with a healthy +1413ps setup slack.

**Power**: Total estimated power consumption is 1.32mW.

**Area**: While cell counts are 488, the tool currently reports a total area of 0. This is suspected to be attributed to missing area definitions within the lab-provided FOUNDRY .lib/.lef files. Currently investigating library characterization to enable physical dimension mapping.

Working through this project, strengthened FSM design understanding and sharpened hardware debugging skills. Debugging were assisted by Claude and Google AI.

**Verification**

The output is a 36-bit value where the lower 17 bits represent the quotient and the next 17 bits represent the remainder. The remaining bits are padding for hexadecimal alignment.

The design was verified manually for all 4 sign combinations of 36875 and 26724 (quotient = 1, remainder = 10151):

| +/+ | +/- | -/+ | -/- |
|---|---|---|---|
| 0x04f4e0001 | 0x04f4fffff | 0x3b0b3ffff | 0x3b0b20001 |

All 4 combinations match the expected result governed by: `dividend = quotient × divisor + remainder`

The manual calculation is attached below:
<img width="860" height="1280" alt="WhatsApp Image 2026-05-01 at 17 07 35" src="https://github.com/user-attachments/assets/1ebf71ea-c72b-4530-b91d-9f7c84574f15" />
