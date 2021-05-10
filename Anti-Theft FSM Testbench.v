module AntiTheftFSMTestbench;

    reg clock, ignition, driver, passenger, reprogram, expired;
    wire status, siren, startTimer;
    wire [1:0] interval;
    wire [2:0] state, nextState;

    AntiTheftFSM ATFSMT (clock, ignition, driver, passenger, reprogram, expired, status, siren, startTimer, interval, state, nextState);

    initial
        begin
            clock = 1'b0;
            expired = 1'b0;
            ignition = 1'b0;
            driver = 1'b1;
            passenger = 1'b1;
            reprogram = 1'b0;
            driver = 1'b0;
            #36 expired = 1'b1;
            #40 expired = 1'b0;
            #24 driver = 1'b1;
            #16 expired = 1'b1;
            #40 expired = 1'b0;
            #40 expired = 1'b1;
            #40 expired = 1'b0;
            #40 expired = 1'b1;
            #40 expired = 1'b0;
            #40 expired = 1'b1;
            #40 expired = 1'b0;
            #40 expired = 1'b1;
            #40 expired = 1'b0;
        end

    initial
        forever #4 clock = ~clock;

    initial #520 $finish;

endmodule