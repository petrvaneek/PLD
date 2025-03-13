----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY sync_reg IS
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC;
    SIG_OUT             : OUT   STD_LOGIC
  );
END ENTITY sync_reg;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF sync_reg IS
----------------------------------------------------------------------------------
SIGNAL sig_reg1 : STD_LOGIC;
SIGNAL sig_reg2: STD_LOGIC;

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS(CLK)
  BEGIN
    if rising_edge(CLK) then
        sig_reg1 <= SIG_IN;
        sig_reg2 <= sig_reg1;
    end if;
END PROCESS;

SIG_OUT <= sig_reg2;
--------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------
