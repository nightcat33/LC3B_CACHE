library verilog;
use verilog.vl_types.all;
library work;
entity ir is
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        \in\            : in     vl_logic_vector(15 downto 0);
        opcode          : out    work.lc3b_types.lc3b_opcode;
        dest            : out    vl_logic_vector(2 downto 0);
        src1            : out    vl_logic_vector(2 downto 0);
        src2            : out    vl_logic_vector(2 downto 0);
        offset6         : out    vl_logic_vector(5 downto 0);
        offset9         : out    vl_logic_vector(8 downto 0);
        offset11        : out    vl_logic_vector(10 downto 0);
        imm5            : out    vl_logic_vector(4 downto 0);
        immCheck        : out    vl_logic;
        jsrCheck        : out    vl_logic;
        shf_a           : out    vl_logic;
        shf_d           : out    vl_logic;
        imm4            : out    vl_logic_vector(3 downto 0);
        trapvect        : out    vl_logic_vector(7 downto 0)
    );
end ir;
