class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    //Component
    environment env;
    directed_seq dir_seq;
    random_seq rnd_seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    //  Function: build_phase
    extern function void build_phase(uvm_phase phase);
    
    //  Function: end_of_elaboration_phase
    extern function void end_of_elaboration_phase(uvm_phase phase);
    
    //  Function: run_phase
    extern task run_phase(uvm_phase phase);
    
    //  Function: final_phase
    extern function void final_phase(uvm_phase phase);
    
endclass //base_test extends uvm_test

function void base_test::build_phase(uvm_phase phase);
    env = environment::type_id::create("env", this);
    dir_seq = new("dir_seq");
    rnd_seq = new("rnd_seq");
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
    int f_id;
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    f_id = $fopen("log.txt", "w");
    uvm_top.set_report_default_file_hier(f_id);
endfunction: end_of_elaboration_phase

task base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    dir_seq.start(agnt.seqr);
    // rnd_seq.start(agnt.seqr);
    phase.drop_objection(this);
endtask: run_phase

function void base_test::final_phase(uvm_phase phase);
    super.final_phase(phase);
    $fclose(f_id);
endfunction: final_phase

// *********************** Dedicated Test Cases ***********************



