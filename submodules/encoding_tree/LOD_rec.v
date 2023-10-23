module LOD_rec #(
    parameter LOD_REC_NUM       = 0, //от нуля до 3х получается слева-направо
    parameter DATA_WIDTH_CURR   = 8, //пусть гарантированно является степенью двойки
    parameter POS_WIDTH         = $clog2(DATA_WIDTH_CURR), //это лучше не трогать
    parameter POS_PREV_WIDTH    = POS_WIDTH - 1
)(
    input   [DATA_WIDTH_CURR - 1 : 0]   string_f_part,
    output  [POS_WIDTH - 1 : 0]         pos,
    output                              not_zero
);

    generate
        if(DATA_WIDTH_CURR > 2) begin
            wire    [POS_PREV_WIDTH - 1 : 0]    pos_prev_0;
            wire    [POS_PREV_WIDTH - 1 : 0]    pos_prev_1;
            wire                                not_zero_prev_0;
            wire                                not_zero_prev_1;

            assign not_zero = not_zero_prev_0 | not_zero_prev_1;

            wire    [POS_PREV_WIDTH - 1 : 0]    pos_choice =
                (not_zero_prev_0) ? pos_prev_0 : pos_prev_1;

            assign pos = {~not_zero_prev_0, pos_choice};

            localparam DATA_WIDTH_PREV      = DATA_WIDTH_CURR / 2;
            localparam LOD_REC_NUM_PREV_0   = LOD_REC_NUM;
            localparam LOD_REC_NUM_PREV_1   = LOD_REC_NUM + 1;

            wire    [DATA_WIDTH_PREV - 1 : 0]   string_f_part_prev_0 =
                string_f_part   [2 * DATA_WIDTH_PREV - 1 : DATA_WIDTH_PREV];
            wire    [DATA_WIDTH_PREV - 1 : 0]   string_f_part_prev_1 =
                string_f_part   [DATA_WIDTH_PREV - 1 : 0];

            LOD_rec #(
                .LOD_REC_NUM        (LOD_REC_NUM_PREV_0),
                .DATA_WIDTH_CURR    (DATA_WIDTH_PREV)
            ) LOD_rec_prev_0 (
                .string_f_part      (string_f_part_prev_0),
                .pos                (pos_prev_0),
                .not_zero           (not_zero_prev_0)
            );
            LOD_rec #(
                .LOD_REC_NUM        (LOD_REC_NUM_PREV_1),
                .DATA_WIDTH_CURR    (DATA_WIDTH_PREV)
            ) LOD_rec_prev_1 (
                .string_f_part      (string_f_part_prev_1),
                .pos                (pos_prev_1),
                .not_zero           (not_zero_prev_1)
            );
        end
        else if(DATA_WIDTH_CURR == 2) begin
            assign not_zero = string_f_part[1] | string_f_part[0];
            assign pos = (string_f_part[1]) ? 0 : 1;
        end
    endgenerate

endmodule