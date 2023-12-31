library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SevSegModul_tb is
end entity SevSegModul_tb;

architecture rtl of SevSegModul_tb is
    COMPONENT SevSegModul IS
    PORT (
        sev_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        sev_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
    );
    END COMPONENT SevSegModul;

    signal input : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal output : STD_LOGIC_VECTOR(6 DOWNTO 0);
begin
    
    UUT : SevSegModul port map(sev_in => input, sev_out => output);

    process
        constant waktu : time := 100 ps;
    begin
        for i in 0 to 9 loop
            input <= STD_LOGIC_VECTOR(to_unsigned(i, 4));
            wait for waktu;
        end loop;
        wait;
    end process;
    
end architecture rtl;