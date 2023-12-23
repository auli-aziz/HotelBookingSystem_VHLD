LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY HotelSystem IS
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
		done : OUT STD_LOGIC;
		-- menunjukkan current state
		step : OUT STD_LOGIC_VECTOR (2 downto 0);

		-- ada 2 sevseg untuk display harga 1 kamar
		ratus_ribuan : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);
		jutaan : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

		test_out : OUT integer
	);
END ENTITY HotelSystem;

ARCHITECTURE rtl OF HotelSystem IS
	COMPONENT SevSegModul IS
	PORT (
		sev_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sev_out : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
	END COMPONENT SevSegModul;

	-- deklarasi state
	type stateType IS (idle, booking, loading, payment, check_in, booking_success);
	-- deklarasi daftar reservasi kamar
	type roomArr is array (0 to 31) of STD_LOGIC_VECTOR (4 downto 0);

	signal state, nextState : stateType;
	-- list kamar yang sudah di-book
	signal daftarKamar : roomArr := (others => (others => '0'));
	-- index dari daftar kamar
	signal arrIdx : integer := 0;

	-- signal untuk seven segment
	signal bcd1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
	signal bcd2 : STD_LOGIC_VECTOR (3 DOWNTO 0);

	-- Fungsi untuk mengecek ketersediaan kamar
	function isRoomAvailable(kamar: STD_LOGIC_VECTOR; daftarKamar : roomArr) return boolean is
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
			-- untuk nomor kamar 1 sampe 10 harga 1 kamar 500k (2 orang per kamar)
			-- untuk nomor kamar 11 sampe 20 harga 1 kamar 800k (3 orang per kamar)
			-- untuk nomor kamar 21 sampe 31 harga 1 kamar 1.5 jt (4 orang per kamar)
			if kamar < "01011" then
				harga_kamar := "0101";
				jml_kamar := STD_LOGIC_VECTOR(unsigned(orang) / 2);
			elsif kamar > "01010" and kamar < "10101" then
				harga_kamar := "1000";
				jml_kamar := STD_LOGIC_VECTOR(unsigned(orang) / 3);
			elsif kamar > "10100" then
				harga_kamar := "1111";
				jml_kamar := STD_LOGIC_VECTOR(unsigned(orang) / 4);
			end if;

			
			if jml_kamar = "00000" then
				jml_kamar := "00001";
			end if;

			total_harga_temp := STD_LOGIC_VECTOR(unsigned(jml_kamar) * unsigned(malam) * unsigned(harga_kamar));

			return total_harga_temp;
		end function;

BEGIN

	SevenSeg_RatusRibuan : SevSegModul port map(bcd1, ratus_ribuan);
	SevenSeg_Jutaan : SevSegModul port map(bcd2, jutaan);

	PROCESS (state, start, no_kamar, jml_malam, jml_orang, input_uang)
		variable isBooked : boolean;
	BEGIN
		CASE state IS
			WHEN idle =>
				step <= "000";
				done <= '0';
				bcd1 <= "0000";
				bcd2 <= "0000";

				IF start = '1' THEN
				    nextState <= booking;
				ELSE 
					nextState <= idle;
				end if;
			WHEN booking =>
				step <= "001";
				isBooked := FALSE;

				report "Selamat Datang di Hotel Booking System!";
				report "Masukan nomor kamar, waktu menginap, dan jumlah orang menginap.";
				IF no_kamar > "00000" and jml_malam > "00000" and jml_orang > "00000" THEN 
					nextState <= loading;
				ELSE 
					nextState <= booking;
				END IF;
			WHEN loading =>
				step <= "010";

				if arrIdx > 31 then
					arrIdx <= 0;

					-- clear daftar kamar
					for i in 0 to 31 loop
						daftarKamar(i) <= "00000";
					end loop;
						
				end if;

				test_out <= arrIdx;

				if not isRoomAvailable(no_kamar, daftarKamar) then
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
				step <= "011";
				arrIdx <= arrIdx + 1;

				-- mendisplay harga kamar (dapat diimplementasikan ke dalam function)
				if no_kamar < "01011" then
					bcd1 <= "0101";
					bcd2 <= "0000";
				elsif no_kamar > "01010" and no_kamar < "10101" then
					bcd1 <= "1000";
					bcd2 <= "0000";
				elsif no_kamar > "10100" then
					bcd1 <= "0000";
					bcd2 <= "1111";
				end if;

				-- Menggunakan fungsi calculateTotalPrice untuk menghitung total harga
				total_harga <= calculateTotalPrice(no_kamar, jml_orang, jml_malam);

				nextState <= check_in;
			WHEN check_in =>
				step <= "100";
				report "Masukkan uang untuk pembayaran.";

				if input_uang >= total_harga then
					report "Berhasil Check In!";
					kembalian <= STD_LOGIC_VECTOR(unsigned(input_uang) - unsigned(total_harga));
					nextState <= booking_success;
				else
					nextState <= check_in;
					report "Uang tidak cukup.";
				end if;
			WHEN booking_success =>
				step <= "101";
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
