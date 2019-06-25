module booth_controlpath(LdA,LdQ,LdM,clrA,clrQ,clrff,sftA,sftQ,data_in,addsub,qm1,clk,q0,start,done,decr,ldcnt,eqz,reset);
	input [15:0] data_in;
	input qm1,q0,start,clk,eqz,reset;
	output reg LdA,LdM,LdQ,sftA,sftQ,clrA,clrQ,clrff,addsub,done,decr,ldcnt;
	
	reg [2:0] state;
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110;
	
	always@(posedge clk)
	begin
	  if(reset) state <= S0;
		else begin
		case(state)
			S0: if(start) state <= S1;
			S1: state <= S2;
			S2: #2 if({q0,qm1} == 2'b01) state <= S3;
			    else if({q0,qm1} == 2'b10) state <= S4;
					else state <= S5;
			S3: state <= S5;	
			S4: state <= S5;			
			S5: #2 if({q0,qm1} == 2'b01 && !eqz) state <= S3;
			    else if({q0,qm1} == 2'b10 && !eqz) state <= S4;
					else if(eqz) state <= S6;
			S6: state <= S6;
			default: state <= S0;

        endcase
        end
	end
	
	always@(state)
	begin
		case(state)
			S0: begin clrA = 0; LdA = 0; sftA = 0; clrQ = 0; LdQ = 0; sftQ = 0; LdM = 0; clrff= 0; done = 0; end
			S1: begin clrA = 1; clrff = 1; ldcnt = 1; LdM = 1; end
			S2: begin clrA = 0;clrff = 0; ldcnt = 0; LdM = 0; LdQ = 1; end
			S3: begin LdQ = 0; LdA = 1; addsub = 1; sftA = 0; sftQ = 0; decr =0; end
			S4: begin LdQ = 0; LdA = 1; addsub = 0; sftA = 0; sftQ = 0; decr =0; end
			S5: begin sftA = 1; sftQ = 1; LdA = 0; LdQ = 0; decr = 1; end
			S6: done = 1;
			default: begin clrA = 0; sftA = 0; LdQ = 0; sftQ = 0; end 
		endcase
	end
	
endmodule