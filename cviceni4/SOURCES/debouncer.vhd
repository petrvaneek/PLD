----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
ENTITY debouncer IS
  GENERIC(
    G_DEB_PERIOD        : POSITIVE := 3
  );    
  PORT( 
    CLK                 : IN    STD_LOGIC;
    CE                  : IN    STD_LOGIC;
    BTN_IN              : IN    STD_LOGIC;
    BTN_OUT             : OUT   STD_LOGIC
  );
END ENTITY debouncer;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF debouncer IS
----------------------------------------------------------------------------------
SIGNAL shreg         : STD_LOGIC_VECTOR(G_DEB_PERIOD-1 DOWNTO 0) := (others => '0');
SIGNAL stable        : STD_LOGIC := '0';
BEGIN
  PROCESS (CLK)
  BEGIN
    IF rising_edge(CLK) THEN
      IF CE = '1' THEN
        -- Posunutí nového stavu tlačítka do registru
        shreg <= shreg(G_DEB_PERIOD-2 DOWNTO 0) & BTN_IN;
        
           -- Pokud je celý registr stejný, aktualizujeme stabilní výstup
        IF shreg = (shreg'range => '1') THEN
          stable <= '1';
        ELSIF shreg = (shreg'range => '0') THEN
          stable <= '0';
        END IF;
              END IF;
    END IF;
  END PROCESS;

  -- Výstup stabilizovaného tlačítka
  BTN_OUT <= stable;

END ARCHITECTURE Behavioral;