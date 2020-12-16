import uvm_pkg::*;
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    uvm_sequencer#(transaction) seqr;
    driver drv;
    monitor mon;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
        drv = driver::type_id::create("drv", this);
        mon = monitor::type_id::create("mon", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass //agent extends uvm_agent