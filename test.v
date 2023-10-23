`include "LOP.v"

module test;
    reg clk = 1;
    always #5 clk = ~clk;

    localparam DATA_WIDTH = 32;
    reg     [DATA_WIDTH - 1 : 0]    data_1;
    reg     [DATA_WIDTH - 1 : 0]    data_2;
    wire    [DATA_WIDTH - 1 : 0]    data_A  = data_1;         //= (data_1 > data_2) ? data_1 : data_2;
    wire    [DATA_WIDTH - 1 : 0]    data_B  = data_2;         //= (data_1 > data_2) ? data_2 : data_1;
    reg     [DATA_WIDTH - 1 : 0]    result;
    reg                             enable;

    localparam SHIFT_WIDTH  = $clog2(DATA_WIDTH);
    wire    [SHIFT_WIDTH - 1 : 0]   nshift_r;
    wire                            nshift_correct_r;
    wire                            not_zero;

    LOP #(
        .DATA_WIDTH(DATA_WIDTH)
    ) LOP (
        clk,
        enable,
        data_A,
        data_B,
        nshift_r,
        nshift_correct_r,
        not_zero
    );

    initial begin
        enable <= 1;
        //#10 enable <= 0;
    end

    always @(posedge clk)
    begin
        data_1 <= $random | (1'b1 << DATA_WIDTH - 1);
        data_2 <= $random | (1'b1 << DATA_WIDTH - 1);
    end

    always @(posedge clk)
        result <= (data_A >= data_B) ? data_A - data_B : data_B - data_A;

    wire    is_zero     [DATA_WIDTH : 0];
    assign  is_zero     [DATA_WIDTH]    = 1;
    generate for(genvar i = DATA_WIDTH - 1; i >= 0; i = i - 1) begin
        assign is_zero[i] = ~result[i] & is_zero[i + 1];
    end
    endgenerate

    wire check  =   result[DATA_WIDTH - nshift_r -nshift_correct_r- 1]  &
                    is_zero[DATA_WIDTH - nshift_r -nshift_correct_r] ;

    //dump settings
    initial begin
        $monitor();
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0);
    end

    initial begin
        #10000000;
        $finish();
    end

endmodule