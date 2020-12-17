`include "package.svh"
`include "Eight_bit_ALU_rtl_design.v"

module top ();
    bit clk;

    always #5 clk = ~clk;

    alu_if intf(clk);

    //DUT Instanciation
    Eight_bit_ALU_rtl_design dut (.OPA(intf.OPA),.OPB(intf.OPB),.CIN(intf.cin),.CLK(clk), .OFLOW(intf.oflow),
                                    .RST(intf.rst),.CMD(intf.cmd),.CE(intf.ce),.MODE(intf.mode),.COUT(intf.cout),
                                    .RES(intf.res),.G(intf.g),.E(intf.e),.L(intf.l),.ERR(intf.err));

    //agent agnt;

    int no_dir, no_rnd;
    initial begin
        //agnt = agent::type_id::create("agnt", null);
        no_dir = 84;
        no_rnd = 100;
        uvm_config_db#(int)::set(null, "seq.*", "no_dir", no_dir);
        uvm_config_db#(int)::set(null, "seq.*", "no_rnd", no_rnd);
        uvm_config_db#(string)::set(null, "seq.*", "file_name", "new_stimulus.txt");
        uvm_config_db#(virtual alu_if)::set(null, "*", "vif", intf);

        run_test("base_test");
    end
endmodule