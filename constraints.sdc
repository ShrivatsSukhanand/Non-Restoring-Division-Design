# 2ns target
create_clock -name clk -period 2 -waveform {0 1} [get_ports clk]

set_clock_transition -rise 0.015 [get_clocks clk]
set_clock_transition -fall 0.015 [get_clocks clk]

set_clock_uncertainty -setup 0.05 [get_clocks clk]
set_clock_uncertainty -hold 0.02 [get_clocks clk]

set_input_transition 0.2 [remove_from_collection [all_inputs] [get_ports clk]]

#delay for all inputs except clk
set_input_delay -max 0.1 -clock clk \
    [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay -min 0.05 -clock clk \
    [remove_from_collection [all_inputs] [get_ports clk]]

set_output_delay -max 0.1 -clock clk [all_outputs]
set_output_delay -min 0.05 -clock clk [all_outputs]

set_load 0.2 [all_outputs]

# drive strength of input ports
set_driving_cell -lib_cell INVX1 \
    [remove_from_collection [all_inputs] [get_ports clk]]

# the max transition on all nets
set_max_transition 0.2 [current_design]

# max fanout
set_max_fanout 10 [current_design]








