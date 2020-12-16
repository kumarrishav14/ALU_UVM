class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    // Variables
    virtual alu_if.MON intf;
    uvm_analysis_port#(transaction) ap;
    transaction trans;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    
    //  Function: run_phase
    extern task run_phase(uvm_phase phase);
    
endclass //monitor extends uvm_monitor

function void monitor::build_phase(uvm_phase phase);
    /*  note: Do not call super.build_phase() from any class that is extended from an UVM base class!  */
    /*  For more information see UVM Cookbook v1800.2 p.503  */
    //super.build_phase(phase);

    ap = new("ap", this);
    if(!uvm_config_db#(virtual alu_if)::get(this, "*", "vif", intf))
        `uvm_fatal(get_name(), "Cant get virtual interface");
    trans = new("trans");
endfunction: build_phase

task monitor::run_phase(uvm_phase phase);
    forever begin
        @(intf.mon_cb);
        @(intf.mon_cb);
        trans.OPA   = intf.mon_cb.OPA;
        trans.OPB   = intf.mon_cb.OPB;
        trans.cin   = intf.mon_cb.cin;
        trans.ce    = intf.mon_cb.ce;
        trans.mode  = intf.mon_cb.mode;
        trans.cmd   = intf.mon_cb.cmd;
        trans.res   = intf.mon_cb.res;
        trans.oflow = intf.mon_cb.oflow;
        trans.cout  = intf.mon_cb.cout;
        trans.egl   = { intf.mon_cb.e, intf.mon_cb.g, intf.mon_cb.l };
        trans.err   = intf.mon_cb.err;
        `uvm_info("MON", $sformatf("Sampled Packet is %s", trans.convert2string), UVM_MEDIUM)
        ap.write(trans);
    end
endtask: run_phase

