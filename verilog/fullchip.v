// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk0, clk1, mem_in_0, mem_in_1, inst, reset);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 16;

input  clk0;
input  clk1; 
input  [pr*bw-1:0] mem_in_0;
input  [pr*bw-1:0] mem_in_1;
input  [16:0] inst; 
input  reset;

reg sync0_0, sync0_1, sync0_2;
reg sync1_0, sync1_1, sync1_2;

wire canRead_0, canRead_1;

// out of the cores
wire [bw-1:0] sum_out_0, sum_out_1;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance_0 (
      .reset(reset), 
      .clk(clk0), 
      .mem_in(mem_in_0), 
      .inst(inst),

      // additional inputs
      .otherCoreClk(clk1)
      .sum_in(sum_out_1),
      .thisCoreCanRead(sync0_2),

      // additional outputs
      .sum_out(sum_out_0),
      .otherCoreCanRead(canRead_0)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance_1 (
      .reset(reset), 
      .clk(clk1), 
      .mem_in(mem_in_1), 
      .inst(inst),
      
      // additional inputs
      .otherCoreClk(clk0)
      .sum_in(sum_out_0),
      .thisCoreCanRead(sync1_2),

      // additional outputs
      .sum_out(sum_out_1),
      .otherCoreCanRead(canRead_1)
);

always @ (posedge clk0) begin
      sync0_0 <= canRead_1;
      sync0_1 <= sync0_0;
      sync0_2 <= sync0_1;
endmodule

always @ (posedge clk1) begin
      sync1_0 <= canRead_0;
      sync1_1 <= sync1_0;
      sync1_2 <= sync1_1;
endmodule
