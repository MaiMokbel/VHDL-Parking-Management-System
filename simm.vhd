--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:04:25 05/05/2025
-- Design Name:   
-- Module Name:   C:/Users/maihm/kkkkkkkk/simm.vhd
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simm IS
END simm;
 
ARCHITECTURE behavior OF simm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT parking_system
    PORT(
         ticket_in : IN  std_logic;
         enter_time_in : IN  std_logic;
         exit_time_in : IN  std_logic;
         clk : IN  std_logic;
         payment_out : OUT  std_logic;
         full_out : OUT  std_logic;
         id_valid : IN  std_logic;
         car_entering : IN  std_logic;
         car_exiting : IN  std_logic;
         gate_open : OUT  std_logic;
         rst : IN  std_logic;
         occupy : INOUT  std_logic_vector(49 downto 0);
         led : OUT  std_logic_vector(49 downto 0);
         free_count : INOUT  std_logic_vector(0 to 30);
         occupied_count : INOUT  std_logic_vector(0 to 30);
         seg : OUT  std_logic_vector(6 downto 0);
         seg2 : OUT  std_logic_vector(6 downto 0);
         sensor_pw : IN  std_logic_vector(49 downto 0);
         carexist : OUT  std_logic_vector(49 downto 0);
         placement : IN  std_logic_vector(0 to 5);
         check : OUT  std_logic;
         check_count : OUT  std_logic_vector(0 to 30);
         distance : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ticket_in : std_logic := '0';
   signal enter_time_in : std_logic := '0';
   signal exit_time_in : std_logic := '0';
   signal clk : std_logic := '0';
   signal id_valid : std_logic := '0';
   signal car_entering : std_logic := '0';
   signal car_exiting : std_logic := '0';
   signal rst : std_logic := '0';
   signal sensor_pw : std_logic_vector(49 downto 0) := (others => '0');
   signal placement : std_logic_vector(0 to 5) := (others => '0');

	--BiDirs
   signal occupy : std_logic_vector(49 downto 0);
   signal free_count : std_logic_vector(0 to 30);
   signal occupied_count : std_logic_vector(0 to 30);
   signal distance : std_logic_vector(7 downto 0);

 	--Outputs
   signal payment_out : std_logic;
   signal full_out : std_logic;
   signal gate_open : std_logic;
   signal led : std_logic_vector(49 downto 0);
   signal seg : std_logic_vector(6 downto 0);
   signal seg2 : std_logic_vector(6 downto 0);
   signal carexist : std_logic_vector(49 downto 0);
   signal check : std_logic;
   signal check_count : std_logic_vector(0 to 30);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: parking_system PORT MAP (
          ticket_in => ticket_in,
          enter_time_in => enter_time_in,
          exit_time_in => exit_time_in,
          clk => clk,
          payment_out => payment_out,
          full_out => full_out,
          id_valid => id_valid,
          car_entering => car_entering,
          car_exiting => car_exiting,
          gate_open => gate_open,
          rst => rst,
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
          check_count => check_count,
          distance => distance
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
        rst <= '1';
        clk <= '0';
      wait for 100 ns;	
 
        wait for CLK_PERIOD
        
        
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
