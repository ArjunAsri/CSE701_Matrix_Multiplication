library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM_tb is
end FSM_tb;

		
architecture beh of FSM_tb is
  --signal t_clk : std_logic := '0';
  signal t_input : std_logic := '1';
  signal t_countReached : std_logic;
  signal t_reset : std_logic;
  --signal t_resetCounter : std_logic;
  signal t_output : std_logic_vector(1 downto 0);
		--signal t_enable_Multiplier : std_logic ;
		--signal t_enable_MemRegA : std_logic;
		--signal t_enable_MemRegB : std_logic;
		signal t_enable_StoreOutputRegA : std_logic;
		
		-- Index Values for the 2 memory Blocks
		--signal t_indexForMemA : unsigned(3 downto 0);
		--signal t_indexForMemB : unsigned(3 downto 0);
		
		
		--signal t_indexForMem_R : unsigned(3 downto 0);
		--signal t_memoryR_Write : std_logic;
		signal t_resetOutputReg : std_logic;
		--signal t_resetRegStoreA, resetRegStoreB : std_logic;
		--signal t_counterValue :std_logic_vector (3 downto 0);
		
		--signal t_outputToMuX : std_logic_vector (1 downto 0);
		
		--signal t_resetRegA: std_logic;
		--signal t_resetRegB : std_logic;
		--signal t_resetRegC : std_logic;
		
		--signal t_enableAdder : std_logic;




signal clk_signal : std_logic := '0';
signal enableReg_1_sig, enableReg_2_sig, enableReg_3_sig: std_logic := '0';
signal adderInput_1, adderInput_2, adderInput_3 : unsigned(16 downto 0) :="00000000000000000";
signal enableAdder, enableMemA_Register, enableMemB_Register,enableMultiplier:std_logic := '0';
signal outputMemA_multiply, outputMemB_multiply  :unsigned(7 downto 0):= x"00";
signal inputToMux : std_logic_vector(1 downto 0);

signal memARegInput, memBRegInput : unsigned(7 downto 0):= x"00";
signal AdderToMemR: unsigned(16 downto 0):="00000000000000000";
signal multiplierToReg_1, multiplierToReg_2, multiplierToReg_3 :unsigned(16 downto 0):= "00000000000000000";
signal fsmWrite:std_logic := '0';
signal fsmResetRegA, fsmResetRegB : std_logic := '0';
signal fsmAddresstoA, fsmAddresstoB, fsmAddresstoR :unsigned(3 downto 0) := x"0";
signal fsmCounterReset: std_logic := '0';
signal counterToFsm :std_logic_vector (3 downto 0):= x"0";
signal fsmResetReg1, fsmResetReg2, fsmResetReg3 : std_logic:= '0';
signal counterResetSpecial: std_logic := '0';
signal memROutput : unsigned(16 downto 0);
signal done_sig : std_logic;
  component FSM is
    port (

 		clk		 : in	std_logic;
		input	 : in	std_logic;
		countReached	 : in	std_logic; --countReached signal will signal the start of the next calculation
		reset	 : in	std_logic;
		resetCounter : out std_logic;	--after the countReached has been received rsetCounter will be needed to reset the counter
		
		output	 : out	std_logic_vector(1 downto 0);

		enable_Multiplier : out std_logic ;
		enable_MemRegA : out std_logic;
		enable_MemRegB : out std_logic;
		enable_StoreOutputRegA : out std_logic;
		
		-- Index Values for the 2 memory Blocks
		indexForMemA : out unsigned(3 downto 0);
		indexForMemB : out unsigned(3 downto 0);
		
		
		indexForMem_R : out unsigned(3 downto 0);
		memoryR_Write : out std_logic;
		resetOutputReg : out std_logic;
		resetRegStoreA, resetRegStoreB : out std_logic;
		counterValue : in std_logic_vector (3 downto 0);
		
		outputToMuX : out std_logic_vector (1 downto 0);
		
		resetRegA, resetRegB, resetRegC : out std_logic;
		
		enableAdder,enableReg_1, enableReg_2, enableReg_3 : out std_logic;
		Done_signal : out std_logic
	 );
	 end component FSM;
-----------------Mux----------------------
component Mux
port(
	clk : in std_logic;
	input: in std_logic_vector (1 downto 0);
	enableRegA : out std_logic;
	enableRegB : out std_logic;
	enableRegC : out std_logic

);
end component;

-----------Counter----------------
component Counter
	port(
	clk, reset : in std_logic;
	output: out std_logic_vector(3 downto 0)
	
	);
end component;

---------------------------------------
------------Adder------------------
component Adder
port( 
		clk : in std_logic;
		input_1, input_2, input_3 : in unsigned (16 downto 0);
		enable : in std_logic;
		output : out unsigned (16 downto 0)
		);
		
end component;

-------------Muliplier-----------------
component Multiplier
	port(
	clk : in std_logic;
	enable : in std_logic;
	inputA :in unsigned(7 downto 0);
	inputB : in unsigned (7 downto 0);
	output : out unsigned(16 downto 0)
	
	);
end component;

-----------------reg----------------

component reg
	port(
	clk : in std_logic;
	enable : in std_logic;
	reset :in std_logic;
	inputA : in unsigned (16 downto 0);
	output : out unsigned(16 downto 0)
	
	);
end component;


-------------------regStore------------------

component regStore
	port(
	clk : in std_logic;
	enable : in std_logic;
	reset :in std_logic;
	input : in unsigned (7 downto 0);
	output : out unsigned(7 downto 0)
	
	);
end component;

----------------memory_r------------------

component memory_r
port(
  clk     : in std_logic;
    wr      : in std_logic;
    addr    : in unsigned(3 downto 0);
    q       : in unsigned(16 downto 0);
	output : out unsigned(16 downto 0)
	 );
end component;
----------------memory_a------------------

component memory_a
port (
    clk     : in std_logic;
    addr    : in unsigned(3 downto 0);
    q       : out unsigned(7 downto 0)
);
end component;
----------------memory_b------------------

component memory_b
port (
    clk     : in std_logic;
    addr    : in unsigned(3 downto 0);
    q       : out unsigned(7 downto 0)
);
end component;



	 begin
	
	counter_inst : Counter port map(
		clk =>clk_signal,
		reset =>fsmCounterReset,
	   	output =>counterToFsm


	);

	FSM_int	: FSM port map(
	     	clk    => clk_signal,
	     	input => t_input,
	     	countReached => t_countReached,
	     	reset => t_reset,
	        resetCounter => fsmCounterReset,
	        output => t_output,
	     	enable_Multiplier => enableMultiplier,
		enable_MemRegA => enableMemA_Register,
		enable_MemRegB => enableMemB_Register,
		enable_StoreOutputRegA => t_enable_StoreOutputRegA,
		indexForMemA => fsmAddresstoA,
		indexForMemB => fsmAddresstoB,
		indexForMem_R => fsmAddresstoR,
		memoryR_write => fsmWrite,
		resetOutputReg => t_resetOutputReg,
		resetRegStoreA => fsmResetRegA,
		resetRegStoreB => fsmResetRegB,
		counterValue => counterToFsm,
		outputToMux => inputToMux,
		resetRegA => fsmResetReg1,
		resetRegB => fsmResetReg2,
		resetRegC => fsmResetReg3,
		enableAdder => enableAdder,
		enableReg_1 => enableReg_1_sig,
		enableReg_2 => enableReg_2_sig,
		enableReg_3 => enableReg_3_sig,
		Done_signal => Done_sig

	);

	memory_A_register : regStore port map (
		clk => clk_signal,
		enable => enableMemA_Register,
		reset =>fsmResetRegA,
		input =>memARegInput,
		output => outputMemA_multiply
	);
	
	memory_B_register : regStore port map(
		clk =>clk_signal,
		enable => enableMemB_Register,
		reset =>fsmResetRegB,
		input =>memBRegInput,
		output =>outputMemB_multiply
	);
	
	memory_Reg_1 : reg port map(
		clk =>clk_signal,
		enable => enableReg_1_sig,
		reset =>fsmResetReg1,
		inputA =>multiplierToReg_1, --ONE OUTPUT FROM Multiplier but same inputs to same register
		output => adderInput_1
	);
	
	memory_Reg_2 : reg port map(
		clk => clk_signal,
		enable => enableReg_2_sig,
		reset => fsmResetReg2,
		inputA =>multiplierToReg_1,
		output => adderInput_2
	);
	
	memory_Reg_3 : reg port map(
		clk =>clk_signal,
		enable => enablereg_3_sig,
		reset =>fsmResetReg3,
		inputA =>multiplierToReg_1,
		output => adderInput_3

	);

	
	Adder_1 :Adder port map(
		clk =>clk_signal,
		input_1 => adderInput_1,
		input_2 => adderInput_2,
		input_3 => adderInput_3,
		enable =>enableAdder,
		output => AddertoMemR
	
	);
	
	
	Memory_Write :memory_r port map(

 clk     => clk_signal,
    wr      =>fsmWrite,
    addr    =>fsmAddresstoR,
    q      => AddertoMemR,
output => memROutput
	);
	
	Memory_A_1 :memory_a port map(
    clk    =>clk_signal,
    addr   =>fsmAddresstoA,
    q       =>memARegInput
	);
	
	Memory_B_1 :memory_b port map(
	    clk    =>clk_signal,
    addr   =>fsmAddresstoB,
    q       => memBRegInput
	);
	
	Mux_1 : mux port map(
		clk  =>clk_signal,
		input =>inputToMux,
		enableRegA =>enableReg_1_sig,
		enableRegB =>enableReg_2_sig,
		enableRegC =>enableReg_3_sig
	);

	Multiplier_1 : multiplier port map(
		clk =>clk_signal,
		enable =>enableMultiplier,
		inputA =>outputMemA_multiply,
		inputB =>outputMemB_multiply,
		
		output => multiplierToReg_1

	
	);
-- Add other components 

	   
	   FSM_proces: process 
	     begin
	  
	  wait for 20 ns;    
	       
	     t_input <= '1';
	    -- counterToFSM <= "0000";

	    -- counterToFSM <= "0000";

	   end process;



clk_process: process
        begin
          clk_signal <= '0';
        wait for 10 ns;
          clk_signal <= '1';
        wait for 10 ns;
        
    end process;
end beh;
	       
	       
	       
	       
	   
      
  

