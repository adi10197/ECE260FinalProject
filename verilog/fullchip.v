// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk0, clk1, mem_in_0, mem_in_1, inst, div0, div1, acc0, acc1, reset, canRead_0, canRead_1, out);

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
input  div0, div1, acc0, acc1;
input  canRead_0, canRead_1;
output [2*bw_psum*col-1:0] out;
wire sync0, sync1;

wire   [bw_psum*col-1:0] sfp_out_0, sfp_out_1;

wire canReadSync_0, canReadSync_1;

// out of the cores
wire [(bw_psum+4)-1:0] sum_out_0, sum_out_1;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance_0 (
      .core_number(1'b0),
      .reset(reset), 
      .clk(clk0), 
      .mem_in(mem_in_0), 
      .inst(inst),
      .sum_out(sum_out_0),
      .out(sfp_out_0),
      // .out()
      .div(div0),
      .acc(acc0),

      // additional inputs
      .otherCoreClk(clk1),
      .sum_in(sum_out_1),
      .fifo_ext_rd(sync0),
      .canRead(canRead_0),

      // additional outputs
      .otherFifo_ext_rd(canReadSync_0)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance_1 (
      .core_number(1'b1),
      .reset(reset), 
      .clk(clk1), 
      .mem_in(mem_in_1), 
      .inst(inst),
      .sum_out(sum_out_1),
      .out(sfp_out_1),
      // .out()
      .div(div1),
      .acc(acc1),
      
      // additional inputs
      .otherCoreClk(clk0),
      .sum_in(sum_out_0),
      .fifo_ext_rd(sync1),
      .canRead(canRead_1),

      // additional outputs
      .otherFifo_ext_rd(canReadSync_1)
);

sync sync_0 (
      .clk(clk0),
      .in(canReadSync_1), 
      .out(sync0)
);

sync sync_1 (
      .clk(clk1),
      .in(canReadSync_0), 
      .out(sync1)
);

endmodule
