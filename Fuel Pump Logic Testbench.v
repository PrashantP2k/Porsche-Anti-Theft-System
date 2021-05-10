module FuelPumpLogicTestbench;

    reg clock, ignition, brake, hidden;
    wire FuelPumpPower;

    FuelPumpLogic FPLT (clock, ignition, brake, hidden, FuelPumpPower);

    initial
        begin
            clock = 1'b0;
            ignition = 1'b0;
            brake = 1'b0;
            hidden = 1'b0;
            #10 ignition = 1'b1;
            #12 brake = 1'b1;
            #12 hidden = 1'b1;
            #12 hidden = 1'b0;
            #12 brake = 1'b0;
            #12 ignition = 1'b0;
        end

    initial
        forever #4 clock = ~clock;

    initial #80 $finish;

endmodule