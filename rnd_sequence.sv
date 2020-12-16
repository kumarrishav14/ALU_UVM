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
class random_seq extends uvm_sequence#(transaction);
    `uvm_object_utils(random_seq)

    transaction trans;
    int no_rnd_test_cases;
   
    function new(string name = "rnd_seq");
        super.new(name);
        trans = transaction::type_id::create("trans");
        if(!uvm_config_db#(int)::get(null, "seq.*", "no_rnd", no_rnd_test_cases)) begin
            `uvm_warning(get_type_name(), "Config for no. of random cases not found. Running default 200 no. of random cases")
            no_rnd_test_cases = 200;
        end
    endfunction //new()
 
    task pre_body();
    endtask

    task body();
        for (int i=0; i < no_rnd_test_cases; i++) begin
            start_item(trans);
            if(!trans.randomize())
                `uvm_fatal(get_type_name(), "Randomization failed")
            
            trans.isRandom  = 1;
            finish_item(trans);
            `uvm_info("RND_SEQ", "Sent packet", UVM_HIGH)
        end
    endtask
endclass //directed_seq extends uvm_sequence