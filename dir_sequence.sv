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
SOFTWARE.
 */
import uvm_pkg::*;

class directed_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(directed_seq)

    transaction trans;
    int no_dir_test_cases;
    string file_name;
    bit skip_dir_cases;
    logic [47:0] test_case_mem [];
    function new(string name = "dir_seq");
        super.new(name);
        trans = transaction::type_id::create("trans");
        if(!uvm_config_db#(int)::get(null, "seq.*", "no_dir", no_dir_test_cases)) begin
            `uvm_warning(get_type_name(), "No of Directed cases not found. SKIPPING DRECTED CASES")
            skip_dir_cases = 1;
        end
        if(!uvm_config_db#(string)::get(null, "seq.*", "file_name", file_name)) begin
            `uvm_warning(get_type_name(), "File name not found. SKIPPING DRECTED CASES")
            skip_dir_cases = 1;
        end
        test_case_mem = new[no_dir_test_cases];
    endfunction //new()
 
    task pre_body();
        if(skip_dir_cases)
            return;
        $readmemb(file_name, test_case_mem);
    endtask

    task body();
        if(skip_dir_cases)
            return;
        for (int i=0; i<no_dir_test_cases; i++) begin
            start_item(trans);
            trans.trans_ID      =test_case_mem[i][47:40];
            //trans.r_bit		=test_case_mem[i][39:38];
            trans.OPA			=test_case_mem[i][37:30];
            trans.OPB			=test_case_mem[i][29:22];
            trans.cmd	        =test_case_mem[i][21:18];
            trans.cin	        =test_case_mem[i][17];
            trans.ce  	 	    =test_case_mem[i][16];
            trans.mode	        =test_case_mem[i][15];
            trans.res           =test_case_mem[i][14:6];
            trans.cout 	        =test_case_mem[i][5];	
            trans.egl           =test_case_mem[i][4:2]; 
            trans.oflow 	    =test_case_mem[i][1];	
            trans.err           =test_case_mem[i][0];
            trans.isRandom      =0;
            finish_item(trans);
            `uvm_info("DIR_SEQ", "Sent packet", UVM_HIGH)
            
        end
    endtask
endclass //directed_seq extends uvm_sequence