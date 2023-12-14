LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Hotel_Controller IS
	PORT (
		Input, CLK : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		Output : STD_LOGIC
	);
END ENTITY Hotel_Controller;

ARCHITECTURE rtl OF Hotel_Controller IS
	TYPE stateType IS (idle, check_in, available, reserved, occupied);
	SIGNAL state, nextState : stateType;

BEGIN
	PROCESS (CLK)
	BEGIN
		CASE state IS
			WHEN idle =>
				IF(input = '1') THEN
				    nextState <= check_in;
				end if;
			WHEN check_in =>
			WHEN available =>
			WHEN reserved =>
			WHEN occupied =>
		END CASE;
	END PROCESS;

	PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			state <= nextState;
		END IF;
	END PROCESS;
END ARCHITECTURE rtl;