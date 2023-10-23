module pre_encoding_LO#(
    parameter DATA_WIDTH = 8
)(
    input   [DATA_WIDTH - 1 : 0]    data_A,
    input   [DATA_WIDTH - 1 : 0]    data_B,

    output  [DATA_WIDTH - 1 : 0]    e,
    output  [DATA_WIDTH - 1 : 0]    g,
    output  [DATA_WIDTH - 1 : 0]    s,
    output  [DATA_WIDTH - 1 : 0]    string_f
);
    // а мне захотелось вот в вентили поупарываться
    assign e =
         (data_A & data_B) | ~(data_A | data_B); // a = b = 1 or 0
    assign g =
        data_A & ~data_B; // a = 1, b = 0
    assign s =
        ~data_A & data_B; // a = 0, b = 1

    generate for(genvar i = DATA_WIDTH - 1; i >= 0; i = i - 1) begin : for_LO
        if(i == DATA_WIDTH - 1)
            assign string_f[i] =
                g[i] & ~s[i - 1] | s[i] & ~g[i - 1];
        else if(i > 0)
            assign string_f[i] =
                 e[i + 1] & (g[i] & ~s[i - 1] | s[i] & ~g[i - 1]) |
                ~e[i + 1] & (s[i] & ~s[i - 1] | g[i] & ~g[i - 1]);
        else
            assign string_f[i] =
                 e[i + 1] & (g[i] | s[i])   |
                ~e[i + 1] & (s[i] | g[i])   ;
    end
    endgenerate

endmodule