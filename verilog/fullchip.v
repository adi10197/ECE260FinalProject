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

// out of the cores
wire [bw-1:0] sum_out_0, sum_out_1;

// out of the synchronizers
wire [bw-1:0] sum_out_sync_0, sum_out_sync_1;

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance_0 (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in_0), 
      .inst(inst),

      .sum_out(sum_out_0),
      .sum_in(sum_out_sync_1)
);

core #(.bw(bw), .bw_psum(bw_psum), .col(col), .pr(pr)) core_instance_1 (
      .reset(reset), 
      .clk(clk), 
      .mem_in(mem_in_1), 
      .inst(inst),
      
      .sum_out(sum_out_1),
      .sum_in(sum_out_sync_0)
);

// figure out rd/ wr signals
fifo_depth16 #(.bw(bw_psum+4)) sync_core_0 (
      .rd_clk(clk0), 
      .wr_clk(clk1), 
      .in(sum_out_0),
      .out(sum_out_sync_1), 
      .rd(div_q), 
      .wr(fifo_wr), 
      .reset(reset)
);

fifo_depth16 #(.bw(bw_psum+4)) sync_core_1 (
      .rd_clk(clk1), 
      .wr_clk(clk0), 
      .in(sum_out_1),
      .out(sum_out_sync_0), 
      .rd(div_q), 
      .wr(fifo_wr), 
      .reset(reset)
);

endmodule
