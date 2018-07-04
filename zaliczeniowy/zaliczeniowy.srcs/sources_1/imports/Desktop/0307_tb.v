module bramagarazowa_ctrl_tb;

	reg r_kierunekruchu; 
    reg r_koniec; 
    reg r_awaria; 
	reg r_swiatlo; 
    reg [1:0] r_aktstan; 
    reg [12:0] clk_licznik; 
    reg clk;  
    reg rst;
	wire kierunek ;
    wire koniec ;
    wire awaria ;
    wire aktualnystan ;
	wire swiatlo ;

	//brama 
	bramagarazowa ect(
		.r_aktstan(r_aktstan),
		.r_kierunekruchu(r_kierunekruchu),
		.clk(clk),
		.rst(rst),
		.kierunek(kierunek),
		.koniec(koniec),
		.awaria(awaria),
		.swiatlo(swiatlo),
		.aktualnystan(aktualnystan)
		);
		
		
		//generowanie zegara i testowanie różnych wejść
	/*
	   1. otwieranie
	   2. zamykanie
	*/
	initial
		begin
			#0 clk = 1'b0; rst = 1'b1; awaria = 1'b0;
			#50 rst = 1'b0;
			#50 rst = 1'b1;
			#50 r_aktstan = 6'b010000; r_koniec= 6'b000001;
			#50 rst = 1;
			#50 rst = 0;
			#50 r_koniec = 6'b000001; r_aktstan = 6'b100000;
			#50 rst = 1'b1;
			#50 rst = 1'b0;
			#50 swiatlo = 1;
			#50 rst = 1'b1;
			#50 rst = 1'b0;
			#50 awaria = 0;
			#50 rst = 1'b1;
		end
	   always #50 clk =~clk;
endmodule