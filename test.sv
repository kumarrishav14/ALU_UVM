class base_test extends uvm_test;
    `uvm_component_utils(base_test)
    
    //Component
    environment env;
    directed_seq dir_seq;
    random_seq rnd_seq;

    //Variable
    int f_id;

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
    `uvm_info(get_name(), "Starting Test Build", UVM_DEBUG)
    env = environment::type_id::create("env", this);
    dir_seq = directed_seq::type_id::create("dir_seq");
    rnd_seq = random_seq::type_id::create("rnd_seq");
    `uvm_info(get_name(), "Ending Test Build", UVM_DEBUG)
endfunction: build_phase

function void base_test::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    `uvm_info(get_name(), "Starting Elaboration", UVM_DEBUG)
    
    uvm_top.print_topology();
    f_id = $fopen("log.txt", "w");
    uvm_top.set_report_default_file_hier(f_id);
    `uvm_info(get_name(), "Ending Elaboration", UVM_DEBUG)
endfunction: end_of_elaboration_phase

task base_test::run_phase(uvm_phase phase);
    phase.raise_objection(this);
    dir_seq.start(env.agnt.seqr);
    rnd_seq.start(env.agnt.seqr);
    phase.drop_objection(this);
endtask: run_phase

function void base_test::final_phase(uvm_phase phase);
    super.final_phase(phase);
    $fclose(f_id);
endfunction: final_phase

// *********************** Dedicated Test Cases ***********************



