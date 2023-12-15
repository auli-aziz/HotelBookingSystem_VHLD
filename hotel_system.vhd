LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hotel_system IS
	PORT (
		CLK, start 						: IN STD_LOGIC;
		reset 								: IN STD_LOGIC;
		jml_orang, jml_malam 	: IN STD_LOGIC_VECTOR (4 downto 0);
		no_kamar 							: IN STD_LOGIC_VECTOR (4 downto 0);
		input_uang 						: IN STD_LOGIC_VECTOR (2 downto 0);
		sukses								: OUT STD_LOGIC
	);
END ENTITY hotel_system;

ARCHITECTURE rtl OF hotel_system IS
	-- deklarasi state
	type stateType IS (idle, booking, loading, payment, check_in);
	-- deklarasi daftar reservasi kamar
	type roomArr is array (0 to 4) of STD_LOGIC_VECTOR (4 downto 0);
	
	signal state, nextState 		: stateType;
	signal daftarKamar 					: roomArr := (others => (others => '0'));
	signal arrIdx 							: integer := 0;
	signal room_price						: STD_LOGIC_VECTOR (7 downto 0);
BEGIN
	PROCESS (state, start, no_kamar, jml_malam, jml_orang)
	BEGIN
		CASE state IS
			WHEN idle =>
				IF start = '1' THEN
				    nextState <= booking;
				end if;
			WHEN booking =>
				IF no_kamar > "00000" and jml_malam > "00000" and jml_orang > "00000" THEN 
					nextState <= loading;
				END IF;
			WHEN loading =>
				for i in daftarKamar'range loop
					if daftarKamar(i) = no_kamar then
						report "Booking gagal, kamar tidak tersedia.";
						nextState <= booking;
					end if;
				end loop;
				daftarKamar(arrIdx) <= no_kamar;
				nextState <= payment;
			WHEN payment =>
				arrIdx <= arrIdx + 1;
			WHEN check_in =>
		END CASE;
	END PROCESS;

	PROCESS (CLK, reset)
	BEGIN
		IF (reset = '1') then 
			state <= idle;
		ELSIF rising_edge(CLK) THEN
			state <= nextState;
		END IF;
	END PROCESS;
END ARCHITECTURE rtl;