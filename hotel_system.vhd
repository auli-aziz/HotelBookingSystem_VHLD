LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hotel_system IS
	PORT (
		CLK, start : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		jml_orang, jml_malam : IN STD_LOGIC_VECTOR (4 downto 0);
		no_kamar : IN STD_LOGIC_VECTOR (4 downto 0);
		-- input_uang dlm satuan ratusan ribu. contoh: 0101 = 500k.
		input_uang : IN STD_LOGIC_VECTOR (3 downto 0);
		done : INOUT STD_LOGIC
	);
END ENTITY hotel_system;

ARCHITECTURE rtl OF hotel_system IS
	-- deklarasi state
	type stateType IS (idle, booking, loading, payment, check_in, booking_success);
	-- deklarasi daftar reservasi kamar
	type roomArr is array (0 to 4) of STD_LOGIC_VECTOR (4 downto 0);
	
	signal state, nextState : stateType;
	-- list kamar yang sudah di-book
	signal daftarKamar : roomArr := (others => (others => '0'));
	-- index dari daftar kamar
	signal arrIdx : integer := 0;
BEGIN
	PROCESS (state, start, no_kamar, jml_malam, jml_orang)
		variable harga_kamar : STD_LOGIC_VECTOR (4 downto 0);
		variable total_harga : STD_LOGIC_VECTOR (9 downto 0);
	BEGIN

		CASE state IS
			WHEN idle =>
				IF start = '1' THEN
				    nextState <= booking;
				end if;
			WHEN booking =>
				report "Selamat Datang di Hotel Booking System!";
				report "Masukan nomor kamar, waktu menginap, dan jumlah orang menginap.";
				IF no_kamar > "00000" and jml_malam > "00000" and jml_orang > "00000" THEN 
					nextState <= loading;
				END IF;
			WHEN loading =>
				-- looping kamar yang tersedia (dapat diimplementasikan ke function)
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

				-- Operasi kalkulasi harga (dapat diimplementasikan ke function)
				-- jumlah kamar di hotel ada 32 - 1 = 31 kamar
				-- untuk nomor kamar 1 sampe 10 harga 1 kamar 500k
				-- untuk nomor kamar 11 sampe 20 harga 1 kamar 800k
				-- untuk nomor kamar 21 sampe 31 harga 1 kamar 1.5 jt
				if no_kamar < "01011" then
					harga_kamar := "00101";
					
				elsif no_kamar > "01010" and no_kamar < "10101" then
					harga_kamar := "01000";

				elsif no_kamar > "10100" then
					harga_kamar := "01000";

				end if;
			WHEN booking_success => 
			WHEN check_in =>
			WHEN others =>
				null;
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