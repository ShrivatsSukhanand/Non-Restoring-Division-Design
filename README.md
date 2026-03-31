# Non-Restoring-Division-Design
QUICK DESCRIPTION:
tried creating this for 4 bit division on vivado after learning the algorithm...
I chose artix-7 xc7a35ticsg324-1L on vivado 2024.2 

It provided a good understanding to me regarding FSMs... i understand essence of FSMs better now...

CURRENT STATUS:
works for some values for now like 7/3 which provides me with 00010010... the first 4 bits (0001) from msb are remiander and the next 4 bits (0010) are quotient 
i have to yet test it for all 4 bit numbers
<img width="1632" height="919" alt="image" src="https://github.com/user-attachments/assets/60f887c5-4f4e-4396-8386-fb3df1c47daf" />
the above screenshot is of simulation for 7/3... the final FSM is STOP which is 110 and remains there forever... 
the clock period given was 20ns (clkFreq = 50MHz) which is arbitary here for testing the functionality

the warnings i am getting for attempting for synthesis is- [Synth 8-6859] multi-driven net on pin newstate[2] with 1st driver pin 'state[2]_i_1/O'
which is yet to be resolved...

FURTHER WORK:
1) to make it synthesisable for the FPGA selected (the FPGA selected was arbitary and just to confirm the synthesis)
2) to test it with UVM instead of typical testbench/forcing constant
