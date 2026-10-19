`timescale 1ns/1ps
module tb_lock_clear_demo;
    // Duas linhas inferiores faltando colunas 4 e 5.
    // Ao travar a peca O, as duas linhas ficam completas.
    localparam logic [199:0] INITIAL_BOARD =
        (200'h3cf << 180) | (200'h3cf << 190) | (200'b1 << 170);
    logic clk = 0;
    logic reset = 0;
    logic move_left = 0, move_right = 0, move_down = 0, rotate = 0;
    logic [2:0] piece_type = 3'd1; // O
    logic [199:0] board_data;
    logic signed [5:0] piece_x, piece_y;
    logic [1:0] piece_rotation;
    logic [15:0] piece_shape;
    logic locked, lock_error;
    logic [4:0] lines_cleared;

    lock_clear_demo #(.BOARD_RESET(INITIAL_BOARD)) dut (.*);
    always #5 clk = ~clk;

    task automatic down_once;
        @(negedge clk); move_down = 1'b1;
        @(negedge clk); move_down = 1'b0;
    endtask

    initial begin
        $dumpfile("lock_clear_demo.vcd");
        $dumpvars(0,tb_lock_clear_demo);
        reset = 1;
        #12; reset = 0;
        repeat (18) down_once();
        if (piece_y !== 18 || locked)
            $fatal(1, "Peca O deveria estar na origem y=18");
        down_once();
        if (!locked || lock_error)
            $fatal(1, "A descida bloqueada deveria fixar a peca");
        if (lines_cleared !== 5'd2)
            $fatal(1, "Deveriam ser removidas duas linhas, houve %0d", lines_cleared);
        // A unica celula sobrevivente estava em (0,17) e desce para (0,19).
        if (board_data !== (200'b1 << 190))
            $fatal(1, "Tabuleiro incorreto apos remover duas linhas");
        down_once();
        if (!locked || lines_cleared !== 5'd2 || board_data !== (200'b1 << 190))
            $fatal(1, "Tabuleiro nao deveria mudar apos fixacao");
        $display("PASS: tb_lock_clear_demo");
        $finish;
    end
endmodule
