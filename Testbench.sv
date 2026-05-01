module tb();
  reg [16:0] dividend_inp;
  reg [16:0] divisor_inp;
  reg rst;
  reg clk;
  wire [33:0] accumulator_rem_dividend;
  
  division2 uut(
    .dividend_inp(dividend_inp),
    .divisor_inp(divisor_inp),
    .rst(rst),
    .clk(clk),
    .accumulator_rem_dividend(accumulator_rem_dividend)
  );
   always #5 clk = ~clk;
   
   always #5 begin
    if(uut.state == 3'b111)
    $finish;
 
    end
    
   initial begin
    clk = 0;
    rst = 1;

    #5; rst = 0;
     #10; dividend_inp = 17'd36875;
     divisor_inp = -17'd26724;
     #5;
     #100;

   end  
endmodule
