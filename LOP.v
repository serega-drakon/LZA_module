`include "ranges.def.v"
`include "pre_encoding.v"
`include "detection_tree.v"
`include "encoding_tree.v"

module LOP #(
    parameter DATA_WIDTH    = 8,
    parameter SHIFT_WIDTH   = $clog2(DATA_WIDTH)
)(
    input                               clk,
    input                               enable, //регистры переключаются только, если enable == 1
    input       [DATA_WIDTH - 1 : 0]    data_A,
    input       [DATA_WIDTH - 1 : 0]    data_B,
    output reg  [SHIFT_WIDTH - 1 : 0]   nshift_r,
    output reg                          nshift_correct_r,
    output reg                          not_zero_r
);

    wire    [DATA_WIDTH - 1 : 0]   string_n_pos;
    wire    [DATA_WIDTH - 1 : 0]   string_z_pos;
    wire    [DATA_WIDTH - 1 : 0]   string_p_pos;

    wire    [DATA_WIDTH - 1 : 0]   string_n_neg;
    wire    [DATA_WIDTH - 1 : 0]   string_z_neg;
    wire    [DATA_WIDTH - 1 : 0]   string_p_neg;

    wire    [DATA_WIDTH - 1 : 0]   string_f;

    pre_encoding #(.DATA_WIDTH(DATA_WIDTH)) PE (
        .data_A         (data_A),
        .data_B         (data_B),
        .string_n_pos   (string_n_pos),
        .string_z_pos   (string_z_pos),
        .string_p_pos   (string_p_pos),
        .string_n_neg   (string_n_neg),
        .string_z_neg   (string_z_neg),
        .string_p_neg   (string_p_neg),
        .string_f       (string_f)
    );

    wire    [SHIFT_WIDTH - 1 : 0]   nshift;
    wire                            not_zero;

    encoding_tree #(
        .DATA_WIDTH     (DATA_WIDTH),
        .SHIFT_WIDTH    (SHIFT_WIDTH)
    ) ET (
        .string_f   (string_f),
        .nshift     (nshift),
        .not_zero   (not_zero)
    );

    wire                            nshift_correct;

    detection_tree #(
        .DATA_WIDTH(DATA_WIDTH)
    ) DT (
        .string_n_pos   (string_n_pos),
        .string_z_pos   (string_z_pos),
        .string_p_pos   (string_p_pos),
        .string_n_neg   (string_n_neg),
        .string_z_neg   (string_z_neg),
        .string_p_neg   (string_p_neg),
        .nshift_correct (nshift_correct)
    );

    always @(posedge clk)
        nshift_r <= (enable) ? nshift : nshift_r;

    always @(posedge clk)
        nshift_correct_r <= (enable) ? nshift_correct : nshift_correct_r;

    always @(posedge clk)
        not_zero_r <= (enable) ? not_zero:not_zero_r;

endmodule