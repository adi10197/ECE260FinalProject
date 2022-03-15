// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module fullchip (clk, mem_in, inst, reset, div, acc, fifo_ext_rd, sum_out);

parameter col = 8;
parameter bw = 8;
parameter bw_psum = 2*bw+4;
parameter pr = 16;

input  clk; 
input  [pr*bw-1:0] mem_in; 
input  [16:0] inst; 
input  reset;
input  div;
input  acc;
input  fifo_ext_rd;

output [bw_psum+3 : 0] sum_out;


core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in), 
      .inst(inst),
      .div(div),
      .acc(acc),
      .fifo_ext_rd(fifo_ext_rd),
      .sum_out(sum_out)
);

endmodule
