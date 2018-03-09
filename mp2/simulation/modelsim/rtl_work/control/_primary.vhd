library verilog;
use verilog.vl_types.all;
library work;
entity control is
    port(
        m_cyc           : out    vl_logic;
        m_stb           : out    vl_logic;
        clk             : in     vl_logic;
        opcode          : in     work.lc3b_types.lc3b_opcode;
        load_pc         : out    vl_logic;
        load_ir         : out    vl_logic;
        load_regfile    : out    vl_logic;
        aluop           : out    work.lc3b_types.lc3b_aluop;
        mem_resp        : in     vl_logic;
        mem_write       : out    vl_logic;
        mem_byte_enable : out    vl_logic_vector(1 downto 0);
        branch_enable   : in     vl_logic;
        load_mdr        : out    vl_logic;
        load_mar        : out    vl_logic;
        load_cc         : out    vl_logic;
        pcmux_sel       : out    vl_logic_vector(2 downto 0);
        storemux_sel    : out    vl_logic;
        alumux_sel      : out    vl_logic_vector(2 downto 0);
        regfilemux_sel  : out    vl_logic_vector(2 downto 0);
        marmux_sel      : out    vl_logic_vector(2 downto 0);
        mdrmux_sel      : out    vl_logic;
        immCheck        : in     vl_logic;
        r7_sel          : out    vl_logic;
        jsrCheck        : in     vl_logic;
        mem_address     : in     vl_logic_vector(15 downto 0);
        shf_a           : in     vl_logic;
        shf_d           : in     vl_logic
    );
end control;
