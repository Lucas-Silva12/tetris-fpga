`timescale 1ns/1ps
module tb_piece_lock;
    logic [199:0] board_data;
    logic [15:0] piece_shape;
    logic signed [5:0] piece_x, piece_y;
    logic [199:0] board_after_lock;
    logic lock_valid;

    piece_lock dut (.*);

    initial begin
        $dumpfile("piece_lock.vcd");
        $dumpvars(0, tb_piece_lock);
        board_data='0;
        piece_shape=16'b0110_0110_0000_0000; // O
        piece_x=6'sd3; piece_y=6'sd18;
        #1;
        // O ocupa x=4,5 e y=18,19 -> indices 184,185,194,195.
        if (!lock_valid || board_after_lock !==
            ((200'b1 << 184) | (200'b1 << 185) |
             (200'b1 << 194) | (200'b1 << 195)))
            $fatal(1,"Fixacao nao marcou as quatro celulas corretas");

        // Nao escrever onde ja existe outro bloco.
        board_data[184]=1'b1;
        #1;
        if (lock_valid || board_after_lock !== board_data)
            $fatal(1,"Sobreposicao nao foi rejeitada");

        // Nao permitir escrita parcial fora dos limites.
        board_data='0;
        piece_x=6'sd8;
        #1;
        if (lock_valid || board_after_lock !== board_data)
            $fatal(1,"Saida do tabuleiro nao foi rejeitada");

        $display("PASS: tb_piece_lock");
        $finish;
    end
endmodule
