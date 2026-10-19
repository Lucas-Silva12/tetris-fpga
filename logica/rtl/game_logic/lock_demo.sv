// Uma unica peca: quando um comando de descida falha, fixa a peca.
// Apos a fixacao, trava outros movimentos ate reset.
// O tabuleiro aqui e um registrador simples de 200 bits para teste.
module lock_demo (
    input  logic clk,
    input  logic reset,
    input  logic move_left,
    input  logic move_right,
    input  logic move_down,
    input  logic rotate,
    input  logic [2:0] piece_type,
    output logic [199:0] board_data,
    output logic signed [5:0] piece_x,
    output logic signed [5:0] piece_y,
    output logic [1:0] piece_rotation,
    output logic [15:0] piece_shape,
    output logic locked,
    output logic lock_error
);
    logic blocked_down;
    logic command_accepted;
    logic [199:0] board_after_lock;
    logic lock_valid;
    logic do_lock;

    // Ignora comandos depois da fixacao.
    movement active_piece (
        .clk(clk), .reset(reset),
        .move_left(move_left && !locked),
        .move_right(move_right && !locked),
        .move_down(move_down && !locked),
        .rotate(rotate && !locked),
        .piece_type(piece_type),
        .board_data(board_data),
        .piece_x(piece_x), .piece_y(piece_y),
        .piece_rotation(piece_rotation), .piece_shape(piece_shape),
        .command_accepted(command_accepted),
        .blocked_down(blocked_down)
    );

    piece_lock merge_piece (
        .board_data(board_data),
        .piece_shape(piece_shape),
        .piece_x(piece_x), .piece_y(piece_y),
        .board_after_lock(board_after_lock),
        .lock_valid(lock_valid)
    );

    assign do_lock = blocked_down && !locked;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            board_data <= '0;
            locked <= 1'b0;
            lock_error <= 1'b0;
        end else if (do_lock) begin
            if (lock_valid) begin
                board_data <= board_after_lock;
                locked <= 1'b1;
            end else begin
                lock_error <= 1'b1;
            end
        end
    end
endmodule
