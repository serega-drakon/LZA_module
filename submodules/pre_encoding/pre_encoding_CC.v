module pre_encoding_CC#(
    parameter DATA_WIDTH = 8
)(
    input   [DATA_WIDTH - 1 : 0]    data_A,
    input   [DATA_WIDTH - 1 : 0]    data_B,

    input   [DATA_WIDTH - 1 : 0]    e,
    input   [DATA_WIDTH - 1 : 0]    g,
    input   [DATA_WIDTH - 1 : 0]    s,

    output  [DATA_WIDTH - 1 : 0]    string_n_pos,
    output  [DATA_WIDTH - 1 : 0]    string_z_pos,
    output  [DATA_WIDTH - 1 : 0]    string_p_pos,

    output  [DATA_WIDTH - 1 : 0]    string_n_neg,
    output  [DATA_WIDTH - 1 : 0]    string_z_neg,
    output  [DATA_WIDTH - 1 : 0]    string_p_neg
);

    generate for(genvar i = DATA_WIDTH - 1; i >= 0; i = i - 1) begin : for_pos_CC
        if(i > 0)
            assign string_p_pos[i] = (g[i] | s[i]) & ~s[i - 1];
        else
            assign string_p_pos[i] = g[i] | s[i];

        if(i == DATA_WIDTH - 1)
            assign string_n_pos[i] = s[i];
        else
            assign string_n_pos[i] = e[i + 1] & s[i];

    end
    endgenerate

    assign string_z_pos = ~string_p_pos & ~string_n_pos;

    generate for(genvar i = DATA_WIDTH - 1; i >= 0; i = i - 1) begin : for_neg_CC
        if(i > 0)
            assign string_n_neg[i] = (s[i] | g[i]) & ~g[i - 1];
        else
            assign string_n_neg[i] = s[i] | g[i];

        if(i == DATA_WIDTH - 1)
            assign string_p_neg[i] = g[i];
        else
            assign string_p_neg[i] = e[i + 1] & g[i];
    end
    endgenerate

    assign string_z_neg = ~string_p_neg & ~string_n_neg;

endmodule