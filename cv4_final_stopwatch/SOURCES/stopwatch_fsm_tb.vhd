LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY stopwatch_fsm_tb IS
END ENTITY stopwatch_fsm_tb;

ARCHITECTURE testbench OF stopwatch_fsm_tb IS

  -- Component Declaration
  COMPONENT stopwatch_fsm
    PORT (
      CLK         : IN  STD_LOGIC;
      BTN_S_S     : IN  STD_LOGIC;
      BTN_L_C     : IN  STD_LOGIC;
      CNT_RESET   : OUT STD_LOGIC;
      CNT_ENABLE  : OUT STD_LOGIC;
      DISP_ENABLE : OUT STD_LOGIC
    );
  END COMPONENT;

  -- Signals
  SIGNAL clk         : STD_LOGIC := '0';
  SIGNAL btn_s_s     : STD_LOGIC := '0';
  SIGNAL btn_l_c     : STD_LOGIC := '0';
  SIGNAL cnt_reset   : STD_LOGIC;
  SIGNAL cnt_enable  : STD_LOGIC;
  SIGNAL disp_enable : STD_LOGIC;
  
  CONSTANT clk_period : TIME := 10 ns;

BEGIN

  -- DUT Instantiation
  uut: stopwatch_fsm
    PORT MAP (
      CLK         => clk,
      BTN_S_S     => btn_s_s,
      BTN_L_C     => btn_l_c,
      CNT_RESET   => cnt_reset,
      CNT_ENABLE  => cnt_enable,
      DISP_ENABLE => disp_enable
    );

  -- Clock Process
  clk_process: PROCESS
  BEGIN
    WHILE NOW < 500 ns LOOP  -- Simulace b?ží 500 ns
      clk <= '0';
      WAIT FOR clk_period / 2;
      clk <= '1';
      WAIT FOR clk_period / 2;
    END LOOP;
    WAIT;
  END PROCESS;

  -- Stimulus Process
  stimulus_process: PROCESS
  BEGIN
    -- Reset je aktivní v Idle
    WAIT FOR 20 ns;
    
    -- Start - p?echod do Run
    btn_s_s <= '1';
    WAIT FOR clk_period;
    btn_s_s <= '0';
    WAIT FOR 50 ns;
    
    -- Lap - p?echod do Lap
    btn_l_c <= '1';
    WAIT FOR clk_period;
    btn_l_c <= '0';
    WAIT FOR 50 ns;
    
    -- Refresh - p?echod do Refresh
    btn_l_c <= '1';
    WAIT FOR clk_period;
    btn_l_c <= '0';
    WAIT FOR 50 ns;
    
    -- Zp?t do Lap
    btn_l_c <= '1';
    WAIT FOR clk_period;
    btn_l_c <= '0';
    WAIT FOR 50 ns;
    
    -- Run - návrat z Lap
    btn_s_s <= '1';
    WAIT FOR clk_period;
    btn_s_s <= '0';
    WAIT FOR 50 ns;
    
    -- Stop
    btn_s_s <= '1';
    WAIT FOR clk_period;
    btn_s_s <= '0';
    WAIT FOR 50 ns;
    
    -- Zp?t do Idle
    btn_l_c <= '1';
    WAIT FOR clk_period;
    btn_l_c <= '0';
    WAIT FOR 50 ns;
    
    -- Ukon?ení simulace
    WAIT;
  END PROCESS;

END ARCHITECTURE testbench;
