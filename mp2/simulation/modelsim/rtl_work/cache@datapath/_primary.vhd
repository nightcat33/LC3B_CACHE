library verilog;
use verilog.vl_types.all;
entity cacheDatapath is
    port(
        clk             : in     vl_logic;
        mem_address     : in     vl_logic_vector(11 downto 0);
        mem_wdata       : in     vl_logic_vector(127 downto 0);
        sel_signal      : in     vl_logic_vector(15 downto 0);
        mem_rdata       : out    vl_logic_vector(127 downto 0);
        rdata           : in     vl_logic_vector(127 downto 0);
        address         : out    vl_logic_vector(11 downto 0);
        wdata           : out    vl_logic_vector(127 downto 0);
        hitA            : out    vl_logic;
        hitB            : out    vl_logic;
        loadLRU         : in     vl_logic;
        loadValidBitArrayA: in     vl_logic;
        loadValidBitArrayB: in     vl_logic;
        loadTagArrayA   : in     vl_logic;
        loadTagArrayB   : in     vl_logic;
        loadDirtyBitArrayA: in     vl_logic;
        loadDirtyBitArrayB: in     vl_logic;
        loadDataArrayA  : in     vl_logic;
        loadDataArrayB  : in     vl_logic;
        valid_bit       : in     vl_logic;
        dirty_bit       : in     vl_logic;
        lru_bit         : in     vl_logic;
        lru_out         : out    vl_logic;
        valid_bit_A     : out    vl_logic;
        valid_bit_B     : out    vl_logic;
        dirty_bit_A     : out    vl_logic;
        dirty_bit_B     : out    vl_logic;
        array_sel       : in     vl_logic;
        mem_address_sel : in     vl_logic;
        cache_in_sel    : in     vl_logic
    );
end cacheDatapath;
