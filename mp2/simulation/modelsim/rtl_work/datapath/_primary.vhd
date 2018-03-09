library verilog;
use verilog.vl_types.all;
library work;
entity datapath is
    port(
        clk             : in     vl_logic;
        pcmux_sel       : in     vl_logic_vector(2 downto 0);
        load_pc         : in     vl_logic;
        load_mdr        : in     vl_logic;
        load_mar        : in     vl_logic;
        load_ir         : in     vl_logic;
        load_cc         : in     vl_logic;
        load_regfile    : in     vl_logic;
        opcode          : out    work.lc3b_types.lc3b_opcode;
        aluop           : in     work.lc3b_types.lc3b_aluop;
        storemux_sel    : in     vl_logic;
        marmux_sel      : in     vl_logic_vector(2 downto 0);
        mdrmux_sel      : in     vl_logic;
        alumux_sel      : in     vl_logic_vector(2 downto 0);
        regfilemux_sel  : in     vl_logic_vector(2 downto 0);
        mem_rdata       : in     vl_logic_vector(15 downto 0);
        mem_wdata       : out    vl_logic_vector(15 downto 0);
        mem_address     : out    vl_logic_vector(15 downto 0);
        branch_enable   : out    vl_logic;
        immCheck        : out    vl_logic;
        r7_sel          : in     vl_logic;
        jsrCheck        : out    vl_logic;
        shf_a           : out    vl_logic;
        shf_d           : out    vl_logic
    );
end datapath;
