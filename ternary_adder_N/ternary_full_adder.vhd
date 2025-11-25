library ieee;
use ieee.std_logic_1164.all;

entity ternary_full_adder is
    port (
        A    : in  std_logic_vector(1 downto 0); 
        B    : in  std_logic_vector(1 downto 0);
        Cin  : in  std_logic_vector(1 downto 0);
        Sum  : out std_logic_vector(1 downto 0);
        Cout : out std_logic_vector(1 downto 0)
    );
end entity;

architecture lut of ternary_full_adder is

    -- Trit encoding:
    -- "10" = T
    -- "00" = 0
    -- "01" = 1

    type trit_array is array (0 to 2) of std_logic_vector(1 downto 0);
    constant TRIT : trit_array := (
        0 => "10",  -- T
        1 => "00",  -- 0
        2 => "01"   -- 1
    );

    -- ADDITION OF TWO TRITS: LUT2(a,b)
    -- result is a 2-trit value: {carry, sum}
    type lut2_t is array (0 to 2, 0 to 2) of std_logic_vector(3 downto 0);
    constant LUT2 : lut2_t := (
        -- b =   T       0        1
        ( "10" & "01", "00" & "10", "00" & "00"),  -- a=T  => T1, T, 0
        ( "00" & "10", "00" & "00", "00" & "01"),  -- a=0  => T, 0, 1
        ( "00" & "00", "00" & "01", "01" & "10")   -- a=1  => 0, 1, 1T
    );

    -- Convert trit to index 0..2
    function idx(t : std_logic_vector(1 downto 0)) return integer is
    begin
        if t = "10" then return 0; -- T
        elsif t = "00" then return 1; -- 0
        else return 2; -- 1
        end if;
    end function;

    -------------------------------------------------------------------
    --  Helper functions to print internal vectors
    -------------------------------------------------------------------

    --function slv2_to_str(x : std_logic_vector(1 downto 0)) return string is
    --begin
    --    return std_logic'image(x(1)) & std_logic'image(x(0));
    --end function;

    --function slv4_to_str(x : std_logic_vector(3 downto 0)) return string is
    --begin
    --    return std_logic'image(x(3)) &
    --           std_logic'image(x(2)) &
    --           std_logic'image(x(1)) &
    --           std_logic'image(x(0));
    --end function;

    signal s1, c1 : std_logic_vector(1 downto 0);
    signal s2, c2 : std_logic_vector(1 downto 0);

begin

    process(A,B,Cin)
        variable tmp       : std_logic_vector(3 downto 0);
        variable tmp_carry : std_logic_vector(3 downto 0);
        variable v_c1, v_s1 : std_logic_vector(1 downto 0);
        variable v_c2, v_s2 : std_logic_vector(1 downto 0);
    begin
        -------------------------------------------------------------------
        -- Step 1: (A + B)
        -------------------------------------------------------------------
        tmp := LUT2(idx(A), idx(B));
        v_c1 := tmp(3 downto 2);  -- carry trit
        v_s1 := tmp(1 downto 0);  -- sum trit

        --report "STEP1 A=" & slv2_to_str(A) &
        --       " B=" & slv2_to_str(B) &
        --       " tmp=" & slv4_to_str(tmp) &
        --       " c1=" & slv2_to_str(v_c1) &
        --       " s1=" & slv2_to_str(v_s1);

        -- assign to signals
        c1 <= v_c1;
        s1 <= v_s1;

        -------------------------------------------------------------------
        -- Step 2: (s1 + Cin)
        -------------------------------------------------------------------
        tmp := LUT2(idx(v_s1), idx(Cin));
        v_c2 := tmp(3 downto 2);
        v_s2 := tmp(1 downto 0);

        --report "STEP2 s1=" & slv2_to_str(v_s1) &
        --       " Cin=" & slv2_to_str(Cin) &
        --       " tmp=" & slv4_to_str(tmp) &
        --       " c2=" & slv2_to_str(v_c2) &
        --       " s2=" & slv2_to_str(v_s2);

        -- assign to signals
        c2 <= v_c2;
        s2 <= v_s2;

        -------------------------------------------------------------------
        -- Final sum
        -------------------------------------------------------------------
        Sum <= v_s2;

        -------------------------------------------------------------------
        -- Final carry = c1 + c2 using LUT
        -------------------------------------------------------------------
        tmp_carry := LUT2(idx(v_c1), idx(v_c2));

        --report "STEP3 c1=" & slv2_to_str(v_c1) &
        --       " c2=" & slv2_to_str(v_c2) &
        --       " tmp_carry=" & slv4_to_str(tmp_carry);

        --Cout <= tmp_carry(3 downto 2);  -- final carry only, WRONG result (!)
        Cout <= tmp_carry(1 downto 0);  -- final carry = sum, since we do not expect to have an extra carry (?)

    end process;

end architecture;
