`timescale 1ns / 1ps

// File: VGASync.v
// Author: Michelle Lynch
// Copyright Michelle Lynch 2024

module VGASync
#(parameter HDISP = 640,
  parameter VDISP = 480,
  parameter HFP = 16,
  parameter VFP = 10,
  parameter HPW = 96,
  parameter VPW = 2,
  parameter HLIM = 800,
  parameter VLIM = 525)
  (input wire clk25, rst,
   output reg hsync, vsync, vid_on,
   output wire [10:0] row, col);

reg [10:0] hcount = 0;
reg [10:0] vcount = 0;

always@(posedge clk25) begin
    if(hcount < HLIM - 1)
        hcount <= hcount + 1;
    else
        begin
            hcount <= 0;
            if(vcount < VLIM - 1)
                vcount <= vcount + 1;
            else
                vcount <= 0;
        end
    
    if(hcount > (HDISP + HFP) && hcount <= (HDISP + HFP + HPW))
        hsync <= 0;
    else
        hsync <= 1;
                 
    if(vcount >= (VDISP + VFP) && vcount < (VDISP + VFP + VPW))
        vsync <= 0;
    else
        vsync <= 1;
    
    if (hcount < HDISP && vcount < VDISP)
        vid_on <= 1;
     else
        vid_on <= 0;        
end

assign row = vcount;
assign col = hcount;

endmodule
