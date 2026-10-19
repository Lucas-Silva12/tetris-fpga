`timescale 1ns/1ps
module tb_line_clear;
    logic [199:0] board_in;
    logic [199:0] board_out;
    logic [4:0] lines_cleared;
    logic [199:0] expected;
    line_clear dut (.*);

    task automatic check(input logic [199:0] want_board,
                         input integer want_count,
                         input string label_name);
        #1;
        if (lines_cleared !== 5'(want_count) || board_out !== want_board)
            $fatal(1, "Falha %s: linhas=%0d, esperado=%0d", label_name,
                   lines_cleared, want_count);
        $display("OK: %s", label_name);
    endtask

    initial begin
        $dumpfile("line_clear.vcd");
        $dumpvars(0, tb_line_clear);

        board_in = '0;
        check(200'b0, 0, "vazio");

        board_in = '0;
        board_in[19*10 +: 10] = 10'b0000000001;
        check(board_in, 0, "nenhuma linha completa");

        // Uma linha cheia na base; linha parcial acima deve cair uma posicao.
        board_in = '0;
        board_in[19*10 +: 10] = 10'b1111111111;
        board_in[18*10 +: 10] = 10'b0000010101;
        expected = '0;
        expected[19*10 +: 10] = 10'b0000010101;
        check(expected, 1, "uma linha");

        // Duas linhas completas nao adjacentes; linhas parciais mantem ordem.
        board_in = '0;
        board_in[19*10 +: 10] = 10'b1111111111;
        board_in[18*10 +: 10] = 10'b0000000001;
        board_in[17*10 +: 10] = 10'b1111111111;
        board_in[16*10 +: 10] = 10'b1000000000;
        expected = '0;
        expected[19*10 +: 10] = 10'b0000000001;
        expected[18*10 +: 10] = 10'b1000000000;
        check(expected, 2, "duas linhas nao adjacentes");

        board_in = '0;
        for (int y=16; y<20; y++) board_in[y*10 +: 10] = 10'h3ff;
        board_in[15*10 +: 10] = 10'b0000000010;
        expected = '0;
        expected[19*10 +: 10] = 10'b0000000010;
        check(expected, 4, "quatro linhas");

        board_in = '1;
        check(200'b0, 20, "tabuleiro totalmente preenchido");

        $display("PASS: tb_line_clear");
        $finish;
    end
endmodule
