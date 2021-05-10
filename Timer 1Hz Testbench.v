module Timer1HzTestbench;

    reg clock, startTimer;
    reg [3:0] value;
    wire clock1Hz, expired, indicator;
    wire [3:0] counter, counter1Hz;

    Timer1Hz T1HzT (clock, startTimer, value, clock1Hz, expired, indicator, counter, counter1Hz);

    initial
        begin
            clock = 1'b0;
            startTimer = 1'b0;
            value = 4'b0000;
            #4 startTimer = 1'b1;
            #8 startTimer = 1'b0;
            #24 value = 4'b0001;
            #8 startTimer = 1'b1;
            #8 startTimer = 1'b0;
            #136 value = 4'b0011;
            #32 startTimer = 1'b1;
            #8 startTimer = 1'b0;
            #304 value = 4'b0010;
            #32 startTimer = 1'b1;
            #8 startTimer = 1'b0;
            #88 startTimer = 1'b1;
            #8 startTimer = 1'b0;
        end

    initial
        forever #4 clock = ~clock;

    initial #1000 $finish;

endmodule