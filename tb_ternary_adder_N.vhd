library ieee;
use ieee.std_logic_1164.all;

entity tb_ternary_adder_n is
end entity;

architecture sim of tb_ternary_adder_n is

    constant N : integer := 6;

    -- Each number has N trits → 2*N bits
    signal A, B, Sum : std_logic_vector(2*N-1 downto 0);
    signal Cin, Cout : std_logic_vector(1 downto 0);

    -- Trit definitions
    type trit_array is array (0 to 2) of std_logic_vector(1 downto 0);
    constant TRIT : trit_array := (
        0 => "10",  -- T
        1 => "00",  -- 0
        2 => "01"   -- 1
    );

    -- Convert 2-bit vector to trit string
    function slv_to_trit(slv : std_logic_vector(1 downto 0)) return string is
    begin
        if slv = "10" then
            return "T";
        elsif slv = "00" then
            return "0";
        elsif slv = "01" then
            return "1";
        else
            return "?";
        end if;
    end function;

    -- Convert packed vector of N trits to string
    function vec_to_trit_str(vec : std_logic_vector) return string is
        variable s : string(1 to N);
        --variable i : integer;
    begin
        for i in 0 to N-1 loop
            s(i+1) := slv_to_trit(vec(2*(N-i)-1 downto 2*(N-i-1)))(1);
        end loop;
        return s;
    end function;

begin

    --------------------------------------------------------------------
    -- DUT instantiation
    --------------------------------------------------------------------
    dut: entity work.ternary_adder_n
        generic map (N => N)
        port map (
            A    => A,
            B    => B,
            Cin  => Cin,
            Sum  => Sum,
            Cout => Cout
        );

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    process
        variable ai, bi, ci : integer;
        variable tempA, tempB : std_logic_vector(2*N-1 downto 0);
        variable idx, idxB : integer;
    begin
        -- Loop over all trit combinations for small numbers
        for ci in 0 to 2 loop
            Cin <= TRIT(ci);
            for ai in 0 to 26 loop   -- 3^3 = 27 for 3-trit numbers
                -- Convert ai index to trits
                tempA := (others => '0');
                idx := ai;
				for i in 0 to N-1 loop
				    tempA(2*(N-i)-1 downto 2*(N-i-1)) := TRIT(idx mod 3);
				    idx := idx / 3;
				end loop;

                A <= tempA;

                for bi in 0 to 26 loop
                    tempB := (others => '0');
                    idxB := bi;
					for i in 0 to N-1 loop
					    tempB(2*(N-i)-1 downto 2*(N-i-1)) := TRIT(idxB mod 3);
					    idxB := idxB / 3;
					end loop;

                    B <= tempB;

                    wait for 10 ns;
                    report "A=" & vec_to_trit_str(A) &
                           " B=" & vec_to_trit_str(B) &
                           " Cin=" & slv_to_trit(Cin) &
                           " | Sum=" & vec_to_trit_str(Sum) &
                           " Cout=" & slv_to_trit(Cout);
                end loop;
            end loop;
        end loop;

        wait;
    end process;

end architecture;
