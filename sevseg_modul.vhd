LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY sevseg_modul IS
    PORT (
        sev_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        sev_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
END ENTITY sevseg_modul;

ARCHITECTURE rtl OF sevseg_modul IS
BEGIN
    PROCESS (sev_in)
    BEGIN
        CASE sev_in IS
            WHEN "00000" => sev_out <= "1111110"; 
            WHEN "00001" => sev_out <= "0110000"; 
            WHEN "00010" => sev_out <= "1101101"; 
            WHEN "00011" => sev_out <= "1111001"; 
            WHEN "00100" => sev_out <= "0110011"; 
            WHEN "00101" => sev_out <= "1011011"; 
            WHEN "00110" => sev_out <= "1011111"; 
            WHEN "00111" => sev_out <= "1110000"; 
            WHEN "01000" => sev_out <= "1111111"; 
            WHEN "01001" => sev_out <= "1111011"; 
            WHEN OTHERS => sev_out <= "1111111";
        END CASE;
    END PROCESS;
END ARCHITECTURE rtl;
