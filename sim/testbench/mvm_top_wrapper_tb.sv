`timescale 1ns / 1ps

module mvm_top_wrapper_tb();

    logic clk, clk_noc, rst_n;
    logic start_input, start_inst;
    wire data_received;
    
    // -------------------------------------------------------
    // 100MHz Clock
    // -------------------------------------------------------
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    // -------------------------------------------------------
    // 100MHz Clock
    // -------------------------------------------------------
    initial begin
        clk_noc = 0;
        forever begin
            #5 clk_noc = ~clk_noc;
        end
    end
    
    initial begin
    
       rst_n = 1'b0;
       #10 rst_n = 1'b1;
        
       #(60)
       @(posedge clk)
       start_input = 1;
       
       @(posedge clk)
       start_input = 0;
       
       @(posedge clk)
       start_inst = 1;
       
       @(posedge clk)
       start_inst = 0;
       
       wait (data_received == 1);
       #(100ns);
       $finish; 
    
    end
    
    mvm_top_wrapper top (
        .clk           (           clk ),
        .clk_noc       (       clk_noc ),
        .rst_n         (         rst_n ),
        .start_input   (   start_input ),  
        .start_inst    (    start_inst ),
        .data_received ( data_received )    
    );


endmodule: mvm_top_wrapper_tb
