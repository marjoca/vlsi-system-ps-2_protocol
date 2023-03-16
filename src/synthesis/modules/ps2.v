module ps2(input clk_50,
           input rst_n,
           input key_clock,
           input key_data,
           output [7:0] out_data,
           output [7:0] out_data1);
    
    reg [7:0] outdata_reg1, outdata_next1;
    assign out_data1 = outdata_reg1;
    
    
    
    integer index_reg, index_next;
    reg [10:0] outdata_reg, outdata_next;
    
    assign out_data = outdata_reg[8:1];
    
    
    reg [1:0] state_reg, state_next;
    localparam load = 1;
    localparam stop = 2;
    
    always @(posedge clk_50, negedge rst_n) begin
        if (!rst_n) begin
            
            index_reg    <= 0;
            outdata_reg  <= 11'd0;
            outdata_reg1 <= 11'd0;
            
            state_reg <= stop;
        end
        else begin
            
            index_reg    <= index_next;
            outdata_reg  <= outdata_next;
            outdata_reg1 <= outdata_next1;
            
            state_reg <= state_next;
        end
    end
    
    always @(negedge key_clock) begin
        
        index_next    = index_reg;
        outdata_next  = outdata_reg;
        outdata_next1 = outdata_reg1;
        
        state_next = state_reg;
        
        
        case (state_reg)
            load: begin
                
                outdata_next[index_reg] = key_data;
                index_next              = index_reg + 1;
                
                if (index_next == 10)begin
                    
                    if (outdata_next[0]||(^outdata_next[8:1]) == outdata_next[9]) begin
                        //error
                        outdata_next[8:1] = 8'b00000000;
                        
                    end
                end
                
                if (index_next == 11) begin
                    state_next = stop;
                    index_next = 0;
                    
                    if (!outdata_next[10]) begin
                        //error
                        outdata_next[8:1] = 8'b00000000;
                        
                    end
                    
                    
                end
            end
            
            stop: begin
                
                outdata_next1 = outdata_reg[8:1];
                
                if (!key_data) begin
                    outdata_next[index_reg] = key_data;
                    index_next              = index_reg + 1;
                    state_next              = load;
                end
                
            end
            
            
        endcase
        
    end
    
    
endmodule
    
