module motherboard (
    input clk,              // Ana saat sinyali
    input reset,            // Sistem sıfırlama
    input [7:0] io_in,      // Harici giriş
    output [7:0] io_out     // Harici çıkış
);

    // Veri yolları
    wire [15:0] address;
    wire [7:0] data_in, data_out;
    wire mem_read, mem_write;

    // CPU modülü
    cpu CPU (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .data_out(data_out),
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write)
    );

    // Bellek (RAM ve ROM)
    memory MEM (
        .clk(clk),
        .address(address),
        .data_in(data_out),
        .data_out(data_in),
        .mem_read(mem_read),
        .mem_write(mem_write)
    );

    // I/O modülü
    assign io_out = data_in; // Basit bir I/O örneği

endmodule
module memory (
    input clk,
    input [15:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out,
    input mem_read,
    input mem_write
);

    reg [7:0] ram [0:255];  // 256 baytlık RAM
    reg [7:0] rom [0:255];  // 256 baytlık ROM

    initial begin
        // ROM içeriğini başlat
        rom[0] = 8'hAA;  // Örnek başlangıç değeri
        rom[1] = 8'hBB;
    end

    always @(posedge clk) begin
        if (mem_read) begin
            data_out <= (address < 256) ? ram[address] : rom[address - 256];
        end
        if (mem_write && address < 256) begin
            ram[address] <= data_in;  // Sadece RAM yazılabilir
        end
    end
endmodule
module cpu (
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [15:0] address,
    output reg mem_read,
    output reg mem_write
);

    reg [7:0] accumulator;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            address <= 0;
            mem_read <= 1;
            mem_write <= 0;
        end else begin
            // Örnek bir işlem: RAM'den oku, topla ve geri yaz
            address <= address + 1;
            mem_read <= 1;
            data_out <= accumulator + data_in;
            mem_write <= 1;
        end
    end
endmodule
