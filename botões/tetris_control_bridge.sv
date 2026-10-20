module tetris_control_bridge #(
    parameter integer DEBOUNCE_CYCLES = 500_000
) (
    input  logic clk,
    input  logic reset,
    input  logic [3:0] KEY,

    output logic move_left,
    output logic move_right,
    output logic move_down,
    output logic rotate
);

    logic rotate_piece;
    logic soft_drop;

    button_press #(
        .DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)
    ) btn_left (
        .clk(clk),
        .reset(reset),
        .button_n(KEY[0]),
        .press_pulse(move_left)
    );

    button_press #(
        .DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)
    ) btn_right (
        .clk(clk),
        .reset(reset),
        .button_n(KEY[1]),
        .press_pulse(move_right)
    );

    button_press #(
        .DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)
    ) btn_rotate (
        .clk(clk),
        .reset(reset),
        .button_n(KEY[2]),
        .press_pulse(rotate_piece)
    );

    button_press #(
        .DEBOUNCE_CYCLES(DEBOUNCE_CYCLES)
    ) btn_drop (
        .clk(clk),
        .reset(reset),
        .button_n(KEY[3]),
        .press_pulse(soft_drop)
    );

    // Adaptacao para a interface da logica do jogo
    assign rotate   = rotate_piece;
    assign move_down = soft_drop;

endmodule
