`timescale 1ns/1ps
module tb_rotation;
    logic clk = 0, reset = 0;
    logic move_left = 0, move_right = 0, move_down = 0, rotate = 0;
    logic [2:0] piece_type = 3'd2; // T
    logic [199:0] board_data = '0;
    logic signed [5:0] piece_x, piece_y;
    logic [1:0] piece_rotation;
    logic [15:0] piece_shape;
    logic command_accepted, blocked_down;
    movement dut (.*);
    always #5 clk = ~clk;

    task automatic step(input logic l, r, d, rot);
        @(negedge clk);
        move_left=l; move_right=r; move_down=d; rotate=rot;
        @(negedge clk);
        move_left=0; move_right=0; move_down=0; rotate=0;
    endtask
    task automatic restart;
        @(negedge clk); reset=1;
        @(negedge clk); reset=0;
        #1;
    endtask

    initial begin
        $dumpfile("rotation.vcd");
        $dumpvars(0, tb_rotation);
        restart();
        step(0,0,0,1);
        if (piece_rotation !== 1) $fatal(1,"Rotacao deveria ocorrer");
        step(0,0,0,1);
        if (piece_rotation !== 2) $fatal(1,"Segunda rotacao falhou");
        step(0,0,0,1);
        step(0,0,0,1);
        if (piece_rotation !== 0) $fatal(1,"Rotacao nao voltou ao inicio");

        // Na base, a T horizontal cabe (duas linhas), mas a vertical
        // ultrapassaria a ultima linha: rotacao deve ser rejeitada.
        repeat (18) step(0,0,1,0);
        if (piece_y !== 18) $fatal(1,"Peca nao atingiu base");
        step(0,0,0,1);
        if (piece_rotation !== 0) $fatal(1,"Rotacao na base deveria ser rejeitada");

        // Em espaco livre, bloco fixo impede rotacao.
        restart();
        board_data[2*10+5] = 1'b1; // Ocupado so na orientacao 1, nao na 0.
        step(0,0,0,1);
        if (piece_rotation !== 0) $fatal(1,"Rotacao deveria colidir com bloco fixo");
        board_data = '0;
        step(0,0,0,1);
        if (piece_rotation !== 1) $fatal(1,"Rotacao liberada deveria funcionar");

        $display("PASS: tb_rotation");
        $finish;
    end
endmodule
