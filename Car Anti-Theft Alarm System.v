module CarAntiTheftAlarmSystem (input clock, systemReset, ignition, brake, hidden, driver, passenger, output fuelPumpPower, statusIndicator, siren);

    wire startTimer, clock1Hz, expired, sysReset, ign, brk, hid, drv, pas;
    wire [1:0] interval;
    wire [3:0] value;

    Debouncer D1 (clock, systemReset, sysReset);
    Debouncer D2 (clock, ignition, ign);
    Debouncer D3 (clock, brake, brk);
    Debouncer D4 (clock, hidden, hid);
    Debouncer D5 (clock, driver, drv);
    Debouncer D6 (clock, passenger, pas);
    FuelPumpLogic FPL (clock, ign, brk, hid, fuelPumpPower);
    AntiTheftFSM ATFSM (clock, sysReset, ign, drv, pas, clock1Hz, expired, statusIndicator, siren, startTimer, interval);
    TimeParameters TP (interval, value);
    Timer1Hz T1Hz (clock, startTimer, value, clock1Hz, expired);

endmodule

module Debouncer (input clock, I, output reg O);

    reg [19:0] count = 20'b00000000000000000000;
    reg IReg;

    always @ (posedge clock)
        begin
            if (IReg != I)
                begin
                    IReg <= I;
                    count <= 20'b00000000000000000000;
                end
            else if (count == 1000000)
                O <= IReg;
            else
                count <= count + 1;
        end

endmodule

module FuelPumpLogic (input clock, ignition, brake, hidden, output reg fuelPumpPower);

    reg fuelPumpPowerReg;

    always @ (posedge clock)
        fuelPumpPowerReg <= fuelPumpPower;

    always @ (ignition, brake, hidden, fuelPumpPowerReg)
        fuelPumpPower <= (ignition & fuelPumpPowerReg) | (ignition & brake & hidden);

endmodule

module AntiTheftFSM (input clock, systemReset, ignition, driver, passenger, clock1Hz, expired, output reg status, siren, startTimer, output reg [1:0] interval);

    parameter [2:0] OffDisarmed = 3'b000, OffArmed = 3'b001, OnDisarmed = 3'b010, Siren = 3'b011, TimeWait = 3'b100;
    reg clock2s = 1'b0, doorsOpen;
    reg [2:0] state, nextState;

    always @ (posedge clock)
        begin
            if (clock1Hz)
                clock2s = ~clock2s;

            case (state)
                OffDisarmed :
                    begin
                        if (systemReset)
                            begin
                                doorsOpen = 1'b0;
                                status = clock2s;
                                startTimer = 1'b0;
                                siren = 1'b0;
                                nextState = OffArmed;
                            end
                        if (ignition)
                            begin
                                doorsOpen = 1'b0;
                                nextState = OnDisarmed;
                            end
                        else if (~(driver & passenger))
                            begin
                                doorsOpen = 1'b1;
                                status = 1'b0;
                                siren = 1'b0;
                                startTimer = 1'b0;
                                nextState = OffDisarmed;
                            end
                        else
                            begin
                                if (driver & passenger & doorsOpen)
                                    begin
                                        interval = 2'b00;
                                        startTimer = 1'b1;
                                        doorsOpen = 1'b0;
                                        status = 1'b1;
                                        siren = 1'b0;
                                        nextState = TimeWait;
                                    end
                                else
                                    begin
                                        doorsOpen = 1'b1;
                                        status = 1'b0;
                                        siren = 1'b0;
                                        startTimer = 1'b0;
                                        nextState = OffDisarmed;
                                    end
                            end
                    end

                OffArmed :
                    begin
                        if (ignition)
                            begin
                                status = 1'b0;
                                siren = 1'b0;
                                startTimer = 1'b0;
                                nextState = OnDisarmed;
                            end
                        else if (~driver)
                            begin
                                interval = 2'b01;
                                startTimer = 1'b1;
                                status = 1'b1;
                                siren = 1'b0;
                                nextState = TimeWait;
                            end
                        else if (~passenger)
                            begin
                                interval = 2'b10;
                                startTimer = 1'b1;
                                status = 1'b1;
                                siren = 1'b0;
                                nextState = TimeWait;
                            end
                        else
                            begin
                                status = clock2s;
                                siren = 1'b0;
                                startTimer = 1'b0;
                                nextState = OffArmed;
                            end
                    end

                OnDisarmed :
                    begin
                        if (systemReset)
                            begin
                                doorsOpen = 1'b0;
                                status = clock2s;
                                startTimer = 1'b0;
                                siren = 1'b0;
                                nextState = OffArmed;
                            end
                        if (~ignition)
                            begin
                                status = 1'b0;
                                siren = 1'b0;
                                startTimer = 1'b0;
                                nextState = OffDisarmed;
                            end
                        else
                            begin
                                status = 1'b0;
                                siren = 1'b0;
                                startTimer = 1'b0;
                                nextState = OnDisarmed;
                            end
                    end

                Siren :
                    begin
                        if (driver & passenger)
                            begin
                                interval = 2'b11;
                                startTimer = 1'b1;
                                status = 1'b1;
                                siren = 1'b1;
                                nextState = TimeWait;
                            end
                         else
                            begin
                                status = 1'b1;
                                siren = 1'b1;
                                startTimer = 1'b0;
                                nextState = Siren;
                            end
                    end

                TimeWait :
                    begin
                        startTimer = 1'b0;
                        if (expired)
                            begin
                                case (interval)
                                    2'b00, 2'b11 :
                                        begin
                                            status = clock2s;
                                            siren = 1'b0;
                                            nextState = OffArmed;
                                        end
                                    2'b01, 2'b10 :
                                        begin
                                            status = 1'b1;
                                            siren = 1'b1;
                                            nextState = Siren;
                                        end
                                endcase
                            end
                        else
                            begin
                                case (interval)
                                    2'b00 :
                                        begin
                                            if (~(driver & passenger))
                                                begin
                                                    status = 1'b0;
                                                    siren = 1'b0;
                                                    nextState = OffDisarmed;
                                                end
                                            else if (ignition)
                                                begin
                                                    status = 1'b0;
                                                    siren = 1'b0;
                                                    nextState = OnDisarmed;
                                                end
                                            else
                                                nextState = TimeWait;
                                        end
                                    2'b01, 2'b10 :
                                        begin
                                            if (ignition)
                                                begin
                                                    status = 1'b0;
                                                    siren = 1'b0;
                                                    nextState = OnDisarmed;
                                                end
                                            else
                                                nextState = TimeWait;
                                        end
                                    2'b11 :
                                        nextState = TimeWait;
                                endcase
                            end
                    end

                default :
                    begin
                        status = clock2s;
                        siren = 1'b0;
                        startTimer = 1'b0;
                        nextState = OffArmed;
                    end
            endcase
            
            state = nextState;
        end

endmodule

module TimeParameters (input [1:0] interval, output reg [3:0] value);

    always @ (interval)
        begin
            case (interval)
                2'b00 :
                    value = 4'b0110;
                2'b01 :
                    value = 4'b1000;
                2'b10 :
                    value = 4'b1111;
                2'b11 :
                    value = 4'b1010;
            endcase
        end

endmodule

module Timer1Hz (input clock, startTimer, input [3:0] value, output reg clock1Hz, expired);

    reg [26:0] counter = 27'b000000000000000000000000000;
//    reg [3:0] counter = 3'b0000; // only for simulation
    reg [3:0] counter1Hz = 4'b0000;
    reg indicator;

    always @ (startTimer, clock1Hz)
        begin
            if (startTimer & clock1Hz)
                indicator <= 1'b1;
            else
                indicator <= 1'b0;
        end

    always @ (negedge clock)
        begin
            if (counter == 27'b111011100110101100100111111)
//            if (counter == 4'b1001) // only for simulation
                begin
                    clock1Hz <= 1'b1;
                    counter <= 27'b000000000000000000000000000;
//                    counter <= 4'b0000; // only for simulation
                end
            else
                begin
                  	clock1Hz <= 1'b0;
                    counter <= counter + 27'b000000000000000000000000001;
//                    counter <= counter + 4'b0001; // only for simulation
                end

            if (startTimer)
                begin
                    counter <= 27'b111011100110101100100111111;
//                    counter <= 4'b1001; // only for simulation
                    counter1Hz <= 4'b0000;
                    expired <= 1'b0;
                end

            if (clock1Hz)
                begin
                    if (indicator)
                        counter1Hz <= 4'b0000;
                    else if (counter1Hz == value)
                        begin
                            expired <= 1'b1;
                            counter1Hz <= 4'b0000;
                        end
                    else
                        counter1Hz <= counter1Hz + 4'b0001;
                end

            if (expired)
                begin
                    expired <= 1'b0;
                    counter <= 27'b000000000000000000000000000;
//                    counter <= 4'b0000; // only for simulation
                end
        end

endmodule