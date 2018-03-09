library verilog;
use verilog.vl_types.all;
entity Comparator is
    port(
        a               : in     vl_logic_vector(8 downto 0);
        b               : in     vl_logic_vector(8 downto 0);
        result          : out    vl_logic
    );
end Comparator;
