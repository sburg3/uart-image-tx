----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/27/2015 07:11:42 PM
-- Design Name: 
-- Module Name: UARTImageTx - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTImageTx is
    Port ( CLK100MHZ : in STD_LOGIC;
           UART_TXD_IN : in STD_LOGIC;
           SW : in STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           VGA_HS : out STD_LOGIC;
           VGA_R : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out STD_LOGIC_VECTOR (3 downto 0));
end UARTImageTx;

architecture Behavioral of UARTImageTx is

component UARTReceiver is
    Generic ( baud : integer := 115200);
    Port ( UART_TXD_IN : in STD_LOGIC;
           CLK100MHZ : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           data_ready : out STD_LOGIC);
end component;

component VGADriver is
    Port ( VGA_HS : out STD_LOGIC;
           VGA_VS : out STD_LOGIC;
           pixel_row : out STD_LOGIC_VECTOR (10 downto 0);
           pixel_col : out STD_LOGIC_VECTOR (10 downto 0);
           enable : out STD_LOGIC;
           clk_VGA : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component clk_wiz_0
port
 (-- Clock in ports
  clk_in1           : in     std_logic;
  -- Clock out ports
  clk_out1          : out    std_logic
 );
end component;

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal uart_data : std_logic_vector(7 downto 0) := x"00";
signal uart_rdy : std_logic := '0';

signal clk_vga : std_logic := '0';
--signal row : unsigned(10 downto 0) := "000000000";
--signal col : unsigned(10 downto 0) := "000000000";
signal ena : std_logic := '0';

signal wea : std_logic_vector(0 downto 0) := "0";
signal write_addr : unsigned(18 downto 0) := "0000000000000000000";
signal read_addr : unsigned(18 downto 0) := "0000000000000000010";
signal mem_data_out : std_logic_vector(7 downto 0) := "00000000";
signal mem_data_in : std_logic_vector(7 downto 0) := "00000000";

signal reset : std_logic := '1';

constant MAX_ADDR : integer := 307199;

begin

ur0 : UARTReceiver
port map (
    UART_TXD_IN => UART_TXD_IN,
    CLK100MHZ => CLK100MHZ,
    data_out => uart_data,
    data_ready => uart_rdy
);

vd0 : VGADriver
port map (
    VGA_HS => VGA_HS,
    VGA_VS => VGA_VS,
    pixel_row => open,
    pixel_col => open,
    enable => ena,
    clk_VGA => clk_vga,
    reset => reset
);

cw0 : clk_wiz_0
   port map ( 

   -- Clock in ports
   clk_in1 => CLK100MHZ,
  -- Clock out ports  
   clk_out1 => clk_vga              
 );

bmg0 : blk_mem_gen_0
  PORT MAP (
    clka => CLK100MHZ,
    wea => wea,
    addra => std_logic_vector(write_addr),
    dina => mem_data_in,
    clkb => clk_vga,
    addrb => std_logic_vector(read_addr),
    doutb => mem_data_out
  );

process(CLK100MHZ)
begin
    if rising_edge(CLK100MHZ) then
        if uart_rdy = '1' then
            wea <= "1";
            mem_data_in <= uart_data;
            if write_addr < MAX_ADDR then
                write_addr <= write_addr + 1;
            else
                write_addr <= "0000000000000000000";
            end if;
        else
            wea <= "0";
        end if;
    end if;
end process;

process(clk_vga)
begin
    if rising_edge(clk_vga) then
        if reset = '1' then
            read_addr <= "0000000000000000010";
        else
            if ena = '1' then
                if read_addr < MAX_ADDR then
                    read_addr <= read_addr + 1;
                else
                    read_addr <= "0000000000000000000";
                end if;
            end if;
        end if;
    end if;
end process;

reset <= SW;

VGA_R <= mem_data_out(7) & mem_data_out(6) & mem_data_out(5) & mem_data_out(5) when ena = '1' else "0000";
VGA_G <= mem_data_out(4) & mem_data_out(3) & mem_data_out(2) & mem_data_out(2) when ena = '1' else "0000";
VGA_B <= mem_data_out(1) & mem_data_out(1) & mem_data_out(0) & mem_data_out(0) when ena = '1' else "0000";

end Behavioral;
