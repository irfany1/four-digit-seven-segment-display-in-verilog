module fourdigitsevensegment(
    input clk,
    output reg dig1,
    output reg dig2,
    output reg dig3,
    output reg dig4,
    output reg segA,
    output reg segB,
    output reg segC,
    output reg segD,
    output reg segE,
    output reg segF,
    output reg segG
    );
    
    reg slow_clk; //10Hz
    reg [20:0] counter;//slowclk için
    reg [13:0] number; //9999a kadar
    reg [3:0] led_activating_counter;// 00 01 10 11
    reg [3:0]led_bcd; 
    
    initial begin
        counter=0;
        number=0;
        led_activating_counter=0;
    end
    
    always @(posedge clk) begin
        if(counter==1199999) begin
            slow_clk<=slow_clk+1;
        end       
            counter<=counter+1;    
            
        case(led_activating_counter)
            3'b000 : {dig1,dig2,dig3,dig4} =4'b0001;
            3'b001 : {dig1,dig2,dig3,dig4} =4'b0010;
            3'b010 : {dig1,dig2,dig3,dig4} =4'b0100;
            3'b011 : {dig1,dig2,dig3,dig4} =4'b1000;
        endcase
        
            led_activating_counter=led_activating_counter+1;
            
         if(led_activating_counter==3'b100) begin
            led_activating_counter<=0;
         end      
    end
    
    always @(posedge slow_clk) begin
        if(number==9999) begin
        number<=0;
        end
        number<=number+1;
    end
    
    always @(posedge clk)begin
        case({dig1,dig2,dig3,dig4})
            4'b0001 :led_bcd= number%10;         
            4'b0010 :led_bcd=((number%100)/10);  
            4'b0100 :led_bcd=((number%1000)/100);
            4'b1000 :led_bcd=(number/1000);      
        endcase          
    end
    always @(posedge clk) begin
        case(led_bcd)
            4'b0000 : {segA,segB,segC,segD,segE,segF,segG}=7'b0000001; //0
            4'b0001 : {segA,segB,segC,segD,segE,segF,segG}=7'b1001111; //1
            4'b0010 : {segA,segB,segC,segD,segE,segF,segG}=7'b0010010; //2
            4'b0011 : {segA,segB,segC,segD,segE,segF,segG}=7'b0000110; //3
            4'b0100 : {segA,segB,segC,segD,segE,segF,segG}=7'b1001100; //4
            4'b0101 : {segA,segB,segC,segD,segE,segF,segG}=7'b0100100; //5
            4'b0110 : {segA,segB,segC,segD,segE,segF,segG}=7'b0100000; //6
            4'b0111 : {segA,segB,segC,segD,segE,segF,segG}=7'b0001111; //7
            4'b1000 : {segA,segB,segC,segD,segE,segF,segG}=7'b0000000; //8
            4'b1001 : {segA,segB,segC,segD,segE,segF,segG}=7'b0000100; //9
        endcase
    end
 endmodule