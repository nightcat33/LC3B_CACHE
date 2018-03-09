library verilog;
use verilog.vl_types.all;
entity \Array\ is
    generic(
        width           : integer := 128
    );
    port(
        clk             : in     vl_logic;
        address         : in     vl_logic_vector(2 downto 0);
        datain          : in     vl_logic_vector;
        writeEnable     : in     vl_logic;
        dataout         : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end \Array\;
