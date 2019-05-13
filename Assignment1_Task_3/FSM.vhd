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

		enable_Multiplier_1,enable_Multiplier_2, enable_Multiplier_3 : out std_logic ;
		enable_MemRegA : out std_logic;
		enable_MemRegB : out std_logic;
		enable_StoreOutputRegA : out std_logic;
		
		-- Index Values for the 2 memory Blocks
		indexForMemA : out unsigned(1 downto 0);
		indexForMemB : out unsigned(1 downto 0);
		
		
		indexForMem_R : out unsigned(3 downto 0);
		memoryR_Write : out std_logic;
		resetOutputReg : out std_logic;
		resetRegStoreA, resetRegStoreB : out std_logic;
		counterValue : in std_logic_vector (3 downto 0);
		
		splitMemAReset, splitMemBReset : out std_logic;
		resetRegA, resetRegB, resetRegC : out std_logic;
		
		enableAdder: out std_logic;
		
		done_signal : out std_logic
	);

end entity;

architecture rtl of FSM is
	signal splitMemAReset_sig, splitMemBReset_sig : std_logic := '0';
	signal resetRegStore_A, resetRegStore_B, resetReg_A, resetReg_B, resetReg_C, fsmresetCounter : STD_LOGIC := '0';
	-- Build an enumerated type for the state machine
	type state_type is (StartState, X11, X12, X13,X21, X22, X23,X31, X32, X33, EndState);

	-- Register to hold the current state
	signal state : state_type;

begin

	process (clk, reset)
	variable resetCount : std_logic := '0'; 

	begin

		if reset = '1' then
			
			resetCounter <= '1';
			state <= StartState;
		elsif (rising_edge(clk)) then

			-- Determine the next state synchronously, based on
			-- the current state and the input
			case state is
			
			--First State is Start State
				when StartState=>
					if input = '1' then
						done_signal <= '0';
						state <= X11;
						resetCounter <= '0';
					else
						state <= startState;
						
					end if;
					
			--Element X11
				when X11=>
					if counterValue = "0111" then
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
					if counterValue = "0111" then
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
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= X21;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X13;
					end if;
					
				when X21=>
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= X22;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X21;
					end if;
				when X22=>
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= X23;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X22;
					end if;

				when X23=>
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= X31;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X23;
					end if;

				when X31=>
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= X32;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X31;
					end if;

				when X32=>
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= X33;
						resetCount := '1';
					else
					resetCounter <= '0';
					resetCount := '0';
						state <= X32;
					end if;
				when X33=>
					if counterValue = "0111" then
					resetCounter <= '1';
						state <= EndState;
						resetCount := '1';
						done_signal <= '1';
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
										
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "00"; --[11]
										indexForMemB <= "00"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0000";	
										memoryR_write <= '1';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '0';	
										indexForMem_R <= "0000";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																
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
										
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "00"; --[11]
										indexForMemB <= "01"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0001";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0001";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
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
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "00"; --[11]
										indexForMemB <= "10"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0010";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0010";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
					
				when X21=>
					if input = '1' then
										if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "01"; --[11]
										indexForMemB <= "00"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0011";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0011";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
				when X22=>
					if input = '1' then
										if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "01"; --[11]
										indexForMemB <= "01"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0100";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0100";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
				when X23=>
					if input = '1' then
										if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "01"; --[11]
										indexForMemB <= "10"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0101";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0101";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
				when X31=>
					if input = '1' then
										if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "10"; --[11]
										indexForMemB <= "00"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0110";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0110";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
				when X32=>
					if input = '1' then
										if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "10"; --[11]
										indexForMemB <= "01"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0111";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "0111";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
					end if;
						output <= "11";
					else
						output <= "10";
					end if;
				when X33=>
					if input = '1' then
										if(counterValue = "0000") then --1st Clock cycle
					--#Step 1
						--enable the Registers where the values from the memory will be held
										resetCounter <= '0';
										memoryR_write <= '0';
										enable_MemRegA <= '1';
										enable_MemRegB <= '1';
										--send the address values
										indexForMemA <= "10"; --[11]
										indexForMemB <= "10"; --[11]
										indexForMem_R <= "0000"; --First Value
										enable_Multiplier_1 <= '0';
										enable_Multiplier_2 <= '0';
										enable_Multiplier_3 <= '0';
					elsif (counterValue = "0001")then   --2nd Clock cycle
										
										--enable the multiplier 
										
										memoryR_Write <= '0';
										
			
					elsif (counterValue = "0010") then --2nd Clock cycle	 --After this cycle the adder starts working
										enable_Multiplier_1 <= '1';
										enable_Multiplier_2 <= '1';
										enable_Multiplier_3 <= '1';	
										
					elsif (counterValue = "0011") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "1000";	
										memoryR_write <= '0';			

					elsif (counterValue = "0100") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										
										enableAdder <= '1';	
										indexForMem_R <= "1000";	
											
										resetCounter <='0';	
					elsif (counterValue = "0101") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '1';	
										enableAdder <= '0';
										
					elsif (counterValue = "0110") then --2nd Clock cycle	 --After this cycle the adder starts working, so for next if statement
										memoryR_write <= '0';	
										enableAdder <= '0';										
																			
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

splitMemAReset <= splitMemAReset_sig;
splitMemBReset <= splitMemBReset_sig;
end rtl;
