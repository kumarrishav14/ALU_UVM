class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    // Variable
    uvm_analysis_imp#(transaction, this) ap_export;
    transaction act_trans, exp_trans;

    function void write(transaction act_trans);
        this.act_trans = act_trans;
        `uvm_info("scoreboard", $sformatf("Received Packet:: %s", act_trans.convert2string()), UVM_HIGH)
        
    endfunction
    // Constructor:new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    
endclass //scoreboard extends uvm_scoreboard

function void scoreboard::build_phase(uvm_phase phase);

    ap_export = new("ap_export", this);
endfunction: build_phase
