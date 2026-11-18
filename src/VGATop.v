`timescale 1ns / 1ps

// File: VGATop.v
// Author: Michelle Lynch
// Copyright Michelle Lynch 2024

module VGATop (
    input wire clk, rst,
    output wire hSync, vSync,
    output wire [3:0] vgaRed, vgaGreen, vgaBlue);

wire clk25;
wire vid_on;
wire [3:0] red, green, blue;
wire [10:0] row, col;

clk_wiz_0 u_clock (
    .clk_out1(clk25), .reset(rst), .clk_in1(clk));

VGASync u_vga_sync (
    .clk25(clk25), .rst(rst), 
    .hsync(hSync), .vsync(vSync), .vid_on(vid_on),
    .row(row), .col(col));
    
ColourStripes  u_colour_stripes (
    .clk(clk25), .rst(rst), .row(row), .col(col), .red(red), .green(green), .blue(blue));
   
assign vgaRed = (vid_on) ? red : 4'b0;
assign vgaGreen = (vid_on) ? green : 4'b0;
assign vgaBlue = (vid_on) ? blue : 4'b0;
   
endmodule