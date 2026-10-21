---
layout: home
title: FPGA VGA Driver Project
tags: fpga vga verilog
categories: demo
---

In this project I take a VGA driver written in Verilog, get it running on a Basys3 FPGA board, and then change it to draw my own image on a 640x480 monitor.

## **Template VGA Design**
### **Project Set-Up**
I made a new Vivado project for the Basys3 board, which uses the Artix-7 xc7a35tcpg236-1 chip. I added the template files (VGATop, VGASync, VGAColourCycle), the testbench and the Basys3 constraints file. At first I picked the wrong chip (xc7a15t), and the board refused the bitstream, so I changed the part and upgraded the clock IP to fix it.

<img src="https://raw.githubusercontent.com/d4nv/System-on-Chip-Design-Verification-FPGA-VGA-Driver/main/docs/assets/images/project_summary.png">

### **Template Code**
VGATop is the top module that connects everything together. It uses a Clocking Wizard (clk_wiz_0) to turn the board's 100 MHz clock into the 25 MHz pixel clock that 640x480 VGA needs. VGASync counts columns and rows, makes the hSync and vSync pulses, and sets vid_on high only when the counters are inside the visible 640x480 area. ColourCycle changes the red, green and blue values over time, and VGATop only sends them to the screen when vid_on is high.

A VGA monitor draws the screen one line at a time from left to right, then top to bottom. After each line there's a short gap and an hSync pulse, and after each full frame there's a vSync pulse, so the monitor knows when to start again. [add anything you noticed in the code]

### **Simulation**
I ran a behavioural simulation using the testbench. It sets the screen size very small (6x2) so it finishes quickly. In the waveform you can see hSync pulsing once per line, vSync once per frame, and vid_on only going high while the row and col counters are in the display area.

<img src="https://raw.githubusercontent.com/d4nv/System-on-Chip-Design-Verification-FPGA-VGA-Driver/main/docs/assets/images/simulation.png">

### **Synthesis**
Synthesis turns the Verilog into logic for the FPGA, and implementation places it on the chip and routes the connections. Bitstream generation failed at first because the VGA pins were commented out in the constraints file, and hSync/vSync had different capital letters to the Verilog. Once I uncommented the pins and matched the names, it generated with no errors. [add utilisation numbers if you want, e.g. LUTs used]

### **Demonstration**
Here's the template colour cycle running on the Basys3 board.

<img src="https://raw.githubusercontent.com/d4nv/System-on-Chip-Design-Verification-FPGA-VGA-Driver/main/docs/assets/images/demo.jpg">
