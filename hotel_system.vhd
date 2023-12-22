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
		total_harga : INOUT STD_LOGIC_VECTOR (13 downto 0);
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

	-- Fungsi untuk mengecek ketersediaan kamar
	function isRoomAvailable(kamar: STD_LOGIC_VECTOR; daftarKamar : roomArr := (others => (others => '0')) ) return boolean is
		begin
			for i in daftarKamar'range loop
				if daftarKamar(i) = kamar then
					return false;
				end if;
			end loop;
			return true;
		end function;

	-- Fungsi untuk menghitung total harga berdasarkan jenis kamar, jumlah orang, dan malam menginap
	function calculateTotalPrice(kamar: STD_LOGIC_VECTOR; orang: STD_LOGIC_VECTOR; malam: STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
		variable harga_kamar : STD_LOGIC_VECTOR (3 downto 0) := "0000";
		variable jml_kamar : STD_LOGIC_VECTOR (4 downto 0) := "00000";
		variable total_harga_temp : STD_LOGIC_VECTOR (13 downto 0) := "00000000000000";
		begin
			if kamar < "01011" then
				harga_kamar := "0101";
			elsif kamar > "01010" and kamar < "10101" then
				harga_kamar := "1000";
			elsif kamar > "10100" then
				harga_kamar := "1111";
			end if;

			jml_kamar := STD_LOGIC_VECTOR(unsigned(orang) / 2);

			if jml_kamar = "00000" then
				jml_kamar := "00001";
			end if;

			total_harga_temp := STD_LOGIC_VECTOR(unsigned(jml_kamar) * unsigned(malam) * unsigned(harga_kamar));

			return total_harga_temp;
		end function;

BEGIN
	PROCESS (state, start, no_kamar, jml_malam, jml_orang)
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
				if not isRoomAvailable(no_kamar) then
					isBooked := TRUE;
					report "Booking gagal, kamar tidak tersedia.";
				else
					daftarKamar(arrIdx) <= no_kamar;
				end if;

				if isBooked then
					nextState <= booking;
				else
					nextState <= payment;
				end if;
			WHEN payment =>
				arrIdx <= arrIdx + 1;

				-- Menggunakan fungsi calculateTotalPrice untuk menghitung total harga
				total_harga <= calculateTotalPrice(no_kamar, jml_orang, jml_malam);
				nextState <= check_in;
			WHEN check_in =>
				report "Masukkan uang untuk pembayaran.";

				if input_uang >= total_harga then
					report "Berhasil Check In!";
					kembalian <= STD_LOGIC_VECTOR(unsigned(input_uang) - unsigned(total_harga));
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
