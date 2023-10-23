module DT_node_pos_rec #(
    parameter DATA_WIDTH_CURR   = 8
)(
    input   [DATA_WIDTH_CURR - 1 : 0]   string_n_pos,
    input   [DATA_WIDTH_CURR - 1 : 0]   string_z_pos,
    input   [DATA_WIDTH_CURR - 1 : 0]   string_p_pos,

    output                              Z_pos,
    output                              P_pos,
    output                              N_pos,
    output                              Y_pos
);

    generate if(DATA_WIDTH_CURR > 2) begin
        wire Z_pos_prev_0;
        wire P_pos_prev_0;
        wire N_pos_prev_0;
        wire Y_pos_prev_0;

        wire Z_pos_prev_1;
        wire P_pos_prev_1;
        wire N_pos_prev_1;
        wire Y_pos_prev_1;

        localparam DATA_WIDTH_PREV  = DATA_WIDTH_CURR / 2;

        wire    [DATA_WIDTH_PREV - 1 : 0]   string_n_pos_prev_0 =
            string_n_pos [DATA_WIDTH_PREV * 2 - 1 : DATA_WIDTH_PREV];
        wire    [DATA_WIDTH_PREV - 1 : 0]   string_z_pos_prev_0 =
            string_z_pos [DATA_WIDTH_PREV * 2 - 1 : DATA_WIDTH_PREV];
        wire    [DATA_WIDTH_PREV - 1 : 0]   string_p_pos_prev_0 =
            string_p_pos [DATA_WIDTH_PREV * 2 - 1 : DATA_WIDTH_PREV];

        wire    [DATA_WIDTH_PREV - 1 : 0]   string_n_pos_prev_1 =
            string_n_pos [DATA_WIDTH_PREV - 1 : 0];
        wire    [DATA_WIDTH_PREV - 1 : 0]   string_z_pos_prev_1=
            string_z_pos [DATA_WIDTH_PREV - 1 : 0];
        wire    [DATA_WIDTH_PREV - 1 : 0]   string_p_pos_prev_1=
            string_p_pos [DATA_WIDTH_PREV - 1 : 0];

        DT_node_pos_rec #(
            .DATA_WIDTH_CURR    (DATA_WIDTH_PREV)
        ) DTN_pos_rec_prev_0 (
            .string_n_pos       (string_n_pos_prev_0),
            .string_z_pos       (string_z_pos_prev_0),
            .string_p_pos       (string_p_pos_prev_0),
            .Z_pos              (Z_pos_prev_0),
            .P_pos              (P_pos_prev_0),
            .N_pos              (N_pos_prev_0),
            .Y_pos              (Y_pos_prev_0)
        );

        DT_node_pos_rec #(
            .DATA_WIDTH_CURR    (DATA_WIDTH_PREV)
        ) DTN_pos_rec_prev_1 (
            .string_n_pos       (string_n_pos_prev_1),
            .string_z_pos       (string_z_pos_prev_1),
            .string_p_pos       (string_p_pos_prev_1),
            .Z_pos              (Z_pos_prev_1),
            .P_pos              (P_pos_prev_1),
            .N_pos              (N_pos_prev_1),
            .Y_pos              (Y_pos_prev_1)
        );

        assign Z_pos = Z_pos_prev_0 & Z_pos_prev_1;
        assign P_pos = Z_pos_prev_0 & P_pos_prev_1   |
                       P_pos_prev_0 & Z_pos_prev_1;
        assign N_pos = N_pos_prev_0 |
                       Z_pos_prev_0 & N_pos_prev_1;
        assign Y_pos = Y_pos_prev_0 |
                       Z_pos_prev_0 & Y_pos_prev_1  |
                       P_pos_prev_0 & N_pos_prev_1;
    end
    else if(DATA_WIDTH_CURR == 2) begin
        assign Z_pos = string_z_pos[1] & string_z_pos[0];
        assign P_pos = string_z_pos[1] & string_p_pos[0]  |
                       string_z_pos[0] & string_p_pos[1] ;
        assign N_pos = string_n_pos[1] |
                       string_z_pos[1] & string_n_pos[0];
        assign Y_pos = string_p_pos[1] & string_n_pos[0];
    end
    endgenerate

endmodule