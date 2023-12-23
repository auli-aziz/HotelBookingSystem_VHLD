library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity HotelSystem_tb is
end entity HotelSystem_tb;

architecture rtl of HotelSystem_tb is
    signal CLK, reset : std_logic := '0';
    signal start : std_logic;
    signal jml_orang, jml_malam, no_kamar: std_logic_vector(4 downto 0) := (others => '0');
    signal input_uang, total_harga, kembalian : std_logic_vector(13 downto 0) := (others => '0');
    signal done : std_logic := '0';
    signal step : std_logic_vector (2 downto 0) := "000";
    signal ratus_ribuan, jutaan : std_logic_vector(6 downto 0);
    signal test_out : integer;
    
    COMPONENT HotelSystem
        PORT (
            CLK, start, reset : IN STD_LOGIC;
            jml_orang, jml_malam : IN STD_LOGIC_VECTOR (4 downto 0);
            no_kamar : IN STD_LOGIC_VECTOR (4 downto 0);
            input_uang, total_harga : INOUT STD_LOGIC_VECTOR (13 downto 0);
            kembalian : OUT STD_LOGIC_VECTOR (13 downto 0);
            done : OUT STD_LOGIC;
            step : OUT STD_LOGIC_VECTOR (2 downto 0);
            ratus_ribuan, jutaan : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
            test_out : OUT integer
        );
    END COMPONENT HotelSystem;

    constant waktu : time := 100 ps;
    signal stimulus_done : boolean := false;
begin
    
    UUT : HotelSystem port map (
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
        step => step,
        ratus_ribuan => ratus_ribuan,
        jutaan => jutaan,
        test_out => test_out
    );

    process
    begin
        while not stimulus_done loop
            CLK <= '0';
            wait for waktu;
            CLK <= '1';
            wait for waktu;
        end loop;
        wait;
    end process;

    process
        variable counter : integer := 0;
    begin
        start <= '1';
        input_uang <= "11111111111111";
        for i in 0 to 31 loop
            for j in 0 to 31 loop
                for k in 0 to 31 loop
                    no_kamar <= STD_LOGIC_VECTOR(to_unsigned(k, 5));
                    jml_malam <= STD_LOGIC_VECTOR(to_unsigned(j, 5));
                    jml_orang <= STD_LOGIC_VECTOR(to_unsigned(i, 5));

                    wait for waktu * 8;

                    -- if i > 0 then
                    --     for l in 0 to 16383 loop
                    --         input_uang <= STD_LOGIC_VECTOR(to_unsigned(l, 14));
                    --     end loop;
                    -- end if;
                    
                    counter := counter + 1;
                    if counter = 32*32*32 then
                        stimulus_done <= TRUE;
                    end if;
                end loop;
            end loop;
        end loop;
        wait;

    end process;
    
end architecture rtl;