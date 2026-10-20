module button_press #(
    parameter integer DEBOUNCE_CYCLES = 500_000
) (
    input  logic clk,
    input  logic reset,
    input  logic button_n,
    output logic press_pulse
);

    localparam integer COUNT_WIDTH =
        (DEBOUNCE_CYCLES <= 1) ? 1 : $clog2(DEBOUNCE_CYCLES);

    logic sync1;
    logic sync2;
    logic stable_n;
    logic [COUNT_WIDTH-1:0] count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            sync1      <= 1'b1;
            sync2      <= 1'b1;
            stable_n   <= 1'b1;
            count      <= '0;
            press_pulse <= 1'b0;
        end else begin
            // Sincroniza a entrada fisica
            sync1 <= button_n;
            sync2 <= sync1;

            // O pulso dura somente um ciclo
            press_pulse <= 1'b0;

            // A entrada voltou ao estado estavel?
            if (sync2 == stable_n) begin
                count <= '0;
            end else if (count >= DEBOUNCE_CYCLES - 1) begin

                // Aceita a nova entrada apos estabilidade
                if (stable_n && !sync2)
                    press_pulse <= 1'b1;

                stable_n <= sync2;
                count <= '0;
            end else begin
                count <= count + 1'b1;
            end
        end
    end

endmodule
