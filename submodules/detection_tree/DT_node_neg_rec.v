module DT_node_neg_rec #(
    parameter DATA_WIDTH_CURR   = 8
)(
    input   [DATA_WIDTH_CURR - 1 : 0]   string_n_neg,
    input   [DATA_WIDTH_CURR - 1 : 0]   string_z_neg,
    input   [DATA_WIDTH_CURR - 1 : 0]   string_p_neg,

    output                              Z_neg,
    output                              N_neg,
    output                              P_neg,
    output                              Y_neg
);

    generate if(DATA_WIDTH_CURR > 2) begin
        wire Z_neg_prev_0;
        wire N_neg_prev_0;
        wire P_neg_prev_0;
        wire Y_neg_prev_0;

        wire Z_neg_prev_1;
        wire N_neg_prev_1;
        wire P_neg_prev_1;
        wire Y_neg_prev_1;

        localparam DATA_WIDTH_PREV = DATA_WIDTH_CURR / 2;

        wire [DATA_WIDTH_PREV - 1 : 0] string_n_neg_prev_0 =
                                       string_n_neg [DATA_WIDTH_PREV * 2 - 1 : DATA_WIDTH_PREV];
        wire [DATA_WIDTH_PREV - 1 : 0] string_z_neg_prev_0 =
                                       string_z_neg [DATA_WIDTH_PREV * 2 - 1 : DATA_WIDTH_PREV];
        wire [DATA_WIDTH_PREV - 1 : 0] string_p_neg_prev_0 =
                                       string_p_neg [DATA_WIDTH_PREV * 2 - 1 : DATA_WIDTH_PREV];

        wire [DATA_WIDTH_PREV - 1 : 0] string_n_neg_prev_1 =
                                       string_n_neg [DATA_WIDTH_PREV - 1 : 0];
        wire [DATA_WIDTH_PREV - 1 : 0] string_z_neg_prev_1=
                                       string_z_neg [DATA_WIDTH_PREV - 1 : 0];
        wire [DATA_WIDTH_PREV - 1 : 0] string_p_neg_prev_1=
                                       string_p_neg [DATA_WIDTH_PREV - 1 : 0];

        DT_node_neg_rec #(
            .DATA_WIDTH_CURR    (DATA_WIDTH_PREV)
        ) DTN_neg_rec_prev_0 (
            .string_n_neg       (string_n_neg_prev_0),
            .string_z_neg       (string_z_neg_prev_0),
            .string_p_neg       (string_p_neg_prev_0),
            .Z_neg              (Z_neg_prev_0),
            .N_neg              (N_neg_prev_0),
            .P_neg              (P_neg_prev_0),
            .Y_neg              (Y_neg_prev_0)
        );

        DT_node_neg_rec #(
            .DATA_WIDTH_CURR    (DATA_WIDTH_PREV)
        ) DTN_neg_rec_prev_1 (
            .string_n_neg       (string_n_neg_prev_1),
            .string_z_neg       (string_z_neg_prev_1),
            .string_p_neg       (string_p_neg_prev_1),
            .Z_neg              (Z_neg_prev_1),
            .N_neg              (N_neg_prev_1),
            .P_neg              (P_neg_prev_1),
            .Y_neg              (Y_neg_prev_1)
        );

        assign Z_neg = Z_neg_prev_0 & Z_neg_prev_1;
        assign N_neg = Z_neg_prev_0 & N_neg_prev_1   |
                       N_neg_prev_0 & Z_neg_prev_1;
        assign P_neg = P_neg_prev_0 |
                       Z_neg_prev_0 & P_neg_prev_1;
        assign Y_neg = Y_neg_prev_0 |
                       Z_neg_prev_0 & Y_neg_prev_1  |
                       N_neg_prev_0 & P_neg_prev_1;
    end
    else if(DATA_WIDTH_CURR == 2) begin
        assign Z_neg = string_z_neg[1] & string_z_neg[0];
        assign N_neg = string_z_neg[1] & string_n_neg[0]  |
                       string_z_neg[0] & string_n_neg[1];
        assign P_neg = string_p_neg[1] |
                       string_z_neg[1] & string_p_neg[0];
        assign Y_neg = string_n_neg[1] & string_p_neg[0];
    end
    endgenerate

endmodule