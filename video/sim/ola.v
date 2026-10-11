`timescale 1ns/1ps
module ola;
  reg clk = 0;
  reg [3:0] cont = 0;

  always #10 clk = ~clk;
  always @(posedge clk) cont <= cont + 1;

  initial begin
    $dumpfile("ola.vcd");
    $dumpvars(0, ola);
    #400 $display("Ambiente OK, contador = %0d", cont);
    $finish;
  end
endmodule