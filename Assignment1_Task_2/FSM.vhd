-- Quartus II VHDL Template


-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity FSM is

	port
	(
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

end entity;

architecture rtl of FSM is

	signal resetRegStore_A, resetRegStore_B, resetReg_A, resetReg_B, resetReg_C, fsmresetCounter : STD_LOGIC := '0';
	-- Build an enumerated type for the state machine
	type state_type is (StartState, X11, X12, X13, X21, X22, X23, X31, X32, X33, EndState);

	-- Register to hold the current state
	signal state : state_type;

begin

	process (clk, reset)
	variable resetCount : std_logic := '0'; 

	begin

		if reset = '1' then
			state <= StartState;
			resetCounter <= '1';
		elsif (rising_edge(clk)) then

			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
			
			--First State is Start State
				when StartState=>
					if input = '1' then
						Done_signal <= '0';
						state <= X11;
						resetCounter <= '0';
					else
						state <= startState;
						
					end if;
					
			--Element X11
				when X11=>
					if counterValue = "1110" then
						resetCounter <= '1';
						state <= X12;
						resetCount := '1';
					else
					resetCounter <= '0';
					   resetCount := '0';
						state <= X11;
					end if;
					
			--Element X12
				when X12=>
					if counterValue = "1110" then
						resetCounter <= '1';
						state <= X13;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X12;
					end if;
					
			--Element X13
			   when X13=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= X21;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X13;
					end if;
					
			--Element X21	
			   when X21=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= X22;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X21;
					end if;
			
			--Element X22
			   when X22=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= X23;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X22;
					end if;
					
			--Element X23
			   when X23=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= X31;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X23;
					end if;
					
		  -- Element X31
			   when X31=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= X32;
						resetCount := '1';
						
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X31;
					end if;
					
		  --Element X32
			   when X32=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= X33;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X32;
					end if;
		  --Element X33
			   when X33=>
					if counterValue = "1110" then
					resetCounter <= '1';
						state <= EndState;
						resetCount := '1';
						Done_signal <= '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X33;
					
					end if;
		  --EndState
				when EndState=>
					if counterValue = "1110" then
						state <= StartState;
					else
						state <= EndState;
					end if;

			end case;

		end if;
	end process;

	-- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, input, counterValue)
	variable addressA_var : std_logic_vector(3 downto 0) := "0000";
	variable addressB_var : std_logic_vector(3 downto 0) := "0000";
	variable addressR_var : std_logic_vector(3 downto 0) := "0000";
	variable enable_MemRegA_var : std_logic := '0';
	variable enable_MemRegB_var : std_logic := '0';
	variable enable_Multiplier_var : std_logic := '0';
	variable enable_StoreOutputRegA_var :std_logic := '0';
	
	begin
			case state is
				when StartState=>
					if input = '1' then
					
					
						
						
						output <= "00";
					else
						output <= "01";
					end if;
					
					
			   --X11
				when X11=>
					if input = '1' then
					
					if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0000"; --[11]
										indexForMemB <= "0000"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0001"; --[12]
										indexForMemB <= "0011"; --[21]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0010"; --[13]
										indexForMemB <= "0110"; --[31]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0000";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0000";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
					else
						output <= "11";
					end if;
					
			   
				--X12
				when X12=>
					if input = '1' then
					

							if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0000"; --[11]
										indexForMemB <= "0001"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0001"; --[12]
										indexForMemB <= "0100"; --[21]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0010"; --[13]
										indexForMemB <= "0111"; --[31]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0001";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0001";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
					
						output <= "10";
					else
						output <= "10";
					end if;
				
				--X13
				when X13=>
					if input = '1' then
					
					
												if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0000"; --[11]
										indexForMemB <= "0010"; --[13]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0001"; --[12]
										indexForMemB <= "0101"; --[23]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0010"; --[13]
										indexForMemB <= "1000"; --[31]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0010";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0010";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
					
					
					
					
						output <= "11";
					else
						output <= "10";
					end if;
					
					
			   --X21
				when X21=>
					if input = '1' then
					
																	if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0011"; --[21]
										indexForMemB <= "0000"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0100"; --[22]
										indexForMemB <= "0011"; --[21]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0101"; --[23]
										indexForMemB <= "0110"; --[31]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0011";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0011";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
					
					
						output <= "01";
					else
						output <= "11";
					end if;
			   
				--X22
				when X22=>
					if input = '1' then
					
													if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0011"; --[21]
										indexForMemB <= "0001"; --[12]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0100"; --[22]
										indexForMemB <= "0100"; --[22]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0101"; --[23]
										indexForMemB <= "0111"; --[32]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0100";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0100";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
					output <= "11";
					else
						output <= "10";
					end if;

				--X23
				when X23=>
				
					if input = '1' then
																	if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0011"; --[21]
										indexForMemB <= "0010"; --[13]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0100"; --[22]
										indexForMemB <= "0101"; --[23]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0101"; --[23]
										indexForMemB <= "1000"; --[33]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0101";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0101";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
						output <= "11";
					else
						output <= "10";
					end if;

				--X31
				when X31=>
					if input = '1' then
					
																	if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0110"; --[31]
										indexForMemB <= "0000"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0111"; --[32]
										indexForMemB <= "0011"; --[21]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "1000"; --[33]
										indexForMemB <= "0110"; --[31]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0110";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0110";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;

						output <= "01";
					else
						output <= "11";
					end if;
			   
				--X32
				when X32=>
					if input = '1' then
																	if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0110"; --[31]
										indexForMemB <= "0001"; --[12]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0111"; --[32]
										indexForMemB <= "0100"; --[22]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "1000"; --[33]
										indexForMemB <= "0111"; --[32]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0111";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "0111";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
						output <= "10";
					end if;
				
				--X33
				when X33=>
					if input = '1' then
																	if(counterValue = "0000") then --1st Clock cycle
							
					--#Step 1	
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0110"; --[31]
										indexForMemB <= "0010"; --[13]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier <= '0';
										outputToMuX <= "00";
					elsif (counterValue = "0001")then   --2nd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										--enable the multiplier 
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the RegA
					
					elsif (counterValue = "0010") then --3rd Clock cycle
										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';
										enable_Multiplier <= '0';
										outputToMuX <= "00"; -- store the value in the A register
					
					
					elsif (counterValue = "0011") then--1st Clock cycle

										enableReg_1<='1';
										enableReg_2<='1';
										enableReg_3<='1';	
										outputToMuX <= "00";									--#Step 2
										--enable the Registers where the values from the memory will be held
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "0111"; --[32]
										indexForMemB <= "0101"; --[23]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier <= '1';
					
					elsif (counterValue = "0100") then --2nd Clock Cycle
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										outputToMuX <= "00"; --to enable the Reg
							
					elsif (counterValue = "0101") then	--3rd Clock Cycle
										enable_Multiplier <= '1';
										outputToMuX <= "01"; -- store the value in the B register
					
					elsif (counterValue = "0110") then --1st Clock cycle
										--#Step 3
										enable_Multiplier <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "1000"; --[33]
										indexForMemB <= "1000"; --[33]
										indexForMem_R <= "0000"; --First Value
										--enable the multiplier 
										enable_Multiplier_var := '1';
											output <= "00";
											
										outputToMuX <= "01";
					elsif (counterValue = "0111") then --2nd Clock cycle	
										enable_Multiplier <= '1';
										memoryR_Write <= '0';
										indexForMem_R <= "0000";
										enableAdder <= '0';
										outputToMuX <= "01";
					elsif (counterValue = "1000") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
										outputToMuX <= "10";
					elsif (counterValue = "1001") then --2nd Clock cycle	
										output <= "10";
										enableAdder <= '0';
					elsif (counterValue = "1010") then --2nd Clock cycle	 --After this cycle the adder starts working
										output <= "10";
										enableAdder <= '1';	
										
					elsif (counterValue = "1011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "1000";	
										memoryR_write <= '1';			

					elsif (counterValue = "1100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										output <= "10";
										enableAdder <= '1';	
										indexForMem_R <= "1000";	
										memoryR_write <= '1';		
										resetCounter <='0';	
					elsif (counterValue = "1101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										enableAdder <= '0';
										memoryR_write <= '0';
											
																
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
					
			  when EndState=>
					if input = '1' then
						output <= "11";
					else
						output <= "10";
					end if;
			end case;
	end process;
resetRegStoreA <= resetRegStore_A;
resetRegStoreB <= resetRegStore_B;
resetRegA <= resetReg_A;
resetRegB <= resetReg_B;
resetRegC <= resetReg_C;
resetCounter <= fsmresetCounter;
end rtl;