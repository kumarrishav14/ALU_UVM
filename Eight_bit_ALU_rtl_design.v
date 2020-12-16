module Eight_bit_ALU_rtl_design(OPA,OPB,CIN,CLK,RST,CMD,CE,MODE,COUT,OFLOW,RES,G,E,L,ERR);


//Input output port declaration
  input [7:0] OPA,OPB;
  input CLK,RST,CE,MODE,CIN;
  input [3:0] CMD;
  output reg [8:0] RES = 9'bz;
  output reg COUT = 1'bz;
  output reg OFLOW = 1'bz;
  output reg G = 1'bz;
  output reg E = 1'bz;
  output reg L = 1'bz;
  output reg ERR = 1'bz;

//Temporary register declaration
  reg [7:0] OPA_1, OPB_1;

    always@(posedge CLK)
      begin
       if(CE)                   // If clock enable is active high then check for other control signals
        begin
         if(RST)                // If reset is active high all output signals are equal to zero
          begin
            RES=9'bzzzzzzzzz;
            COUT=1'bz;
            OFLOW=1'bz;
            G=1'bz;
            E=1'bz;
            L=1'bz;
            ERR=1'bz;
          end

         else if(MODE)          // Reset signal is active low. If MODE signal is high, then this is an Arithmetic Operation
         begin
           RES=9'bzzzzzzzzz;
           COUT=1'bz;
           OFLOW=1'bz;
           G=1'bz;
           E=1'bz;
           L=1'bz;
           ERR=1'bz;
          case(CMD)             // CMD is the binary code value of the Arithmetic Operation
           4'b0000:             // CMD = 0000: ADD 
            begin             
              RES=OPA+OPB;
              COUT=RES[8]?1:0;
            end
	   4'b0001:             // CMD = 0001: SUB
            begin
             OFLOW=(OPA<OPB)?1:0;
             RES=OPA-OPB;
            end
           4'b0010:             // CMD = 0010: ADD_CIN
            begin
             RES=OPA+OPB+CIN;
             COUT=RES[8]?1:0;
            end
           4'b0011:             // CMD = 0011: SUB_CIN. Here we set the overflow flag
           begin
            OFLOW=(OPA<OPB)?1:0;
            RES=OPA-OPB-CIN;
           end
           4'b0100:RES=OPA+1;    // CMD = 0100: INC_A
           4'b0101:RES=OPA-1;    // CMD = 0101: DEC_A
           4'b0110:RES=OPB+1;    // CMD = 0110: INC_B
           4'b0111:RES=OPB-1;    // CMD = 0111: DEC_B
           4'b1000:              // CMD = 1000: CMP
           begin
            RES=9'bzzzzzzzzz;
            if(OPA==OPB)
             begin
               E=1'b1;
               G=1'bz;
               L=1'bz;
             end
            else if(OPA>OPB)
             begin
               E=1'bz;
               G=1'b1;
               L=1'bz;
             end
            else 
             begin
               E=1'bz;
               G=1'bz;
               L=1'b1;
             end
           end
           default:   // For any other case send high impedence value
            begin
            RES=9'bzzzzzzzzz;
            COUT=1'bz;
            OFLOW=1'bz;
            G=1'bz;
            E=1'bz;
            L=1'bz;
            ERR=1'bz;
           end
          endcase
         end

        else          // MODE signal is low, then this is a Logical Operation
        begin 
           RES=9'bzzzzzzzzz;
           COUT=1'bz;
           OFLOW=1'bz;
           G=1'bz;
           E=1'bz;
           L=1'bz;
           ERR=1'bz;
           case(CMD)    // CMD is the binary code value of the Logical Operation
             4'b0000:RES={1'b0,OPA&OPB};     // CMD = 0000: AND
             4'b0001:RES={1'b0,~(OPA&OPB)};  // CMD = 0001: NAND
             4'b0010:RES={1'b0,OPA|OPB};     // CMD = 0010: OR
             4'b0011:RES={1'b0,~(OPA|OPB)};  // CMD = 0011: NOR
             4'b0100:RES={1'b0,OPA^OPB};     // CMD = 0100: XOR
             4'b0101:RES={1'b0,~(OPA^OPB)};  // CMD = 0101: XNOR
             4'b0110:RES={1'b0,~OPA};        // CMD = 0110: NOT_A
             4'b0111:RES={1'b0,~OPB};        // CMD = 0111: NOT_B
             4'b1000:RES={1'b0,OPA>>1};      // CMD = 1000: SHR1_A
             4'b1001:RES={1'b0,OPA<<1};      // CMD = 1001: SHL1_A
             4'b1010:RES={1'b0,OPB>>1};      // CMD = 1010: SHR1_B
             4'b1011:RES={1'b0,OPB<<1};      // CMD = 1011: SHL1_B
             4'b1100:                        // CMD = 1100: ROL_A_B
             begin 
               if(OPB[0])
                 OPA_1 = {OPA[6:0], OPA[7]};
               else
                 OPA_1 = OPA;

               if(OPB[1])
                 OPB_1 =  {OPA_1[5:0], OPA_1[7:6]}; 
               else
                 OPB_1= OPA_1;

               if(OPB[2])
                 RES =  {OPB_1[3:0], OPB_1[7:4]} ;
               else
                 RES = OPB_1;

               if(OPB[4] | OPB[5] | OPB[6] | OPB[7])
                 ERR=1'b1;
             end
             4'b1101:                        // CMD = 1101: ROR_A_B 
             begin
               if(OPB[0])
                 OPA_1 = {OPA[0], OPA[7:1]};
               else
                 OPA_1 = OPA;
               if(OPB[1])
                 OPB_1 =  {OPA_1[1:0], OPA_1[7:2]}; 
               else
                 OPB_1= OPA_1;
               if(OPB[2])
                 RES =  {OPB_1[3:0], OPB_1[7:4]} ;
               else
                 RES = OPB_1;
               if(OPB[4] | OPB[5] | OPB[6] | OPB[7])
                 ERR=1'b1;
             end
             default:    // For any other case send high impedence value
               begin
               RES=9'bzzzzzzzzz;
               COUT=1'bz;
               OFLOW=1'bz;
               G=1'bz;
               E=1'bz;
               L=1'bz;
               ERR=1'bz;
               end
          endcase
     end
    end
   end
endmodule
