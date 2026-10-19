`timescale 1ns/1ps
module tb_movement;
    logic clk = 0;
    logic reset = 0;
    logic move_left = 0, move_right = 0, move_down = 0, rotate = 0;
    logic [2:0] piece_type = 3'd1; // O
    logic [199:0] board_data = '0;
    logic signed [5:0] piece_x, piece_y;
    logic [1:0] piece_rotation;
    logic [15:0] piece_shape;
    logic command_accepted, blocked_down;

    movement dut (.*);
    always #5 clk = ~clk;

    task automatic step(input logic l, r, d, rot);
        @(negedge clk);
        move_left = l; move_right = r; move_down = d; rotate = rot;
        @(negedge clk);
        move_left = 0; move_right = 0; move_down = 0; rotate = 0;
    endtask

    task automatic restart;
        @(negedge clk); reset = 1;
        @(negedge clk); reset = 0;
        #1;
    endtask

    initial begin
        $dumpfile("movement.vcd");
        $dumpvars(0, tb_movement);
        restart();
        if (piece_x !== 3 || piece_y !== 0 || piece_rotation !== 0)
            $fatal(1,"Reset incorreto");
        step(1,0,0,0);
        if (piece_x !== 2) $fatal(1,"Falha esquerda");
        step(0,1,0,0);
        if (piece_x !== 3) $fatal(1,"Falha direita");
        repeat (10) step(1,0,0,0);
        if (piece_x !== -1) $fatal(1,"Limite esquerdo: %0d",piece_x);
        repeat (20) step(0,1,0,0);
        if (piece_x !== 7) $fatal(1,"Limite direito: %0d",piece_x);
        repeat (25) step(0,0,1,0);
        if (piece_y !== 18) $fatal(1,"Limite inferior: %0d",piece_y);
        step(0,0,0,1);
        if (piece_shape !== 16'b0110_0110_0000_0000) $fatal(1,"Peca O mudou de forma");
        $display("PASS: tb_movement");
        $finish;
    end
endmodule
