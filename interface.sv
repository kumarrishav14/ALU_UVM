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

interface alu_if(input bit clk);
    logic [7:0] OPA;
    logic [7:0] OPB;
    logic cin;
    logic ce;
    logic mode;
    logic [3:0] cmd = cmd;
    logic oflow, cout, g, e, l, err;
    logic [8:0] res;
    logic rst;
    
    clocking drv_cb@(posedge clk);
        output OPA, OPB, cin, ce, mode, cmd, rst;
    endclocking

    clocking ipmon_cb@(posedge clk);
        input OPA, OPB, cin, ce, mode, cmd;
    endclocking

    clocking opmon_cb@(posedge clk);
        input #0 oflow, cout, g, e, l, err, res;
    endclocking

    modport DRV(clocking drv_cb);
    modport IPMON(clocking ipmon_cb);
    modport OPMON(clocking opmon_cb);
endinterface //alu_if