`include "LOD_rec.v"

module encoding_tree#(
    parameter DATA_WIDTH    = 8, //пусть гарантированно является степенью двойки
    parameter SHIFT_WIDTH   = $clog2(DATA_WIDTH)
)(
    input   [DATA_WIDTH - 1 : 0]    string_f,
    output  [SHIFT_WIDTH - 1 : 0]   nshift,
    output                          not_zero
);

    LOD_rec #(.DATA_WIDTH_CURR(DATA_WIDTH)) LOD (
        .string_f_part  (string_f),
        .pos            (nshift),
        .not_zero       (not_zero)
    );

endmodule