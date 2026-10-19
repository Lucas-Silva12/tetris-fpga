// remove todas as linhas totalmente preenchidas e compacta o tabuleiro.
// Convencao: board_in[y*10+x], y=0 (topo), y=19 (base).
// Combinacional: a FSM/memoria externa decide quando registrar board_out.
module line_clear (
    input  logic [199:0] board_in,
    output logic [199:0] board_out,
    output logic [4:0]   lines_cleared
);
    integer dest_row;
    always_comb begin
        board_out     = '0; // as linhas livres novas aparecem no topo
        lines_cleared = 5'd0;
        dest_row      = 19;
        // Varre da base para o topo, preservando a ordem das linhas restantes.
        for (integer src_row = 19; src_row >= 0; src_row = src_row - 1) begin
            if (&board_in[src_row*10 +: 10]) begin
                lines_cleared = lines_cleared + 5'd1;
            end else begin
                board_out[dest_row*10 +: 10] = board_in[src_row*10 +: 10];
                dest_row = dest_row - 1;
            end
        end
    end
endmodule
