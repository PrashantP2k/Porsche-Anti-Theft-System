module SirenGenerator (input clock, siren, output reg speaker);

    reg [26:0] tone;
    wire [6:0] ramp = ~tone[25:19];
    wire [17:0] clockDivider = {2'b01, ramp, 9'b000000000};
    reg [17:0] counter;

    always @ (posedge clock)
        begin
            if (~siren)
                begin
                    speaker <= 1'b0;
                    tone <= 27'b000000000000000000000000000;
                    counter <= clockDivider;
                end
            else
                begin
                    tone <= tone + 27'b000000000000000000000000001;
                    if (counter == 18'b000000000000000000)
                        begin
                            counter <= clockDivider;
                            speaker <= ~speaker;
                        end
                    else
                        counter <= counter - 18'b00000000000000001;
                end
        end

endmodule