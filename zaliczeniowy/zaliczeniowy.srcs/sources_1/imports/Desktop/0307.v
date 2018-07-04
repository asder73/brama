
//////////////////////////////////////////////////////////////////////////////////
// opis działania brama garażowa 
// 
//////////////////////////////////////////////////////////////////////////////////


module bramagarazowa_ctrl(
    //input [1:0] stan, // 2 bitowy poziom stanu
    //input [1:0] aktualnystan, // 2 bitowy poziom stanu aktualnego
    input clk, //generawania zegara o niskiej częstotliwosci
    input rst, //1-bitowy rst wejścia
    output kierunek, //1-bitowe wyjście wskazujące kierunek ruchu bramy
    output koniec,	//1-bitowe wyjście wskazujące max stan bramy 
	output awaria,  // sygna� awarii mechanizmu
    output swiatlo //wyjście 1-bitowe podlaczone do oswietlenia
    
    );

    reg r_kierunekruchu; //1 bitowy rejestr podłączony do kierunku wyjścia kierunek
    reg r_koniec; //1 bitowy rejestr podłączony do wyjścia koniec
    reg r_awaria; //1 bitowy rejestr podłączony do wyjścia awaria
	reg r_swiatlo; // 1 bitowy rejestr podlączony do wyjścia swiatła
    reg [1:0] r_aktstan; //2-bitowy rejestr podłączony do wyjścia aktstan
    reg [12:0] clk_licznik; //licznik zegara niskiej częstotliwość jako 12bitowy parametr rejestru   ///max count 4096//
    reg clk_200;         ///   zakładany czas pracy silnika 20s  
    reg clk_wyzw; //wyzwalacz zegara generatora
    
    assign kierunek = r_kierunekruchu; //przypisanie danych kierunku ruchu do r_kierunkuruchu
    assign koniec = r_koniec; //przypisanie koniec   do r_koniec
    assign awaria = r_awaria; //przypisanie awaria do r_awaria
    assign aktstan = r_aktstan; //przypisanie stanów
    assign stan = stan;//
	assign swiatlo = r_swiatlo; //przypisanie swiatła
    
    always @(negedge rst) begin //wyzwalanie bloku na malejącej krawędzi sygnału rst
        clk_200 = 1'b0; //resetowanie clk 200hz
        clk_licznik = 0; //res. licznika
        clk_wyzw = 1'b0; //res. wyzwalacza
    end
    
    always @(negedge rst) begin //wyzwalanie bloku na malejącej krawędzi sygnału rst
        clk_200 = 1'b0; //rstowanie clk 200hz
        clk_licznik = 0; //res. licznika
        clk_wyzw = 1'b0; //res. wyzwalacza

        r_koniec = 1'b0; //ustawienie domyślnej wartości na 0
        r_awaria = 1'b0; //to samo
    end
    
    /*
    	generator zegara
        licznik bedzie sie zwiekszal za kazdym razem, 
        gdy uruchomi się petla lub zostanie wlaczony generator zegara 200hz
    */
    always @(posedge clk) begin
        if(clk_wyzw) begin
            clk_licznik = clk_licznik+1; 
        end
        if(clk_licznik == 4000) begin
            clk_200 = ~clk_200;
            clk_licznik = 0;
        end
    end
   
    //jeżeli jest sygnal otwarcia
    always @(stan) begin
        clk_wyzw = 1; //wlaczenie wyzwalacza zegara
        clk_200 = ~clk_200; //negacja czestotliwosci zegara
        r_aktstan <= r_koniec;
    end
    
    //praca bramy
    always @(posedge clk) begin
    	//normalne działanie bramy
        if(!rst  && !awaria) begin
            //podnosi sie
            if(r_aktstan <= r_koniec) begin
                r_kierunekruchu = 1'b1; 
                r_aktstan = r_koniec << 1;
            end
            
            //osiągnięcie nax uniesienia bramy
            else if( r_aktstan == r_koniec) begin
                r_koniec = 1;
                r_kierunekruchu = 0;
				r_swiatlo =1;
            end
        end
        //gdy brama osiagnie max otwarcie
        else if(!rst && !awaria) begin
            r_koniec = 1;
            r_swiatlo = 1;
            r_kierunekruchu = 0;
        
        end
        //gdy brama zaczyna sie zamykac
        else if(!rst && !awaria) begin
            r_koniec = 0;
            r_kierunekruchu = 1'b0;
            r_swiatlo = 0;
        //gasnie swiatlo
        end
        else if(!rst && awaria) begin
                    r_koniec = 0;
                    r_kierunekruchu = 0;
                    r_swiatlo = 1;
                //stoi brama swieci swiatlo
                end
    end
	
endmodule