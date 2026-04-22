# Non-Restoring-Division-Design
This design performs 3 bit signed division using the established Non Restoring algorithm, yet to be completely tested for all test vectors
It is designed on vivado ML version 2025.2.1.
This project helped me enhance FSM understanding and honed debugging skills

The simulation results for 7/3 for all 4 combinations of signs have beem attached in the simulation folder

The output format is a byte, with MSN representing remainder and LSN representing quotient
for all 4 combinations of 7/3:
| +/+ | +/- | -/+ | -/- |
| -------- | -------- | -------- | -------- |
|0x12 | 0x1E | 0xFE | 0xF2 |


FURTHER WORK:
1. Refine FSM
2. resolving Linter warnings
3. UVM testing
