module SirenGeneratorTestbench;

    reg clock, siren;
    wire speaker;

    SirenGenerator SGT (clock, siren, speaker);

    initial
        begin
            clock = 1'b0;
            siren = 1'b0;
            #10 siren = 1'b1;
        end

    initial
        forever #4 clock = ~clock;

    initial #1000 $finish;

endmodule