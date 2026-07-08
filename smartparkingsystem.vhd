library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parking_system is
    GENERIC(
        clk_freq   :  INTEGER := 40);  -- 40 MHz clock
    port (
        -- Parking system I/O
        ticket_in      : in  integer;
        enter_time_in  : in  integer;
        exit_time_in   : in  integer;
        clk           : in  std_logic;
        payment_out   : out integer;
        full_out      : out std_logic;
        id_valid      : in  std_logic;
        car_entering  : in  std_logic;
        car_exiting   : in  std_logic;
        gate_open     : out std_logic;
        
        -- Parking space monitoring
        rst          : in  std_logic;
        occupy       : inout std_logic_vector(49 downto 0);
        led          : out std_logic_vector(49 downto 0);
        free_count   : inout natural;
        occupied_count : inout natural;
        
        -- Display outputs
        seg          : out std_logic_vector(6 downto 0);
        seg2         : out std_logic_vector(6 downto 0);
        
        -- Sensor interface
        sensor_pw    : in  std_logic_vector(49 downto 0);    
        carexist     : out std_logic_vector(49 downto 0);
        placement    : in  natural range 0 to 49;
        check        : out integer;
        check_count  : out natural := 0;
        distance     : inout std_logic_vector(7 downto 0)
    );
end entity parking_system;

architecture behavior of parking_system is
    -- Guest record type
    type guest is record
        ticket     : integer;
        enter_time : integer;
        exit_time  : integer;	  
    end record;
    
    -- Guest database
    type guest_array is array (natural range <>) of guest;
    constant max_guests : natural := 100;
    signal guests : guest_array(0 to max_guests-1);
    signal guest_count : natural := 0;
    
    -- Sensor tracking
    SIGNAL sensor_pw_prev : STD_LOGIC_VECTOR(49 DOWNTO 0);

begin
    
    -- Main control process: Handles vehicle entry/exit
    process (clk)
    begin
        if rising_edge(clk) then
            -- Entry without ID (ticket required)
            if ticket_in /= 0 and guest_count < max_guests and 
               id_valid='0' and car_entering='1' and car_exiting='0' then
                guests(guest_count).ticket <= ticket_in;
                guests(guest_count).enter_time <= enter_time_in;
                guests(guest_count).exit_time <= 0;
                payment_out <= 0;
                guest_count <= guest_count + 1;
                gate_open <= '1';
                check_count <= guest_count;
            
            -- Entry with valid ID
            elsif guest_count < max_guests and id_valid='1' and 
                  car_entering='1' and car_exiting='0' then
                guest_count <= guest_count + 1;
                gate_open <= '1';
                check_count <= guest_count;
            
            -- Exit with valid ID
            elsif id_valid='1' and car_entering='0' and car_exiting='1' then
                guest_count <= guest_count - 1;
                gate_open <= '1';
                check_count <= guest_count;
            
            -- No movement
            elsif car_entering='0' and car_exiting='0' then
                gate_open <= '0';
            
            -- Exit with ticket
            else
                for i in 0 to max_guests-1 loop
                    if ticket_in /= 0 and id_valid='0' and 
                       car_exiting='1' and car_entering='0' and 
                       guests(i).ticket = ticket_in then
                        guests(i).exit_time <= exit_time_in;
                        payment_out <= (exit_time_in - guests(i).enter_time) * 2;
                        guest_count <= guest_count - 1;
                        gate_open <= '1';
                        check_count <= guest_count;
                    end if;
                end loop;
            end if;
        end if;
    end process;
    
    -- Parking space monitoring process
    PROCESS(clk, rst)
        VARIABLE pulse_count : INTEGER := 0;  
        VARIABLE dist_value  : INTEGER := 0;  
        type dist_array is array (0 to 49) of integer range 0 to 255;
        variable space_distances: dist_array;
    BEGIN
        IF(rst = '1') THEN    
            -- Reset all outputs
            led <= (others => '1');
            free_count <= 50;
            occupied_count <= 0;
            pulse_count := 0;
            dist_value := 0;
            distance <= (others => '0');
            carexist <= (others => '0');
            occupy <= (others => '0');
            
        ELSIF(rising_edge(clk)) THEN
            -- Store previous sensor state
            sensor_pw_prev(placement) <= sensor_pw(placement);
            
            -- Measure pulse width (distance)
            IF(sensor_pw(placement) = '1') THEN
                pulse_count := pulse_count + 1;
                
            -- Process completed measurement
            ELSIF(sensor_pw_prev(placement) = '1') THEN
                dist_value := pulse_count;
                distance <= std_logic_vector(to_unsigned(dist_value, 8));
                space_distances(placement) := dist_value;
                check <= dist_value;
                
                -- Car detected
                if(dist_value < 20) then  -- Threshold adjusted for 40MHz clock
                    carexist(placement) <= '1';
                    occupy(placement) <= '1';
                    led(placement) <= '0';
                    occupied_count <= occupied_count + 1;
                    free_count <= free_count - 1;
                end if;
                
                pulse_count := 0;
                
            -- Car departed
            ELSIF(sensor_pw_prev(placement) = '0' and space_distances(placement) > 0) then
                carexist(placement) <= '0';
                occupy(placement) <= '0';
                led(placement) <= '1';
                free_count <= free_count + 1;
                occupied_count <= occupied_count - 1;
            END IF;
        END IF;
    END PROCESS;

    -- Parking full indicator
    process (guest_count)
    begin
        full_out <= '0';
        if guest_count = max_guests then
            full_out <= '1';
        end if;
    end process;
	 ------------------------------------------------------------
	 process (free_count)
	 begin
			if (free_count = 0) then
				 seg <= "1111110";
				 seg2 <= "1111110";
				elsif (free_count = 1) then
				seg<="0110000";
				seg2 <= "1111110";
				elsif (free_count = 2) then
				seg<="1101101";
				seg2 <= "1111110";
				elsif (free_count = 3) then
				seg<="1111001";
				seg2 <= "1111110";
				elsif (free_count = 4) then
				seg<="0110011";
				seg2 <= "1111110";
				elsif (free_count = 5) then
				seg<="1011111";
				seg2 <= "1111110";
				elsif (free_count = 6) then
				seg<="1011111";
				seg2 <= "1111110";
				elsif (free_count = 7) then
				seg<="1110000";
				seg2 <= "1111110";
				elsif (free_count = 8) then
				seg<="1111111";
				seg2 <= "1111110";
				elsif (free_count = 9) then
				seg<="1111011";
				seg2 <= "1111110";
				elsif (free_count = 10) then
				 seg <= "1111110";
				 seg2<="0110000";
				elsif (free_count = 11) then
				seg<="0110000";
				seg2<="0110000";
				elsif (free_count = 12) then
				seg<="1101101";
				seg2<="0110000";
				elsif (free_count = 13) then
				seg<="1111001";
				seg2<="0110000";
				elsif (free_count = 14) then
				seg<="0110011";
				seg2<="0110000";
				elsif (free_count = 15) then
				seg<="1011111";
				seg2<="0110000";
				elsif (free_count = 16) then
				seg<="1011111";
				seg2<="0110000";
				elsif (free_count = 17) then
				seg<="1110000";
				seg2<="0110000";
				elsif (free_count = 18) then
				seg<="1111111";
				seg2<="0110000";
				elsif (free_count = 19) then
				seg<="1111011";
				seg2<="0110000";
				elsif (free_count = 20) then
				 seg <= "1111110";
				 seg2<="1101101";
				elsif (free_count = 21) then
				seg<="0110000";
				seg2<="1101101";
				elsif (free_count = 22) then
				seg<="1101101";
				seg2<="1101101";
				elsif (free_count = 23) then
				seg<="1111001";
				seg2<="1101101";
				elsif (free_count = 24) then
				seg<="0110011";
				seg2<="1101101";
				elsif (free_count = 25) then
				seg<="1011111";
				seg2<="1101101";
				elsif (free_count = 26) then
				seg<="1011111";
				seg2<="1101101";
				elsif (free_count = 27) then
				seg<="1110000";
				seg2<="1101101";
				elsif (free_count = 28) then
				seg<="1111111";
				seg2<="1101101";
				elsif (free_count = 29) then
				seg<="1111011";
				seg2<="1101101";
				elsif (free_count = 30) then
				 seg <= "1111110";
				 seg2<="1111001";
				elsif (free_count = 31) then
				seg<="0110000";
				seg2<="1111001";
				elsif (free_count = 32) then
				seg<="1101101";
				seg2<="1111001";
				elsif (free_count = 33) then
				seg<="1111001";
				seg2<="1111001";
				elsif (free_count = 34) then
				seg<="0110011";
				seg2<="1111001";
				elsif (free_count = 35) then
				seg<="1011111";
				seg2<="1111001";
				elsif (free_count = 36) then
				seg<="1011111";
				seg2<="1111001";
				elsif (free_count = 37) then
				seg<="1110000";
				seg2<="1111001";
				elsif (free_count = 38) then
				seg<="1111111";
				seg2<="1111001";
				elsif (free_count = 39) then
				seg<="1111011";
				seg2<="1111001";
				elsif (free_count = 40) then
				 seg <= "1111110";
				 seg2<="0110011";
				elsif (free_count = 41) then
				seg<="0110000";
				seg2<="0110011";
				elsif (free_count = 42) then
				seg<="1101101";
				seg2<="0110011";
				elsif (free_count = 43) then
				seg<="1111001";
				seg2<="0110011";
				elsif (free_count = 44) then
				seg<="0110011";
				seg2<="0110011";
				elsif (free_count = 45) then
				seg<="1011111";
				seg2<="0110011";
				elsif (free_count = 46) then
				seg<="1011111";
				seg2<="0110011";
				elsif (free_count = 47) then
				seg<="1110000";
				seg2<="0110011";
				elsif (free_count = 48) then
				seg<="1111111";
				seg2<="0110011";
				elsif (free_count = 49) then
				seg<="1111011";
				seg2<="0110011";
				elsif (free_count = 50) then
				 seg <= "1111110";
				 seg2<="1011111";
				end if;
end process;
    
end architecture behavior;
