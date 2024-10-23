`include "/home/advent2/Simple_NoC/sim/parameters.sv"

module mvm_top_wrapper (
    input logic clk, 
    input logic clk_noc,
    input logic rst_n,
    input logic start_input,
    input logic start_inst,
    output wire data_received
    );
    logic             axis_s_tvalid;
    logic [ DATAW-1:0] axis_s_tdata;
    logic [  IDW-1:0] axis_s_tid;
    logic [DESTW-1:0] axis_s_tdest;
    logic [USERW-1:0] axis_s_tuser;
    logic             axis_s_tlast;
    wire              axis_s_tready;
    
    wire              axis_m_tvalid;
    wire [ DATAW-1:0]  axis_m_tdata;
    wire [  IDW-1:0]  axis_m_tid;
    wire [DESTW-1:0]  axis_m_tdest;
    wire [USERW-1:0]  axis_m_tuser;
//  wire              axis_m_tlast;
    logic             axis_m_tready = 1;
    
    always @(posedge clk) begin

        // -----------------------------------------------------------------------------
        // Load an Input vector 1 to router 1
        // -----------------------------------------------------------------------------
        if (start_input) begin
    
            axis_s_tvalid <= 1;
            axis_s_tdata <= 512'h01010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101;

            axis_s_tuser[8:0  ] <=   9'b0;
            axis_s_tuser[10:9 ] <=  2'b10;
            axis_s_tuser[74:11] <=  64'b0;
            axis_s_tdest <= 12'h001;
            axis_s_tlast <= 1;
        
        end else if (start_inst) begin

            // -----------------------------------------------------------------------------
            // Test case: Load first MVM instruction router 1 set to accumulate
            // -----------------------------------------------------------------------------
            axis_s_tvalid <= 1;
            axis_s_tdata[    0] <= 1'b0; // RDC
            axis_s_tdata[    1] <= 1'b1; // ACM EN
            axis_s_tdata[    2] <= 1'b1; // RLS
            axis_s_tdata[    3] <= 1'b1; // LST
            axis_s_tdata[ 12:4] <= 9'b0; // ACCUM_ADDR
            axis_s_tdata[21:13] <= 9'h1; // RF_ADDR
            axis_s_tdata[30:22] <= 9'h3; // RLS_DEST
            axis_s_tdata[   31] <= 1'b1; // RLS_OP

            axis_s_tuser[8:0  ] <=  9'b0;
            axis_s_tuser[10:9 ] <=  2'b0;
            axis_s_tuser[74:11] <= 64'b0;
            axis_s_tlast = 1;
            axis_s_tdest = 12'h001;
        
        end else begin 
        
            axis_s_tvalid <= 0;
            axis_s_tdata <= 0;
            axis_s_tlast <= 0;
        
        end
    end

    mvm_top top (

        .CLK           (           clk ),
        .CLK_NOC       (       clk_noc ),
        .RST_N         (         rst_n ),
        .AXIS_S_TVALID ( axis_s_tvalid ),
        .AXIS_S_TREADY ( axis_s_tready ),
        .AXIS_S_TDATA  (  axis_s_tdata ),
        .AXIS_S_TLAST  (  axis_s_tlast ),
        .AXIS_S_TID    (    axis_s_tid ),
        .AXIS_S_TUSER  (  axis_s_tuser ),
        .AXIS_S_TDEST  (  axis_s_tdest ),
        .AXIS_M_TVALID ( axis_m_tvalid ),
        .AXIS_M_TREADY ( axis_m_tready ),
        .AXIS_M_TDATA  (  axis_m_tdata ),
        .AXIS_M_TLAST  (  data_received),
        .AXIS_M_TID    (    axis_m_tid ),
        .AXIS_M_TUSER  (  axis_m_tuser ),
        .AXIS_M_TDEST  (  axis_m_tdest )
    );


endmodule: mvm_top_wrapper
