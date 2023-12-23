LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY SevSegModul IS
    PORT (
        sev_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sev_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY SevSegModul;

ARCHITECTURE rtl OF SevSegModul IS
BEGIN
    PROCESS (sev_in)
    BEGIN
        CASE sev_in IS
            WHEN "0000" => sev_out <= "1111110"; 
            WHEN "0001" => sev_out <= "0110000"; 
            WHEN "0010" => sev_out <= "1101101"; 
            WHEN "0011" => sev_out <= "1111001"; 
            WHEN "0100" => sev_out <= "0110011"; 
            WHEN "0101" => sev_out <= "1011011"; 
            WHEN "0110" => sev_out <= "1011111"; 
            WHEN "0111" => sev_out <= "1110000"; 
            WHEN "1000" => sev_out <= "1111111"; 
            WHEN "1001" => sev_out <= "1111011"; 
            WHEN OTHERS => sev_out <= "1111111";
        END CASE;
    END PROCESS;
END ARCHITECTURE rtl;
