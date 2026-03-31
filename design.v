//non restroing division design
//fsm: INIT->LOAD->CALC->END
module division(
  input wire [3:0] dividend_inp,
  input wire [3:0] divisor_inp,
  input wire rst,
  input wire clk,
  output reg [7:0] accumulator_rem_dividend
);
  
  reg [3:0] divisor;
  reg [2:0] state;
  reg [2:0] newstate;
  reg [2:0] counter;
  wire check;
  parameter INIT = 3'b000;
  parameter LOAD = 3'b001;
  parameter SHIFT = 3'b010;
  parameter ADD = 3'b011;
  parameter SUB = 3'b100;
  parameter LAST =3'b101;
  parameter STOP =3'b110;
  
  always @(posedge clk or posedge rst) begin
    if(rst)
    state <= INIT;
  else begin
    state <= newstate;
  end
  end
  
  //state traversal
  always @(*) begin
    case(state)
      
      INIT: begin
        if(rst)
        newstate = INIT;
        else
        newstate = LOAD;
      end
      
      LOAD:
        newstate = SUB;
      
      SHIFT:
      if(check)
        newstate = ADD;
      else 
        newstate = SUB;
      
      ADD: begin
        if(counter == 3)
        newstate = LAST;
        else
        newstate = SHIFT;
       end
       
       SUB: begin
       if(counter == 3)
        newstate = LAST;
        else
        newstate = SHIFT;
       end
             
      LAST: 
        newstate = STOP;
        
      STOP:
        newstate = STOP;

      default: newstate = INIT;
      
    endcase
  end
 
  assign check = (accumulator_rem_dividend[7])?1:0;
  
  //state logic
  always @(posedge clk) begin
    case(state)
      
      INIT: begin
    	divisor <= 0;
        accumulator_rem_dividend[7:0] <= 0;
    	counter <= 0;
      end
      
      LOAD: begin
        accumulator_rem_dividend[4:1] = dividend_inp[3:0];
        divisor = divisor_inp;
      end
      
      SHIFT: begin
          if(check)
          accumulator_rem_dividend <= (accumulator_rem_dividend << 1);
          else
          accumulator_rem_dividend <= (accumulator_rem_dividend|8'b00000001) << 1;
          end
          
      ADD: begin
          accumulator_rem_dividend[7:4] <= accumulator_rem_dividend[7:4] + divisor[3:0];
          counter <= counter + 2'b01;
      end
       
      SUB: begin
          accumulator_rem_dividend[7:4] <= accumulator_rem_dividend[7:4] - divisor[3:0];
          counter <= counter + 2'b01;
      end    
          
      LAST: begin
          if(check)
          accumulator_rem_dividend[7:4] <= accumulator_rem_dividend[7:4] + divisor[3:0];
          else
          accumulator_rem_dividend <= accumulator_rem_dividend;
      end
      
      STOP: newstate <= STOP;
      
      default: newstate <= INIT;
      
    endcase
 end
endmodule
