create_clock -name clk -period 3.5 -waveform {0 1.75} [get_ports clk]

set_clock_transition -rise 0.01 [get_clocks clk]
set_clock_transition -fall 0.01 [get_clocks clk]

set_clock_uncertainty 0.01 [get_clocks clk]

# exclude clock from data input constraints
set_input_transition 0.2 [remove_from_collection [all_inputs] [get_ports clk]]

set_input_delay -max 0.1 -clock clk 
    [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay -min 0.05 -clock clk 
    [remove_from_collection [all_inputs] [get_ports clk]]

set_output_delay -max 0.1 -clock clk [all_outputs]
set_output_delay -min 0.05 -clock clk [all_outputs]

set_load 0.2 [all_outputs]
