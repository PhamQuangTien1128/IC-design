module ALU8bit_tb;
    // Testbench signals
    reg [7:0] a, b;
    reg [3:0] Op;
    wire [7:0] result;
    wire [15:0] product;
    wire OF, zero, slt;
    
    // Instantiate the ALU
    ALU8bit uut (
        .a(a),
        .b(b),
        .Op(Op),
        .result(result),
        .product(product),
        .OF(OF),
        .zero(zero),
        .slt(slt)
    );
    
    // Test procedure
    initial begin
        // Monitor changes
        $monitor("Time = %0t, a = %b, b = %b, Op = %b, result = %b, product = %b, OF = %b, zero = %b, slt = %b",
                 $time, a, b, Op, result, product, OF, zero, slt);
        
        // Test case 1: Inverter operation
        a = 8'b10101010; b = 8'b00000000; Op = 4'd0;
        #10;
        
        // Test case 2: AND operation
        a = 8'b11001100; b = 8'b10101010; Op = 4'd1;
        #10;
        
        // Test case 3: OR operation
        a = 8'b11001100; b = 8'b10101010; Op = 4'd2;
        #10;
        
        // Test case 4: Shift right logical
        a = 8'b11110000; b = 8'b00000000; Op = 4'd3;
        #10;
        
        // Test case 5: Shift left logical
        a = 8'b11110000; b = 8'b00000000; Op = 4'd4;
        #10;
        
        // Test case 6: Shift right arithmetic
        a = 8'b11110000; b = 8'b00000000; Op = 4'd5;
        #10;
        
        // Test case 7: Shift left arithmetic
        a = 8'b11110000; b = 8'b00000000; Op = 4'd6;
        #10;
        
        // Test case 8: Rotate right
        a = 8'b11001001; b = 8'b00000000; Op = 4'd7;
        #10;
        
        // Test case 9: Rotate left
        a = 8'b11001001; b = 8'b00000000; Op = 4'd8;
        #10;
        
        // Test case 10: Add operation
        a = 8'b00001111; b = 8'b00000001; Op = 4'd9;
        #10;
		  
		  // Test case 10: Add operation
        a = 8'b10000000; b = 8'b10000000; Op = 4'd9;
        #10;
        
        // Test case 11: Subtract operation
        a = 8'b00001111; b = 8'b00000001; Op = 4'd10;
        #10;
		  
		  // Test case 11: Subtract operation
        a = 8'b00001111; b = 8'b01001000; Op = 4'd10;
        #10;
        
        // Test case 12: Multiply operation
        a = 8'b00000011; b = 8'b00000101; Op = 4'd11;
        #10;
		  
		  // Test case 12: Multiply operation
        a = 8'b01000110; b = 8'b10000001; Op = 4'd11;
        #10;
		  
		  //Set Zero
		  Op = 4'd15;
        #10;
		  
        // End of simulation
        $finish;
    end
endmodule
