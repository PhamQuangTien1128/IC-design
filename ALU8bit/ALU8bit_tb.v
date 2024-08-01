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
        
        // Test Shift Left Logic
        Op = 4'b0011;
        a = 8'b11001100;
        b = 8'b00000110; // Shift by 6
        #10;
		  
        // Test Shift Right Logic
        Op = 4'b0100;
        a = 8'b11001100;
        b = 8'b00000101; // Shift by 5
        #10;
        
        // Test Shift Left Arithmetic
        Op = 4'b0101;
        a = 8'b11001100;
        b = 8'b00000010; // Shift by 2
        #10;

        // Test Shift Right Arithmetic
        Op = 4'b0110;
        a = 8'b11001100;
        b = 8'b00001000; // Shift by 8
        #10;

        // Test Rotate Left
        Op = 4'b0111;
        a = 8'b11001100;
        b = 8'b00000111; // Rotate by 7
        #10;

        // Test Rotate Right
        Op = 4'b1000;
        a = 8'b11001100;
        b = 8'b00001000; // Rotate by 8
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
