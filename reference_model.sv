class reference_model extends uvm_component;
    `uvm_component_utils(reference_model)
    
    // Variables
    transaction temp;

    // Constructor: new
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction //new()

    function transaction get_ref_val(transaction rcvd_trans);
        logic [7:0] OPA_1, OPB_1;
        if(rcvd_trans.ce) begin
            if(rcvd_trans.mode) begin
                rcvd_trans.egl = 'z;
                rcvd_trans.res = 'z; 
                rcvd_trans.cout = 'z;
                rcvd_trans.err = 'z;
                rcvd_trans.oflow = 'z;
                case (rcvd_trans.cmd)
                    0: begin
                        rcvd_trans.res = rcvd_trans.OPA + rcvd_trans.OPB;
                        rcvd_trans.cout = rcvd_trans.res[8] ? 1 : 0;
                    end 
                    1: begin
                        rcvd_trans.res = rcvd_trans.OPA - rcvd_trans.OPB;
                        rcvd_trans.oflow = rcvd_trans.OPA < rcvd_trans.OPB ? 1 : 0;
                    end
                    2: begin
                        rcvd_trans.res = rcvd_trans.OPA + rcvd_trans.OPB + rcvd_trans.cin;
                        rcvd_trans.cout = rcvd_trans.res[8] ? 1 : 0;
                    end
                    3: begin
                        rcvd_trans.res = rcvd_trans.OPA - rcvd_trans.OPB - rcvd_trans.cin;
                        rcvd_trans.oflow = rcvd_trans.OPA < (rcvd_trans.OPB + rcvd_trans.cin) ? 1 : 0;
                    end 
                    4: rcvd_trans.res = rcvd_trans.OPA + 1;
                    5: rcvd_trans.res = rcvd_trans.OPA - 1;
                    6: rcvd_trans.res = rcvd_trans.OPB + 1;
                    7: rcvd_trans.res = rcvd_trans.OPB - 1;
                    8: begin
                        rcvd_trans.res = 'z;
                        if(rcvd_trans.OPA > rcvd_trans.OPB)
                            rcvd_trans.egl = 3'bz1z;
                        else if(rcvd_trans.OPA < rcvd_trans.OPB)
                            rcvd_trans.egl = 3'bzz1;
                        else
                            rcvd_trans.egl = 3'b1zz;
                    end
                    default: begin
                        rcvd_trans.egl = 'z;
                        rcvd_trans.res = 'z; 
                        rcvd_trans.cout = 'z;
                        rcvd_trans.err = 'z;
                        rcvd_trans.oflow = 'z;
                    end
                endcase
            end
            else begin
                rcvd_trans.egl = 'z;
                rcvd_trans.res = 'z; 
                rcvd_trans.cout = 'z;
                rcvd_trans.err = 'z;
                rcvd_trans.oflow = 'z;
                case (rcvd_trans.cmd)
                    0: rcvd_trans.res = {1'b0, rcvd_trans.OPA & rcvd_trans.OPB};
                    1: rcvd_trans.res = {1'b0, ~(rcvd_trans.OPA & rcvd_trans.OPB)};
                    2: rcvd_trans.res = {1'b0, rcvd_trans.OPA | rcvd_trans.OPB};
                    3: rcvd_trans.res = {1'b0, ~(rcvd_trans.OPA | rcvd_trans.OPB)}; 
                    4: rcvd_trans.res = {1'b0, rcvd_trans.OPA ^ rcvd_trans.OPB};
                    5: rcvd_trans.res = {1'b0, ~(rcvd_trans.OPA ^ rcvd_trans.OPB)};
                    6: rcvd_trans.res = {1'b0, ~rcvd_trans.OPA};
                    7: rcvd_trans.res = {1'b0, ~rcvd_trans.OPB};
                    8: rcvd_trans.res = {1'b0, rcvd_trans.OPA >> 1};
                    9: rcvd_trans.res = {1'b0, rcvd_trans.OPA << 1};
                    10: rcvd_trans.res = {1'b0, rcvd_trans.OPB >> 1};
                    11: rcvd_trans.res = {1'b0, rcvd_trans.OPB << 1};
                    12: begin
                        if(rcvd_trans.OPB[0])
                            OPA_1 = {rcvd_trans.OPA[6:0], rcvd_trans.OPA[7]};
                        else
                            OPA_1 = rcvd_trans.OPA;

                        if(rcvd_trans.OPB[1])
                            OPB_1 =  {OPA_1[5:0], OPA_1[7:6]}; 
                        else
                            OPB_1= OPA_1;

                        if(rcvd_trans.OPB[2])
                            rcvd_trans.res =  {OPB_1[3:0], OPB_1[7:4]} ;
                        else
                            rcvd_trans.res = OPB_1;

                        if(rcvd_trans.OPB[3] | rcvd_trans.OPB[4] | rcvd_trans.OPB[5] | rcvd_trans.OPB[6] | rcvd_trans.OPB[7])
                            rcvd_trans.err = 1'b1;
                    end
                    13: begin
                        if(rcvd_trans.OPB[0])
                            OPA_1 = {rcvd_trans.OPA[0], rcvd_trans.OPA[7:1]};
                        else
                            OPA_1 = rcvd_trans.OPA;

                        if(rcvd_trans.OPB[1])
                            OPB_1 =  {OPA_1[1:0], OPA_1[7:2]}; 
                        else
                            OPB_1= OPA_1;

                        if(rcvd_trans.OPB[2])
                            rcvd_trans.res =  {OPB_1[3:0], OPB_1[7:4]} ;
                        else
                            rcvd_trans.res = OPB_1;

                        if(rcvd_trans.OPB[3] | rcvd_trans.OPB[4] | rcvd_trans.OPB[5] | rcvd_trans.OPB[6] | rcvd_trans.OPB[7])
                            rcvd_trans.err = 1'b1;
                    end
                    default: begin
                        rcvd_trans.egl = 'z;
                        rcvd_trans.res = 'z; 
                        rcvd_trans.cout = 'z;
                        rcvd_trans.err = 'z;
                        rcvd_trans.oflow = 'z;
                    end
                endcase
            end
            $cast(temp, rcvd_trans.clone);
        end
        else begin
            rcvd_trans.egl = temp.egl;
            rcvd_trans.res = temp.res; 
            rcvd_trans.cout = temp.cout;
            rcvd_trans.err = temp.err;
            rcvd_trans.oflow = temp.oflow;
        end
        
        `uvm_info("RM", $sformatf("Generated Expected Packet:: %s", rcvd_trans.convert2string()), UVM_HIGH)
        
        return rcvd_trans;
    endfunction
endclass //reference_model extends uvm_component