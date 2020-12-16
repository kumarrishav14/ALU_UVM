class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    // Variable
    uvm_analysis_imp#(transaction, scoreboard) ap_export;
    reference_model rm;
    transaction act_trans, exp_trans;

    function void check();
        if (act_trans.compare(exp_trans)) begin
            `uvm_info("SCB", $sformatf("%s\nStatus:: PASSED", act_trans.convert2string()), UVM_NONE)
        end
        else begin
            `uvm_error("SCB", $sformatf("%s\nStatus:: FAILED", act_trans.convert2string()))
        end
    endfunction
    
    // Constructor:new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);

    //  Function: write
    extern function void write(transaction trans);
    
endclass //scoreboard extends uvm_scoreboard

function void scoreboard::build_phase(uvm_phase phase);
    ap_export = new("ap_export", this);
    rm = reference_model::type_id::create("rm", this);
    act_trans = new("act_trans");
endfunction: build_phase

function void scoreboard::write(transaction trans);
    act_trans.copy(trans);
    `uvm_info("scoreboard", $sformatf("Received Packet:: %s", act_trans.convert2string()), UVM_HIGH)
    exp_trans = rm.get_ref_val(trans);
    check();
    // act_trans.print();
    // exp_trans.print();
endfunction: write
