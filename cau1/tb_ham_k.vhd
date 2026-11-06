--=============================================================================
-- TESTBENCH TU KIEM TRA (SELF-CHECKING) CHO CAU 1 - DE SO 2
-- Kiem tra day du 16 to hop minterm (0 den 15)
-- So sanh dau ra K voi danh sach minterm de bai Sigma_m(0,1,2,3,6,7,10,11,14,15)
-- Dung assert bao loi va dung mo phong neu rut gon sai
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ham_k is
end entity tb_ham_k;

architecture sim of tb_ham_k is
    -- Khai bao tin hieu noi voi DUT
    signal s_A, s_B, s_C, s_D : std_logic := '0';
    signal s_K               : std_logic;

    -- Ham xac dinh gia tri dung theo de bai goc Sigma_m
    function minterm_chuan(m : integer) return std_logic is
    begin
        case m is
            when 0 | 1 | 2 | 3 | 6 | 7 | 10 | 11 | 14 | 15 =>
                return '1';
            when others =>
                return '0';
        end case;
    end function;

begin
    -- Khoi tao DUT (Device Under Test)
    uut: entity work.ham_k
        port map (
            A => s_A,
            B => s_B,
            C => s_C,
            D => s_D,
            K => s_K
        );

    -- Qua trinh kich thich va kiem tra
    stim_proc: process
        variable vec   : unsigned(3 downto 0);
        variable k_exp : std_logic;
    begin
        report "==========================================================" severity note;
        report "BAT DAU MO PHONG CAU 1 - QUET 16 TO HOP MINTERM..." severity note;
        report "==========================================================" severity note;

        for i in 0 to 15 loop
            vec := to_unsigned(i, 4);
            s_A <= vec(3);
            s_B <= vec(2);
            s_C <= vec(1);
            s_D <= vec(0);

            -- Thoi gian truyen tin hieu
            wait for 10 ns;

            k_exp := minterm_chuan(i);

            -- Kiem tra ket qua bang assert
            assert s_K = k_exp
                report "LOI RUT GON TAI MINTERM m=" & integer'image(i) & 
                       " (ABCD=" & std_logic'image(s_A) & std_logic'image(s_B) & 
                       std_logic'image(s_C) & std_logic'image(s_D) & ")" &
                       " -> K thuc te = " & std_logic'image(s_K) & 
                       ", K ky vong = " & std_logic'image(k_exp)
                severity failure;
        end loop;

        report "==========================================================" severity note;
        report "KET QUA CAU 1: 16/16 TO HOP KHOP 100% VOI DE BAI!" severity note;
        report "BIEU THUC RUT GON K = (not A and not B) or C LA CHINH XAC!" severity note;
        report "==========================================================" severity note;

        wait; -- Dung mo phong
    end process;

end architecture sim;
