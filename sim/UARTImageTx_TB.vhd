----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/27/2015 10:11:47 PM
-- Design Name: 
-- Module Name: UARTImageTx_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTImageTx_TB is
--  Port ( );
end UARTImageTx_TB;

architecture Behavioral of UARTImageTx_TB is
component UARTImageTx is
    Port ( CLK100MHZ : in STD_LOGIC;
           UART_TXD_IN : in STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           VGA_HS : out STD_LOGIC;
           VGA_R : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out STD_LOGIC_VECTOR (3 downto 0));
end component;

signal clk_100 : std_logic := '0';
signal txd : std_logic := '1';
signal vs : std_logic := '1';
signal hs : std_logic := '1';
signal red : std_logic_vector(3 downto 0) := x"0";
signal gre : std_logic_vector(3 downto 0) := x"0";
signal blu : std_logic_vector(3 downto 0) := x"0";

constant BAUD : time := 8.6806us;

begin

uit0 : UARTImageTX
port map (
    CLK100MHZ => clk_100,
    UART_TXD_IN => txd,
    VGA_VS => vs,
    VGA_HS => hs,
    VGA_R => red,
    VGA_G => gre,
    VGA_B => blu
);

clk_100 <= not clk_100 after 5 ns;

process
begin
wait for 17ms;
assert false report "Simulation ended" severity failure;
end process;

process
begin
    wait for 20us;
    txd <= '0';
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    wait for 20us;
    txd <= '0';
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '0';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
    txd <= '1';   
    wait for BAUD;
end process;
end Behavioral;
