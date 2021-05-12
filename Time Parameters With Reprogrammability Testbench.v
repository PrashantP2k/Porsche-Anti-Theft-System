module TimeParametersWithReprogrammabilityTestbench;

    reg systemReset, reprogram;
    reg [1:0] interval, timeParameterSelector;
    reg [3:0] timeValue;
    wire [3:0] value;

    TimeParametersWithReprogrammability TPWRT (systemReset, reprogram, interval, timeParameterSelector, timeValue, value);

    initial
        begin
            systemReset = 1'b1;
            #12 systemReset = 1'b0;
            reprogram = 1'b0;
            interval = 2'b00;
            timeParameterSelector = 2'bxx;
            timeValue = 4'bxxxx;
            #12 interval = 2'b01;
            #12 interval = 2'b10;
            #12 interval = 2'b11;
            #12 interval = 2'bxx;
            timeParameterSelector = 2'b00;
            timeValue = 4'b0111;
            #12 reprogram = 1'b1;
            #12 reprogram = 1'b0;
            timeParameterSelector = 2'b01;
            timeValue = 4'b0100;
            #12 reprogram = 1'b1;
            #12 reprogram = 1'b0;
            timeParameterSelector = 2'b10;
            timeValue = 4'b1110;
            #12 reprogram = 1'b1;
            #12 reprogram = 1'b0;
            timeParameterSelector = 2'b11;
            timeValue = 4'b1001;
            #12 reprogram = 1'b1;
            #12 reprogram = 1'b0;
            timeParameterSelector = 2'bxx;
            timeValue = 4'bxxxx;
            interval = 2'b00;
            #12 interval = 2'b01;
            #12 interval = 2'b10;
            #12 interval = 2'b11;
        end

    initial #204 $finish;

endmodule