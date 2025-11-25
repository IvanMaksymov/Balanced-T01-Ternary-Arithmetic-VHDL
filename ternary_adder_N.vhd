library ieee;
use ieee.std_logic_1164.all;

entity ternary_adder_n is
    generic (
        N : integer := 6    -- number of trits
    );
    port (
        A    : in  std_logic_vector(2*N-1 downto 0);  -- packed A input
        B    : in  std_logic_vector(2*N-1 downto 0);  -- packed B input
        Cin  : in  std_logic_vector(1 downto 0);      -- one trit
        Sum  : out std_logic_vector(2*N-1 downto 0);  -- packed sum
        Cout : out std_logic_vector(1 downto 0)       -- final carry trit
    );
end entity;

architecture rtl of ternary_adder_n is

    -- Trit array type (each trit = 2 bits)
    type trit_array is array (natural range <>) of std_logic_vector(1 downto 0);

    -- Carry chain (C(0)=Cin, C(N)=Cout)
    signal C : trit_array(0 to N);
    
    -- Internal sum trits
    signal S : trit_array(0 to N-1);

begin

    -- Initialise carry-in
    C(0) <= Cin;

    -- Instantiate N ternary full adders
    gen_adders : for i in 0 to N-1 generate
        constant lo : integer := 2*i;
        constant hi : integer := 2*i + 1;
    begin
        fa_inst : entity work.ternary_full_adder
            port map (
                A    => A(hi downto lo),
                B    => B(hi downto lo),
                Cin  => C(i),
                Sum  => S(i),
                Cout => C(i+1)
            );
    end generate;

    -- Pack S(i) into output vector
    process(S)
        variable tmp : std_logic_vector(2*N-1 downto 0);
    begin
        for i in 0 to N-1 loop
            tmp(2*i+1 downto 2*i) := S(i);
        end loop;
        Sum <= tmp;
    end process;

    -- Final carry
    Cout <= C(N);

end architecture;
