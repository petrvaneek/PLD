----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY edge_detector IS
  PORT(
    CLK                 : IN    STD_LOGIC;
    SIG_IN              : IN    STD_LOGIC;
    EDGE_POS            : OUT   STD_LOGIC;
    EDGE_NEG            : OUT   STD_LOGIC;
    EDGE_ANY            : OUT   STD_LOGIC
  );
END ENTITY edge_detector;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF edge_detector IS
----------------------------------------------------------------------------------
--Registr pro zpoÅ¾dÄ›nÃ­ signÃ¡lu
SIGNAL SIG_DELAYED : STD_LOGIC := '0';

----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
PROCESS (CLK)
BEGIN
  IF rising_edge(CLK) THEN
    -- Detekce vzestupné hrany
    EDGE_POS <= (NOT SIG_DELAYED) AND SIG_IN;
    
    -- Detekce sestupné hrany
    EDGE_NEG <= SIG_DELAYED AND (NOT SIG_IN);
    
    -- Detekce libovolné hrany
    EDGE_ANY <= SIG_DELAYED XOR SIG_IN;
    
    -- Aktualizace zpožd?ní signálu
    SIG_DELAYED <= SIG_IN;
  END IF;
END PROCESS;

----------------------------------------------------------------------------------
END ARCHITECTURE Behavioral;
----------------------------------------------------------------------------------