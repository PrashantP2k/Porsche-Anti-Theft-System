module TimeParametersTestbench;

    reg [1:0] interval;
    wire [3:0] value;

    TimeParameters TPT (interval, value);

    initial
        begin
            interval = 2'b00;
            #12 interval = 2'b01;
            #12 interval = 2'b10;
            #12 interval = 2'b11;
        end

    initial #48 $finish;

endmodule