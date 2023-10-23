`include "DT_node_pos_rec.v"
`include "DT_node_neg_rec.v"

module detection_tree#(
    parameter DATA_WIDTH    = 8
)(
    input   [DATA_WIDTH - 1 : 0]    string_n_pos,
    input   [DATA_WIDTH - 1 : 0]    string_z_pos,
    input   [DATA_WIDTH - 1 : 0]    string_p_pos,

    input   [DATA_WIDTH - 1 : 0]    string_n_neg,
    input   [DATA_WIDTH - 1 : 0]    string_z_neg,
    input   [DATA_WIDTH - 1 : 0]    string_p_neg,

    output                          nshift_correct
);
    wire Y_pos;
    wire Y_neg;
    wire N_pos;
    wire P_neg;

    DT_node_pos_rec #(
        .DATA_WIDTH_CURR(DATA_WIDTH)
    ) DTN_pos (
        .string_n_pos   (string_n_pos),
        .string_z_pos   (string_z_pos),
        .string_p_pos   (string_p_pos),
        .N_pos          (N_pos),
        .Y_pos          (Y_pos)
    );

    DT_node_neg_rec #(
        .DATA_WIDTH_CURR(DATA_WIDTH)
    ) DTN_neg (
        .string_n_neg   (string_n_neg),
        .string_z_neg   (string_z_neg),
        .string_p_neg   (string_p_neg),
        .P_neg          (P_neg),
        .Y_neg          (Y_neg)
    );

    wire nshift_correct_pos = Y_pos & ~N_pos;
    wire nshift_correct_neg = Y_neg & ~P_neg;

    assign nshift_correct = nshift_correct_pos | nshift_correct_neg;

endmodule