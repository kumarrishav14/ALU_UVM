class environment extends uvm_env;
    `uvm_component_utils(environment)
    
    // Components
    agent agnt;
    scoreboard scb;
    fun_cov fc;

    // Constructor:new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    
    //  Function: connect_phase
    extern function void connect_phase(uvm_phase phase);

    //  Function: end_of_elaboration_phase
    extern function void end_of_elaboration_phase(uvm_phase phase);  
endclass //environment extends uvm_environment

// ********************* Implementations **********************
function void environment::build_phase(uvm_phase phase);
    dir_seq = directed_seq::type_id::create("dir_seq");
    rnd_seq = random_seq::type_id::create("rnd_seq");
    agnt = agent::type_id::create("agnt", this);
    scb = scoreboard::type_id::create("scb", this);
    fc = fun_cov::type_id::create("fc", this);
endfunction: build_phase

function void environment::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agnt.mon.ap.connect(scb.ap_export);
    agnt.mon.ap.connect(fc.analysis_export);
endfunction: connect_phase

function void environment::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    scb.set_report_id_action("SCB", UVM_LOG | UVM_DISPLAY);
endfunction: end_of_elaboration_phase



