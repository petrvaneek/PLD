----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
  PORT(
    CLK             : IN  STD_LOGIC;
    BTN             : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    SW              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    LED             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
END ENTITY rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
----------------------------------------------------------------------------------

  COMPONENT seg_disp_driver
  PORT(
    CLK             : IN  STD_LOGIC;
    DIG_1           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_2           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_3           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DIG_4           : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
    DP              : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);        -- [DP4 DP3 DP2 DP1]
    DOTS            : IN  STD_LOGIC_VECTOR (2 DOWNTO 0);        -- [L3 L2 L1]
    DISP_SEG        : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    DISP_DIG        : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
  );
  END COMPONENT seg_disp_driver;

  ------------------------------------------------------------------------------
  SIGNAL btn_db            : STD_LOGIC;
  SIGNAL btn_db2            : STD_LOGIC;
  SIGNAL btn_edge          : STD_LOGIC;
  --SIGNAL start_stop        : STD_LOGIC;
  --SIGNAL rst_stopwatch     : STD_LOGIC;
  SIGNAL cnt_0              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_1              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_2              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL cnt_3              : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL ce                     : STD_LOGIC := '0';
  SIGNAL cen                     : STD_LOGIC := '1';
  SIGNAL sigrst                     : STD_LOGIC := '0';
  SIGNAL btn_neg            : STD_LOGIC;
  SIGNAL btn_pos            : STD_LOGIC;
  SIGNAL disp_en        : STD_LOGIC := '0';
  SIGNAL btn_debounced      : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_edge_pos       : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_edge_neg       : STD_LOGIC_VECTOR( 3 DOWNTO 0);
  SIGNAL btn_edge_any       : STD_LOGIC_VECTOR( 3 DOWNTO 0);
----------------------------------------------------------------------------------
  COMPONENT ce_gen
  GENERIC (
                G_DIV_FACT          : POSITIVE := 2
           );
  PORT(
      CLK       : IN STD_LOGIC;
      SRST      : IN STD_LOGIC;
      CE        : IN STD_LOGIC;
      CE_O      : OUT STD_LOGIC
      
  );
  END COMPONENT ce_gen;
COMPONENT btn_in
   GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );
    PORT(
        CLK                 : IN    STD_LOGIC;
        CE                  : IN    STD_LOGIC;
        BTN                 : IN    STD_LOGIC;
        BTN_DEBOUNCED       : OUT   STD_LOGIC;
        BTN_EDGE_POS        : OUT   STD_LOGIC;
        BTN_EDGE_NEG        : OUT   STD_LOGIC;
        BTN_EDGE_ANY        : OUT   STD_LOGIC
    );
END COMPONENT btn_in;
 COMPONENT stopwatch_fsm
 PORT(
     CLK                 : IN    STD_LOGIC;
    BTN_S_S             : IN    STD_LOGIC;
    BTN_L_C             : IN    STD_LOGIC;
    CNT_RESET           : OUT   STD_LOGIC;
    CNT_ENABLE          : OUT   STD_LOGIC;
    DISP_ENABLE         : OUT   STD_LOGIC
  );
  END COMPONENT stopwatch_fsm;
COMPONENT bcd_counter
  PORT(
    CLK                 : IN    STD_LOGIC;      -- clock signal
    CE_100HZ            : IN    STD_LOGIC;      -- 100 Hz clock enable
    CNT_RESET           : IN    STD_LOGIC;      -- counter reset
    CNT_ENABLE          : IN    STD_LOGIC;      -- counter enable
    DISP_ENABLE         : IN    STD_LOGIC;      -- enable display update
    CNT_0               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_1               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_2               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0);
    CNT_3               : OUT   STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT bcd_counter;
BEGIN
----------------------------------------------------------------------------------

  --------------------------------------------------------------------------------
  -- display driver
  --
  --       DIG 1       DIG 2       DIG 3       DIG 4
  --                                       L3
  --       -----       -----       -----   o   -----
  --      |     |     |     |  L1 |     |     |     |
  --      |     |     |     |  o  |     |     |     |
  --       -----       -----       -----       -----
  --      |     |     |     |  o  |     |     |     |
  --      |     |     |     |  L2 |     |     |     |
  --       -----  o    -----  o    -----  o    -----  o
  --             DP1         DP2         DP3         DP4
  --
  --------------------------------------------------------------------------------

  seg_disp_driver_i : seg_disp_driver
  PORT MAP(
    CLK                 => CLK,
    DIG_1               => cnt_3,
    DIG_2               => cnt_2,
    DIG_3               => cnt_1,
    DIG_4               => cnt_0,
    DP                  => "0000",
    DOTS                => "011",
    DISP_SEG            => DISP_SEG,
    DISP_DIG            => DISP_DIG
  );

  --------------------------------------------------------------------------------
  -- clock enable generator
cen_gen_100Hz_i: ce_gen
    GENERIC  MAP (G_DIV_FACT => 500000)
    PORT MAP ( CLK => CLK,
               SRST => '0',
               CE  => '1',
               CE_O => ce
    );


  --------------------------------------------------------------------------------
  -- button input module

  gen_btn_in : for i in 0 to 3 generate
    btn_in_i : btn_in
    GENERIC MAP(
      G_DEB_PERIOD => 5
    )
    PORT MAP(
      CLK                 => CLK,
      CE                  => ce,
      BTN                 => BTN(i),
      BTN_DEBOUNCED       => btn_debounced(i),
      BTN_EDGE_POS        => btn_edge_pos(i),
      BTN_EDGE_NEG        => btn_edge_neg(i),
      BTN_EDGE_ANY        => btn_edge_any(i)
    );
  end generate gen_btn_in;

  --------------------------------------------------------------------------------
  -- stopwatch module (4-decade BCD counter)
  bcd_counter_i : bcd_counter
  PORT MAP(
    CLK            => CLK, 
    CE_100HZ       => ce, 
    CNT_RESET      => sigrst, 
    CNT_ENABLE     =>  cen,
    DISP_ENABLE    =>  disp_en,
    CNT_0          =>  cnt_0,
    CNT_1          =>  cnt_1,
    CNT_2          =>  cnt_2,
    CNT_3          => cnt_3  
  );


  --------------------------------------------------------------------------------
  -- stopwatch control FSM
  stopwatch_fsm_i : stopwatch_fsm
  PORT MAP(
       CLK   => CLK,       
       BTN_S_S  => btn_edge_pos(0),  
       BTN_L_C  => btn_edge_pos(3),   
       CNT_RESET   => sigrst,
       CNT_ENABLE  => cen,
       DISP_ENABLE => disp_en
  );


  --------------------------------------------------------------------------------
  -- LED connection

  LED <= cnt_3 & cnt_2;


----------------------------------------------------------------------------------
END ARCHITECTURE Structural;
----------------------------------------------------------------------------------
