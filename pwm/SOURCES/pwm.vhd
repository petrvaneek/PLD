----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
----------------------------------------------------------------------------------
ENTITY pwm IS
  PORT (
    CLK                 : IN  STD_LOGIC;
    PWM_REF_7           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_6           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_5           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_4           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_3           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_2           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_1           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_REF_0           : IN  STD_LOGIC_VECTOR (7 DOWNTO 0);
    PWM_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
    CNT_OUT             : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
  );
END pwm;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF pwm IS
----------------------------------------------------------------------------------
SIGNAL cnt_sig          : INTEGER RANGE 0 TO 254 := 0;
SIGNAL PWM_OUT_REG      : STD_LOGIC_VECTOR (7 DOWNTO 0) := (OTHERS => '0');
----------------------------------------------------------------------------------
BEGIN
----------------------------------------------------------------------------------
seq : PROCESS(clk) IS
BEGIN
    IF rising_edge(clk) THEN
        CNT_OUT <= STD_LOGIC_VECTOR(TO_UNSIGNED(cnt_sig, CNT_OUT'length));
        cnt_sig <= cnt_sig + 1;
        PWM_OUT <= PWM_OUT_REG;
        IF cnt_sig = 254 THEN
            cnt_sig <= 0;
        END IF;    
    END IF;   
END PROCESS;

comp: PROCESS(cnt_sig) IS
BEGIN
    PWM_OUT_REG <= (OTHERS => '0');
    IF cnt_sig < UNSIGNED(PWM_REF_0) THEN PWM_OUT_REG(0) <= '1'; END IF;
    IF cnt_sig < UNSIGNED(PWM_REF_1) THEN PWM_OUT_REG(1) <= '1'; END IF;
    IF cnt_sig < UNSIGNED(PWM_REF_2) THEN PWM_OUT_REG(2) <= '1'; END IF;
    IF cnt_sig < UNSIGNED(PWM_REF_3) THEN PWM_OUT_REG(3) <= '1'; END IF;
    
    IF cnt_sig < UNSIGNED(PWM_REF_4) THEN PWM_OUT_REG(4) <= '1'; END IF;
    IF cnt_sig < UNSIGNED(PWM_REF_5) THEN PWM_OUT_REG(5) <= '1'; END IF;
    IF cnt_sig < UNSIGNED(PWM_REF_6) THEN PWM_OUT_REG(6) <= '1'; END IF;
    IF cnt_sig < UNSIGNED(PWM_REF_7) THEN PWM_OUT_REG(7) <= '1'; END IF;
END PROCESS;
----------------------------------------------------------------------------------
END Behavioral;
-------------------------------------------------------------------------