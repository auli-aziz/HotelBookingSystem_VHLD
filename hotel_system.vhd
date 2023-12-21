LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY hotel_system IS
	PORT (
		CLK, start : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		-- jml_orang & jml_malam maksimum adalah 31
		jml_orang, jml_malam : IN STD_LOGIC_VECTOR (4 downto 0);
		-- jumlah kamar di hotel ada 32 - 1 = 31 kamar
		no_kamar : IN STD_LOGIC_VECTOR (4 downto 0);
		-- input_uang dlm satuan ratusan ribu. contoh: 0101 = 500k.
		input_uang : IN STD_LOGIC_VECTOR (13 downto 0);
		total_harga : OUT STD_LOGIC_VECTOR (13 downto 0);
		kembalian : OUT STD_LOGIC_VECTOR (13 downto 0);
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
		variable jml_kamar : STD_LOGIC_VECTOR (4 downto 0) := "00000";
		variable harga_kamar : STD_LOGIC_VECTOR (3 downto 0) := "0000";
		variable total_harga_temp : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";
		variable temp : integer;
		variable isBooked : boolean;
	BEGIN

		CASE state IS
			WHEN idle =>
				IF start = '1' THEN
				    nextState <= booking;
				end if;
			WHEN booking =>
				isBooked := FALSE;

				report "Selamat Datang di Hotel Booking System!";
				report "Masukan nomor kamar, waktu menginap, dan jumlah orang menginap.";
				IF no_kamar > "00000" and jml_malam > "00000" and jml_orang > "00000" THEN 
					nextState <= loading;
				END IF;
			WHEN loading =>
				-- looping kamar yang tersedia (dapat diimplementasikan ke function)
				for i in daftarKamar'range loop
					if daftarKamar(i) = no_kamar then
						isBooked := TRUE;
						report "Booking gagal, kamar tidak tersedia.";
					end if;
				end loop;
				
				daftarKamar(arrIdx) <= no_kamar;
				
				if isBooked then
					nextState <= booking;
				else
					nextState <= payment;
				end if;
			WHEN payment =>
				arrIdx <= arrIdx + 1;

				-- Operasi kalkulasi harga (dapat diimplementasikan ke function)
				-- untuk nomor kamar 1 sampe 10 harga 1 kamar 500k (2 orang per kamar)
				-- untuk nomor kamar 11 sampe 20 harga 1 kamar 800k (3 orang per kamar)
				-- untuk nomor kamar 21 sampe 31 harga 1 kamar 1.5 jt (5 orang per kamar)

				
				if no_kamar < "01011" then
					harga_kamar := "0101";

					jml_kamar := STD_LOGIC_VECTOR(unsigned(jml_orang) / 2);

					if jml_kamar = "00000" then
						jml_kamar := "00001";
					end if;

					total_harga_temp := STD_LOGIC_VECTOR(unsigned(jml_kamar) * unsigned(jml_malam) * unsigned(harga_kamar));
				elsif no_kamar > "01010" and no_kamar < "10101" then
					harga_kamar := "1000";
					
					jml_kamar := STD_LOGIC_VECTOR(unsigned(jml_orang) / 3);

					if jml_kamar = "00000" then
						jml_kamar := "00001";
					end if;

					total_harga_temp := STD_LOGIC_VECTOR(unsigned(jml_kamar) * unsigned(jml_malam) * unsigned(harga_kamar));
				elsif no_kamar > "10100" then
					harga_kamar := "1111";
					
					jml_kamar := STD_LOGIC_VECTOR(unsigned(jml_orang) / 5);

					if jml_kamar = "00000" then
						jml_kamar := "00001";
					end if;

					total_harga_temp := STD_LOGIC_VECTOR(unsigned(jml_kamar) * unsigned(jml_malam) * unsigned(harga_kamar));
				end if;

				total_harga <= total_harga_temp;
				nextState <= check_in;
			WHEN check_in =>
				report "Masukkan uang untuk pembayaran.";

				if input_uang >= total_harga_temp then
					report "Berhasil Check In!";
					kembalian <= STD_LOGIC_VECTOR(unsigned(input_uang) - unsigned(total_harga_temp));
					nextState <= booking_success;
				else
					report "Uang tidak cukup.";
				end if;
			WHEN booking_success => 
				done <= '1';
				nextState <= idle;
			WHEN others =>
				null;
		END CASE;

	END PROCESS;

	PROCESS (CLK, reset)
	BEGIN
		IF reset = '1' then 
			state <= idle;
		ELSIF rising_edge(CLK) THEN
			state <= nextState;
		END IF;
	END PROCESS;
END ARCHITECTURE rtl;