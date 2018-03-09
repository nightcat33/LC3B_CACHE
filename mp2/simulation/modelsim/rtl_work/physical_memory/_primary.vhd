library verilog;
use verilog.vl_types.all;
entity physical_memory is
    generic(
        DELAY_MEM       : integer := 200
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DELAY_MEM : constant is 1;
end physical_memory;
