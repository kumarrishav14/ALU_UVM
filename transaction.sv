/* MIT License

Copyright (c) 2020 Rishav Kumar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)
     // Inputs to DUT
    rand logic [7:0] OPA, OPB;
    rand logic cin, mode, ce;
    rand logic [3:0] cmd;

    constraint cmd_val { 
        if (mode == 1) 
            cmd inside { [0:9] };
        else
            cmd inside { [0:13] };
    };
    constraint ce_dist { ce dist { 1 := 9, 0 := 1 }; }

    // Ouput from DUT
    logic [2:0] egl;
    logic [8:0] res; 
    logic cout, err, oflow;

    static bit [7:0] trans_ID;    // Transaction ID
    static bit isRandom;            // Control bit

    function new(string name = "trans");
        super.new(name);
        init_val();
    endfunction //new()

    function void pre_randomize();
        trans_ID++;
    endfunction

    // Helper functions
    function void init_val();
        OPA = 'z;
        OPB = 'z;
        cin = 'z;
        cmd = 'z;
        ce = 'z;
        //r_bit = 'z;
        mode = 'z;
        egl = 'z;
        res = 'z;
        cout = 'z;
        err = 'z;
        oflow = 'z;
    endfunction

    function void do_print(uvm_printer printer);
        $display("Transaction ID: %0d", trans_ID);
        printer.print_field("OPA", OPA, 8, UVM_UNSIGNED);
        printer.print_field("OPB", OPB, 8, UVM_UNSIGNED);
        printer.print_field("Mode", mode, 1, UVM_BIN);
        printer.print_field("CMD", cmd, 4, UVM_BIN);
        printer.print_field("CE", ce, 1, UVM_BIN);
        printer.print_field("Result", res, 9, UVM_UNSIGNED);
        printer.print_field("cout", cout, 1, UVM_BIN);
        printer.print_field("err", err, 1, UVM_BIN);
        printer.print_field("oflow", oflow, 1, UVM_BIN);
        printer.print_field("EGL", egl, 3, UVM_BIN);
    endfunction                         

    function string convert2string();
        string s;
        s = $sformatf("Packet ID: %0d", trans_ID);
        s = $sformatf("%s\nInput: OPA = %b, OPB = %b, cin = %b, cmd = %b, mode = %b, ce = %b, ",
                s, OPA, OPB, cin, cmd, mode, ce);
        s = $sformatf("%s\nOuput: result = %b, cout = %b, err = %b, oflow = %b, EGL = %b",
                s, res, cout, err, oflow, egl);
        return s;
    endfunction

    function bit do_compare(uvm_object rhs, uvm_comparer comparer);
        transaction _rhs;
        bit cmp;
        if(!$cast(_rhs, rhs))
            `uvm_fatal(get_type_name(), "object passed is not compatible with Transaction");
        
        cmp = this.egl === _rhs.egl & this.res === _rhs.res & cout === _rhs.cout 
            & err === _rhs.err & oflow === _rhs.oflow;
        return cmp;
    endfunction

    function void do_copy(uvm_object rhs);
        transaction _rhs;
        if(!$cast(_rhs, rhs))
            `uvm_fatal(get_type_name(), "rhs is not compatible with this class");
        
        OPA = _rhs.OPA;
        OPB = _rhs.OPB;
        cin = _rhs.cin;
        cmd = _rhs.cmd;
        ce = _rhs.ce;
        mode = _rhs.mode;
        egl = _rhs.egl;
        res = _rhs.res;
        cout = _rhs.cout;
        err = _rhs.err;
        oflow = _rhs.oflow;
    endfunction
endclass //transaction extends uvm_sequence_item