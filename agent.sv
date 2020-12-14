import uvm_pkg::*;
class agent extends uvm_agent;
    `uvm_component_utils(agent)

    directed_seq dir_seq;
    random_seq rnd_seq;
    uvm_sequencer#(transaction) seqr;
    driver drv;
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        dir_seq = directed_seq::type_id::create("dir_seq");
        rnd_seq = random_seq::type_id::create("rnd_seq");

        seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
        drv = driver::type_id::create("drv", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        dir_seq.start(seqr);
        rnd_seq.start(seqr);
        phase.drop_objection(this);
    endtask
endclass //agent extends uvm_agent