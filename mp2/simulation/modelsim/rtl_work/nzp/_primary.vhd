library verilog;
use verilog.vl_types.all;
entity nzp is
    generic(
        width           : integer := 16
    );
    port(
        a               : in     vl_logic_vector(2 downto 0);
        b               : in     vl_logic_vector(2 downto 0);
        f               : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end nzp;
