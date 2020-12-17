import uvm_pkg::*;

class fun_cov extends uvm_subscriber#(transaction);
    `uvm_component_utils(fun_cov)

    // Variables
    transaction trans;

    // Covergroup for the functional coverage
    covergroup alu_cov;
        option.per_instance = 1;
        OPA: coverpoint trans.OPA { bins opa[16] = { [0:255] }; }
        OPB: coverpoint trans.OPB { bins opb[16] = { [0:255] }; }
        MODE: coverpoint trans.mode { bins m[] = {0, 1}; }
        CMD: coverpoint trans.cmd { bins c[] = { [0:13] }; }
        CE: coverpoint trans.ce { bins c_e[] = {0, 1}; }
        CIN: coverpoint trans.cin { bins c_in[] = {0, 1}; }

        MODExCMD: cross MODE, CMD;
    endgroup //alu_cov
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        alu_cov = new();
    endfunction //new()

    function void write(T t);
        trans = t;
        alu_cov.sample();
    endfunction
endclass //fun_cov extends uvm_subscriber