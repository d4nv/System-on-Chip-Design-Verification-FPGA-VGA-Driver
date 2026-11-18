`timescale 1ns / 1ps

// File: VGAColourCycle.v
// Author: Michelle Lynch
// Copyright Michelle Lynch 2024
//
// Adapting Author: 
// Date:

module ColourCycle #(
    parameter COUNTER_WIDTH = 32, 
    parameter COUNT_FROM = 0,
    parameter COUNT_TO = 32'b1 << 26,
    parameter COUNT_RESET = 32'b1 << 27)
    (input clk, rst,
     output [3:0] red, green, blue);

parameter BLACK = 0, RED = 1, YELLOW = 2, GREEN = 3, CYAN = 4, BLUE = 5, MAGENTA = 6, WHITE = 7; 
reg[2:0] state, state_next;
reg [11:0] colour;
reg [COUNTER_WIDTH:0] count;
reg [3:0] red_reg, green_reg, blue_reg;

// Next state & output logic state  machine 
always @* begin
    colour <= 12'b000000000000;
    state_next = state;
    case(state)
        BLACK: begin
            colour <= 12'b000000000000;
            if(count == COUNT_TO) begin
                state_next = RED;
            end
        end
        RED: begin
            colour <= 12'b000000001111;
            if(count == COUNT_TO) begin
                state_next = YELLOW;
            end
        end
        YELLOW: begin
            colour <= 12'b000011111111;
            if(count == COUNT_TO) begin
                state_next = GREEN;
            end
        end
        GREEN: begin
            colour <= 12'b000011110000;
            if(count == COUNT_TO) begin
                state_next = CYAN;
            end
        end
        CYAN: begin
            colour <= 12'b111111110000;
            if(count == COUNT_TO) begin
                state_next = BLUE;               
            end
        end
        BLUE: begin
            colour <= 12'b111100000000;
            if(count == COUNT_TO) begin
                state_next = MAGENTA;
            end
        end
        MAGENTA: begin
            colour <= 12'b111100001111;
            if(count == COUNT_TO) begin
                state_next = WHITE;            
            end
        end
        WHITE: begin
            colour <= 12'b111111111111;
            if(count == COUNT_TO) begin
                state_next = BLACK;
            end
        end
    endcase
end

// Register state
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1)
        state <= BLACK;
    else
        state <= state_next;
end

// Counter
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1)
        count <= COUNT_FROM;
    else
    begin
        if(count == COUNT_TO)
            count <= 0;
        else
            count <= count + 1;
    end
end

// Register RGB outputs    
always@(posedge clk, posedge rst) begin
    if(rst == 1'b1) begin
        red_reg   <= 4'b0;
        green_reg <= 4'b0;
        blue_reg  <= 4'b0;
    end
    else begin
        red_reg   <= colour[3:0];
        green_reg <= colour[7:4];
        blue_reg  <= colour[11:8];
    end
end

// Assign output wires
assign red = red_reg;
assign green = green_reg;
assign blue = blue_reg;

endmodule
