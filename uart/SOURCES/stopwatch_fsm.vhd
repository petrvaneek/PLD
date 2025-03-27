--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY stopwatch_fsm IS
  PORT (
    CLK                 : IN    STD_LOGIC;
    BTN_S_S             : IN    STD_LOGIC;
    BTN_L_C             : IN    STD_LOGIC;
    CNT_RESET           : OUT   STD_LOGIC;
    CNT_ENABLE          : OUT   STD_LOGIC;
    DISP_ENABLE         : OUT   STD_LOGIC
  );
END ENTITY stopwatch_fsm;
--------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch_fsm IS
--------------------------------------------------------------------------------

  TYPE state_type IS (Idle, Run, Lap, Refresh, Stop);
  SIGNAL current_state, next_state : state_type;

  SIGNAL btn_s_s_edge : STD_LOGIC;
  SIGNAL btn_l_c_edge : STD_LOGIC;

--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
-- Process to update state on clock edge
 btn_l_c_edge <= BTN_L_C; 
 btn_s_s_edge <= BTN_S_S;
  PROCESS (CLK)
  BEGIN
    IF rising_edge(CLK) THEN
      current_state <= next_state;
    END IF;
  END PROCESS;

  -- Next state logic
  PROCESS (current_state, btn_s_s_edge, btn_l_c_edge)
  BEGIN
    CASE current_state IS
      WHEN Idle =>
        IF btn_s_s_edge = '1' THEN
          next_state <= Run;
        ELSE
          next_state <= Idle;
        END IF;
      
      WHEN Run =>
        IF btn_s_s_edge = '1' THEN
          next_state <= Stop;
        ELSIF btn_l_c_edge = '1' THEN
          next_state <= Lap;
        ELSE
          next_state <= Run;
        END IF;
      
      WHEN Lap =>
        IF btn_s_s_edge = '1' THEN
          next_state <= Run;
        ELSIF btn_l_c_edge = '1' THEN
          next_state <= Refresh;
        ELSE
          next_state <= Lap;
        END IF;
      
      WHEN Refresh =>
        IF btn_l_c_edge = '1' THEN
          next_state <= Lap;
        ELSE
          next_state <= Refresh;
        END IF;
      
      WHEN Stop =>
        IF btn_s_s_edge = '1' THEN
          next_state <= Run;
        ELSIF btn_l_c_edge = '1' THEN
          next_state <= Idle;
        ELSE
          next_state <= Stop;
        END IF;
      
      WHEN OTHERS =>
        next_state <= Idle;
    END CASE;
  END PROCESS;

  -- Output logic
  PROCESS (current_state)
  BEGIN
    CASE current_state IS
      WHEN Idle =>
        CNT_RESET <= '1';
        CNT_ENABLE <= '0';
        DISP_ENABLE <= '1';
      
      WHEN Run =>
        CNT_RESET <= '0';
        CNT_ENABLE <= '1';
        DISP_ENABLE <= '1';
      
      WHEN Lap =>
        CNT_RESET <= '0';
        CNT_ENABLE <= '1';
        DISP_ENABLE <= '0';
      
      WHEN Refresh =>
        CNT_RESET <= '0';
        CNT_ENABLE <= '1';
        DISP_ENABLE <= '1';
      
      WHEN Stop =>
        CNT_RESET <= '0';
        CNT_ENABLE <= '0';
        DISP_ENABLE <= '1';
      
      WHEN OTHERS =>
        CNT_RESET <= '1';
        CNT_ENABLE <= '0';
        DISP_ENABLE <= '1';
    END CASE;
  END PROCESS;

--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
--------------------------------------------------------------------------------