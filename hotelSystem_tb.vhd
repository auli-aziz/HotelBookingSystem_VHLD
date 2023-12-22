library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity HotelSystem_tb is
end entity HotelSystem_tb;

architecture rtl of HotelSystem_tb is
    signal CLK, start, reset : std_logic := '0';
    signal jml_orang, jml_malam, no_kamar: std_logic_vector(4 downto 0) := (others => '0');
    signal input_uang, total_harga, kembalian : std_logic_vector(13 downto 0) := (others => '0');
    signal done : std_logic := '0';
    signal ratus_ribuan, jutaan : std_logic_vector(6 downto 0);
    
    COMPONENT hotel_system
    PORT (
        CLK, start, reset : IN STD_LOGIC;
        jml_orang, jml_malam : IN STD_LOGIC_VECTOR (4 downto 0);
        no_kamar : IN STD_LOGIC_VECTOR (4 downto 0);
        input_uang, total_harga : INOUT STD_LOGIC_VECTOR (13 downto 0);
        kembalian : OUT STD_LOGIC_VECTOR (13 downto 0);
        done : OUT STD_LOGIC;
        ratus_ribuan, jutaan : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
    );
    END COMPONENT hotel_system;

    constant CLK_PERIOD : time := 10 ns;
    signal stimulus_done : boolean := false;
begin
    
    UUT : hotel_system port map (
        CLK => CLK,
        start => start,
        reset => reset,
        jml_orang => jml_orang,
        jml_malam => jml_malam,
        no_kamar => no_kamar,
        input_uang => input_uang,
        total_harga => total_harga,
        kembalian => kembalian,
        done => done,
        ratus_ribuan => ratus_ribuan,
        jutaan => jutaan
    );

    CLK_PROCESS : process
    begin
        while not stimulus_done loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    STIMULUS_PROCESS : process
    begin
        wait for 20 ns; 

        -- Test case 1
        start <= '1';
        wait for CLK_PERIOD * 10; 
        start <= '0';
        wait for CLK_PERIOD * 10;
        reset <= '1';
        wait for CLK_PERIOD * 10;
        reset <= '0';

        stimulus_done <= true;
        wait;
    end process;
    
end architecture rtl;