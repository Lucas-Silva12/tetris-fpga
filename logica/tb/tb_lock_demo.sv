`timescale 1ns/1ps
module tb_lock_demo;
    logic clk=0,reset=0;
    logic move_left=0,move_right=0,move_down=0,rotate=0;
    logic [2:0] piece_type=3'd1; // O
    logic [199:0] board_data;
    logic signed [5:0] piece_x,piece_y;
    logic [1:0] piece_rotation;
    logic [15:0] piece_shape;
    logic locked,lock_error;
    lock_demo dut (.*);
    always #5 clk=~clk;

    task automatic down_once;
        @(negedge clk); move_down=1;
        @(negedge clk); move_down=0;
    endtask

    initial begin
        $dumpfile("lock_demo.vcd");
        $dumpvars(0,tb_lock_demo);
        reset=1;
        #12; reset=0;
        // Peca O ocupa linhas y+0, y+1. Origem final y=18.
        repeat (18) down_once();
        if (piece_y !== 18 || locked)
            $fatal(1,"Peca deveria estar no fundo, ainda ativa");
        down_once(); // tenta atingir y=19: deve ser bloqueada e fixada
        if (!locked || lock_error)
            $fatal(1,"Descida bloqueada deveria fixar a peca");
        if (board_data !==
            ((200'b1 << 184) | (200'b1 << 185) |
             (200'b1 << 194) | (200'b1 << 195)))
            $fatal(1,"Tabuleiro nao recebeu os quatro blocos");
        // Depois de fixar, nao aceitar novos comandos.
        @(negedge clk); move_left=1;
        @(negedge clk); move_left=0;
        if (piece_x !== 3 || !locked)
            $fatal(1,"Peca fixada nao deveria mover");
        $display("PASS: tb_lock_demo");
        $finish;
    end
endmodule
