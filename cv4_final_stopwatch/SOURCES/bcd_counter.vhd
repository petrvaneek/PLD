----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
----------------------------------------------------------------------------------
ENTITY bcd_counter IS
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
END ENTITY bcd_counter;



----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF bcd_counter IS
----------------------------------------------------------------------------------
 -- Internal clock enable
signal c_en  : std_logic;
--signal s_en : std_logic_vector(15 downto 0) := (OTHERS =>'0');
signal clock_1ms_lsb  : std_logic_vector(3 DOWNTO 0) := "0000";
signal clock_10_ms_msb : std_logic_vector(3 DOWNTO 0) := "0000";
signal clock_sec_lsb  : std_logic_vector(3 DOWNTO 0) := "0000";
signal clock_sec_msb  : std_logic_vector(3 DOWNTO 0) := "0000";
-- Výstupní registry pro DISP_ENABLE
signal disp_CNT_0 : std_logic_vector(3 DOWNTO 0) := "0000";
signal disp_CNT_1 : std_logic_vector(3 DOWNTO 0) := "0000";
signal disp_CNT_2 : std_logic_vector(3 DOWNTO 0) := "0000";
signal disp_CNT_3 : std_logic_vector(3 DOWNTO 0) := "0000";
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
  -- BCD counter
clk_en0 : entity work.ce_gen
    generic map(
        -- FOR SIMULATION, CHANGE THIS VALUE TO 4
        -- FOR IMPLEMENTATION, KEEP THIS VALUE TO 400,000
        G_DIV_FACT  => 5000000
    )
    port map(
        CLK   => CLK,
        SRST => CNT_RESET,
        CE_O  => c_en,
        CE => CNT_ENABLE
    );
process(CLK)
  begin
    if rising_edge(CLK) then
        if CNT_RESET = '1' then
            clock_1ms_lsb  <= "0000";
            clock_10_ms_msb <= "0000";
            clock_sec_lsb  <= "0000";
            clock_sec_msb  <= "0000";
        elsif CNT_ENABLE = '1' AND c_en = '1' then
            -- Inkrementace 1ms
            if clock_1ms_lsb = "1001" then
                clock_1ms_lsb <= "0000";
                -- Inkrementace 10ms
                if clock_10_ms_msb = "0101" then
                    clock_10_ms_msb <= "0000";
                    -- Inkrementace 1s
                    if clock_sec_lsb = "1001" then
                        clock_sec_lsb <= "0000";
                        -- Inkrementace 10s
                        if clock_sec_msb = "0101" then
                            -- Reset na 00:00
                            clock_sec_msb <= "0000";
                        else
                            clock_sec_msb <= std_logic_vector(unsigned(clock_sec_msb) + 1);
                        end if;
                    else
                        clock_sec_lsb <= std_logic_vector(unsigned(clock_sec_lsb) + 1);
                    end if;
                else
                    clock_10_ms_msb <= std_logic_vector(unsigned(clock_10_ms_msb) + 1);
                end if;
            else
                clock_1ms_lsb <= std_logic_vector(unsigned(clock_1ms_lsb) + 1);
            end if;
        end if;

     
        if DISP_ENABLE = '1' then
            disp_CNT_0 <= clock_1ms_lsb;
            disp_CNT_1 <= clock_10_ms_msb;
            disp_CNT_2 <= clock_sec_lsb;
            disp_CNT_3 <= clock_sec_msb;
        end if;
    end if;
  end process;
      
  

      
        
  --------------------------------------------------------------------------------
  -- Output (display) register
      CNT_0 <= disp_CNT_0;
      CNT_1 <= disp_CNT_1;
      CNT_2 <= disp_CNT_2;
      CNT_3 <= disp_CNT_3;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
