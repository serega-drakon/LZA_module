`include "pre_encoding_CC.v"
`include "pre_encoding_LO.v"

module pre_encoding #(
    parameter DATA_WIDTH    = 8
)(
    input   [DATA_WIDTH - 1 : 0]    data_A,
    input   [DATA_WIDTH - 1 : 0]    data_B,

    output  [DATA_WIDTH - 1 : 0]    string_n_pos, //CC
    output  [DATA_WIDTH - 1 : 0]    string_z_pos, //CC
    output  [DATA_WIDTH - 1 : 0]    string_p_pos, //CC

    output  [DATA_WIDTH - 1 : 0]    string_n_neg, //CC
    output  [DATA_WIDTH - 1 : 0]    string_z_neg, //CC
    output  [DATA_WIDTH - 1 : 0]    string_p_neg, //CC

    output  [DATA_WIDTH - 1 : 0]    string_f  //LO
);
    wire    [DATA_WIDTH - 1 : 0]    e;
    wire    [DATA_WIDTH - 1 : 0]    g;
    wire    [DATA_WIDTH - 1 : 0]    s;

    pre_encoding_LO #(
        .DATA_WIDTH (DATA_WIDTH)
    ) PELO (.data_A    (data_A),
         .data_B    (data_B),
         .e         (e),
         .g         (g),
         .s         (s),
         .string_f  (string_f)
    );

    pre_encoding_CC #(
        .DATA_WIDTH      (DATA_WIDTH)
    ) PECC (
        .data_A          (data_A),
        .data_B          (data_B),
        .e               (e),
        .g               (g),
        .s               (s),
        .string_n_pos    (string_n_pos),
        .string_z_pos    (string_z_pos),
        .string_p_pos    (string_p_pos),
        .string_n_neg    (string_n_neg),
        .string_z_neg    (string_z_neg),
        .string_p_neg    (string_p_neg)
    );

endmodule