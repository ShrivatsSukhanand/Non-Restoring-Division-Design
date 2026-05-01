module division2(
  input wire [16:0] dividend_inp,
  input wire [16:0] divisor_inp,
  input wire rst,
  input wire clk,
  output reg [33:0] accumulator_rem_dividend,
  output valid
);
  
  reg [16:0] divisor;
  reg [2:0] state;
  reg [2:0] newstate;
  reg [5:0] counter; 
  wire check;
  reg save;
  parameter INIT = 3'b000;
  parameter CHECK = 3'b001;
  parameter LOAD = 3'b010;
  parameter SHIFT = 3'b011;
  parameter CALC = 3'b100;
  parameter RECALC = 3'b101;
  parameter LAST =3'b110;
  parameter STOP =3'b111;
  assign check = (accumulator_rem_dividend[33])?0:1;
  assign valid = (state == STOP)?1:0;
  
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
        newstate = CHECK;
      
      CHECK: begin
        newstate = CALC;
      end
      
      SHIFT:
        newstate = CALC;
      
      CALC: begin
      if(counter == 16)
        newstate = LAST;
        else
        newstate = SHIFT;
        end
            
      LAST: 
        newstate = RECALC;
      
      RECALC: begin
        newstate = STOP;
      end
       
      STOP:
        newstate = STOP;

      default: newstate = INIT;
      
    endcase
  end
  
  //state logic
  always @(posedge clk) begin
    case(state)
      
      INIT: begin
    	divisor[16:0] <= 0;
        accumulator_rem_dividend[33:0] <= 0;
    	counter[5:0] <= 0;
        save <= 0;
      end
      
      LOAD: begin
        accumulator_rem_dividend[17:1] <= dividend_inp[16:0];
        divisor[16:0] <= divisor_inp[16:0];
      end
      
      CHECK: begin
        if(dividend_inp[16])
          accumulator_rem_dividend[17:1] <= 4'b0-accumulator_rem_dividend[17:1];
        if(divisor_inp[16])
          divisor[16:0] <= 4'b0-divisor[16:0];
      end
      
      SHIFT:begin
         save = accumulator_rem_dividend[33];
         if(check)
          accumulator_rem_dividend[33:0] <= {accumulator_rem_dividend[32:1],1'b1,1'b0};
          else
          accumulator_rem_dividend[33:0] <= {accumulator_rem_dividend[32:1],1'b0,1'b0};          
          end
          
      CALC: begin
          
         if(~save) begin
          accumulator_rem_dividend[33:17] <= accumulator_rem_dividend[33:17] - divisor[16:0];
          counter <= counter + 2'b01;
          end
         else begin
          accumulator_rem_dividend[33:17] <= accumulator_rem_dividend[33:17] + divisor[16:0];
          counter <= counter + 2'b01;
          end
      end  
          
      LAST: begin
          if(check) begin
          accumulator_rem_dividend[0] <= 1;
          end
          else begin
          accumulator_rem_dividend[33:17] <= accumulator_rem_dividend[33:17] + divisor[16:0];
          accumulator_rem_dividend[0] <= 0;
          end    
      end
      
      RECALC: begin
          case({dividend_inp[16],divisor_inp[16]})
          2'b00: ;
          2'b01: accumulator_rem_dividend[16:0] <= 4'b0-accumulator_rem_dividend[16:0]; //quotient gets negative
          2'b10: begin
          accumulator_rem_dividend[16:0] <= 4'b0-accumulator_rem_dividend[16:0];
          accumulator_rem_dividend[33:17] <= 4'b0-accumulator_rem_dividend[33:17]; //both q and r gets negative
          end
          2'b11: accumulator_rem_dividend[33:17] <= 4'b0-accumulator_rem_dividend[33:17]; //only r gets negative
          endcase
      end
      
//      STOP: newstate <= STOP;
      
//      default: newstate <= INIT;
      
    endcase
 end
endmodule
