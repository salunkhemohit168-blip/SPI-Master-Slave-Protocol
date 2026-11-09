`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 16:42:08
// Design Name: 
// Module Name: tb_spi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module tb_spi;

reg clk;
reg rst;
reg start;
reg [1:0] slave_select;
reg [7:0] data_in;

wire done;
wire [7:0] data_out;

// Instantiate Top Module
spi_top uut(

    .clk(clk),
    .rst(rst),
    .start(start),
    .slave_select(slave_select),
    .data_in(data_in),

    .done(done),
    .data_out(data_out)

);

// Clock Generation (100 MHz)
always #5 clk = ~clk;

initial
begin

    clk = 0;
    rst = 1;
    start = 0;
    slave_select = 2'b00;
    data_in = 8'h00;

    // Reset
    #20;
    rst = 0;

    //---------------------------------------------------
    // Transfer 1 : Slave 1
    //---------------------------------------------------

    #20;

    slave_select = 2'b00;
    data_in = 8'hA5;

    start = 1;
    #10;
    start = 0;

    wait(done);

    #20;

    $display("--------------------------------");
    $display("SLAVE 1");
    $display("Master Sent     = %h",data_in);
    $display("Master Received = %h",data_out);

    //---------------------------------------------------
    // Transfer 2 : Slave 2
    //---------------------------------------------------

    #40;

    slave_select = 2'b01;
    data_in = 8'h55;

    start = 1;
    #10;
    start = 0;

    wait(done);

    #20;

    $display("--------------------------------");
    $display("SLAVE 2");
    $display("Master Sent     = %h",data_in);
    $display("Master Received = %h",data_out);

    //---------------------------------------------------
    // Transfer 3 : Slave 3
    //---------------------------------------------------

    #40;

    slave_select = 2'b10;
    data_in = 8'hF0;

    start = 1;
    #10;
    start = 0;

    wait(done);

    #20;

    $display("--------------------------------");
    $display("SLAVE 3");
    $display("Master Sent     = %h",data_in);
    $display("Master Received = %h",data_out);

    #50;

    $display("--------------------------------");
    $display("Simulation Finished");
    $display("--------------------------------");

    $finish;

end

endmodule
