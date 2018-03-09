library verilog;
use verilog.vl_types.all;
entity mux8 is
    generic(
        width           : integer := 16
    );
    port(
        sel             : in     vl_logic_vector(2 downto 0);
        s1              : in     vl_logic_vector;
        s2              : in     vl_logic_vector;
        s3              : in     vl_logic_vector;
        s4              : in     vl_logic_vector;
        s5              : in     vl_logic_vector;
        s6              : in     vl_logic_vector;
        s7              : in     vl_logic_vector;
        s8              : in     vl_logic_vector;
        f               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end mux8;
