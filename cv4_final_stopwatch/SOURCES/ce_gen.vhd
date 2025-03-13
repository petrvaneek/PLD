----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
  GENERIC (
    G_DIV_FACT : POSITIVE := 500000
  );
  PORT (
    CLK   : IN  STD_LOGIC;
    SRST  : IN  STD_LOGIC;
    CE    : IN  STD_LOGIC;
    CE_O  : OUT STD_LOGIC
  );
END ENTITY ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
----------------------------------------------------------------------------------
CONSTANT CNT_WIDTH : POSITIVE := POSITIVE(ceil(log2(real(G_DIV_FACT))));
SIGNAL cnt        : UNSIGNED (CNT_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL clk_en     : STD_LOGIC := '0';  
---------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
clk_en_gen : PROCESS (CLK)
BEGIN
  IF rising_edge(CLK) THEN
    IF SRST = '1' THEN
      cnt    <= (OTHERS => '0'); 
      clk_en <= '0';
    ELSIF cnt = G_DIV_FACT-1 THEN
      cnt    <= (OTHERS => '0');
      clk_en <= '1';
    ELSE
      cnt    <= cnt + 1;
      clk_en <= '0';
    END IF;
  END IF;
END PROCESS clk_en_gen;

CE_O <= clk_en;
----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
