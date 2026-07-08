--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:30:01 05/05/2025
-- Design Name:   
-- Module Name:   C:/Users/maihm/kkkkkkkk/testt.vhd
-- Project Name:  kkkkkkkk
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: parking_system
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Enhanced Testbench for Parking System
-- Features:
-- 1. Organized test sequences
-- 2. Detailed reporting
-- 3. Comprehensive assertions
-- 4. Realistic timing
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY testt IS
END testt;

ARCHITECTURE behavior OF testt IS 
    -- Component Declaration
    COMPONENT parking_system
    GENERIC(clk_freq : INTEGER := 40);
    PORT(
        ticket_in      : IN  integer;
        enter_time_in  : IN  integer;
        exit_time_in   : IN  integer;
        clk           : IN  std_logic;
        payment_out   : OUT integer;
        full_out      : OUT std_logic;
        id_valid      : IN  std_logic;
        car_entering  : INOUT std_logic;
        car_exiting   : INOUT std_logic;
        gate_open     : OUT std_logic;
        rst           : IN  std_logic;
        occupy        : INOUT  std_logic_vector(49 downto 0);
        led           : OUT std_logic_vector(49 downto 0);
        free_count    : INOUT natural;
        occupied_count: INOUT natural;
        seg           : OUT std_logic_vector(6 downto 0);
        seg2          : OUT std_logic_vector(6 downto 0);
        sensor_pw     : IN  STD_LOGIC_VECTOR(49 DOWNTO 0);
        carexist      : OUT STD_LOGIC_VECTOR(49 DOWNTO 0);
        placement     : IN  natural RANGE 0 to 49;
        check         : OUT integer;
        distance      : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        check_count   : OUT natural
    );
    END COMPONENT;

    -- Signals
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal ticket_in    : integer := 0;
    signal enter_time_in: integer := 0;
    signal exit_time_in : integer := 0;
    signal id_valid     : std_logic := '0';
    signal car_entering : std_logic := '0';
    signal car_exiting  : std_logic := '0';
    signal sensor_pw    : std_logic_vector(49 downto 0) := (others => '0');
    signal placement    : natural range 0 to 49 := 0;
    
    signal payment_out  : integer;
    signal full_out     : std_logic;
    signal gate_open    : std_logic;
    signal occupy       : std_logic_vector(49 downto 0) := (others => '0');
    signal led          : std_logic_vector(49 downto 0);
    signal free_count   : natural;
    signal occupied_count : natural;
    signal seg          : std_logic_vector(6 downto 0);
    signal seg2         : std_logic_vector(6 downto 0);
    signal carexist     : std_logic_vector(49 downto 0);
    signal check        : integer;
    signal distance     : std_logic_vector(7 downto 0);
    signal check_count  : natural;

    -- Clock period definitions
    constant CLK_PERIOD : time := 25 ns; -- 40MHz clock

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: parking_system PORT MAP (
        clk => clk,
        rst => rst,
        ticket_in => ticket_in,
        enter_time_in => enter_time_in,
        exit_time_in => exit_time_in,
        payment_out => payment_out,
        full_out => full_out,
        id_valid => id_valid,
        car_entering => car_entering,
        car_exiting => car_exiting,
        gate_open => gate_open,
        occupy => occupy,
        led => led,
        free_count => free_count,
        occupied_count => occupied_count,
        seg => seg,
        seg2 => seg2,
        sensor_pw => sensor_pw,
        carexist => carexist,
        placement => placement,
        check => check,
        distance => distance,
        check_count => check_count
    );

    -- Clock process
    clk_process: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
        procedure pulse_sensor(
            space : in natural;
            pulse_time : in time) is
        begin
            placement <= space;
            sensor_pw(space) <= '1';
            wait for pulse_time;
            sensor_pw(space) <= '0';
            wait for CLK_PERIOD;
        end procedure;
    begin
        report "Starting parking system testbench";
        
        -- Initialize Inputs
        rst <= '1';
        wait for 100 ns;
        
        -- Release Reset
        rst <= '0';
        wait for CLK_PERIOD*2;
        
        ------------------------------------------------------------------------
        -- Test Case 1: Valid ID Entry
        ------------------------------------------------------------------------
        report "Test Case 1: Valid ID Entry";
        id_valid <= '1';
        car_entering <= '1';
        wait for CLK_PERIOD*2;
        car_entering <= '0';
        
        -- Verify gate opened
        assert gate_open = '1' 
            report "Gate should open for valid ID entry" severity error;
        wait for CLK_PERIOD*2;
        
        ------------------------------------------------------------------------
        -- Test Case 2: Ticket Entry and Parking
        ------------------------------------------------------------------------
        report "Test Case 2: Ticket Entry and Parking";
        id_valid <= '0';
        ticket_in <= 1001;
        enter_time_in <= 0;
        car_entering <= '1';
        wait for CLK_PERIOD*2;
        car_entering <= '0';
        
        -- Simulate parking in space 0
        pulse_sensor(0, 150 ns); -- Short pulse = close distance
        wait for CLK_PERIOD*2;
        
        -- Verify space occupied
        assert occupy(0) = '1' 
            report "Space 0 should be occupied" severity error;
        assert led(0) = '0' 
            report "LED 0 should be ON (active low)" severity error;
        
        ------------------------------------------------------------------------
        -- Test Case 3: Vehicle Exit with Payment
        ------------------------------------------------------------------------
        report "Test Case 3: Vehicle Exit with Payment";
        exit_time_in <= 30; -- 30 minutes parking
        car_exiting <= '1';
        wait for CLK_PERIOD*2;
        car_exiting <= '0';
        
        -- Verify payment and gate
        assert payment_out = 60 
            report "Payment should be 60 (30*2)" severity error;
        assert gate_open = '1' 
            report "Gate should open for exit" severity error;
        wait for CLK_PERIOD*5;
        
        ------------------------------------------------------------------------
        -- Test Case 4: Multiple Parking Scenarios
        ------------------------------------------------------------------------
        report "Test Case 4: Multiple Parking Scenarios";
        
        -- Park in space 1
        ticket_in <= 1002;
        enter_time_in <= 0;
        car_entering <= '1';
        wait for CLK_PERIOD*2;
        car_entering <= '0';
        pulse_sensor(1, 180 ns);
        wait for CLK_PERIOD*2;
        
        -- Park in space 2
        ticket_in <= 1003;
        enter_time_in <= 0;
        car_entering <= '1';
        wait for CLK_PERIOD*2;
        car_entering <= '0';
        pulse_sensor(2, 200 ns);
        wait for CLK_PERIOD*2;
        
        -- Verify counts
        assert occupied_count = 2 
            report "Should have 2 occupied spaces" severity error;
        assert free_count = 48 
            report "Should have 48 free spaces" severity error;
        
        ------------------------------------------------------------------------
        -- Test Complete
        ------------------------------------------------------------------------
        report "All test cases completed";
        wait;
    end process;

END;