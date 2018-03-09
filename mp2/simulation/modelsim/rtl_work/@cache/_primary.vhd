library verilog;
use verilog.vl_types.all;
entity Cache is
    port(
        rdata           : in     vl_logic_vector(127 downto 0);
        address         : out    vl_logic_vector(11 downto 0);
        wdata           : out    vl_logic_vector(127 downto 0);
        physocal_mem_write: out    vl_logic;
        m_retry         : in     vl_logic;
        m_ack           : in     vl_logic;
        m_cyc           : out    vl_logic;
        m_stb           : out    vl_logic;
        sel             : out    vl_logic_vector(15 downto 0)
    );
end Cache;
