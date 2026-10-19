// calcula tabuleiro apos fixacao de UMA peca.
// Interface combinacional: o controlador externo decide quando gravar.
// board_data[y*10+x] = 1 representa um bloco ja fixado.
module piece_lock (
    input  logic [199:0] board_data,
    input  logic [15:0]  piece_shape,
    input  logic signed [5:0] piece_x,
    input  logic signed [5:0] piece_y,
    output logic [199:0] board_after_lock,
    output logic lock_valid
);
    always_comb begin : compute_board
        integer bx, by;
        board_after_lock = board_data;
        lock_valid = 1'b1;
        for (int y = 0; y < 4; y++) begin
            for (int x = 0; x < 4; x++) begin
                if (piece_shape[15-(4*y+x)]) begin
                    bx = $signed(piece_x) + x;
                    by = $signed(piece_y) + y;
                    if (bx < 0 || bx >= 10 || by < 0 || by >= 20) begin
                        lock_valid = 1'b0;
                    end else if (board_data[by*10+bx]) begin
                        lock_valid = 1'b0;
                    end else begin
                        board_after_lock[by*10+bx] = 1'b1;
                    end
                end
            end
        end
        // Em caso de posicao invalida, NUNCA emitir escrita parcial.
        if (!lock_valid)
            board_after_lock = board_data;
    end
endmodule
