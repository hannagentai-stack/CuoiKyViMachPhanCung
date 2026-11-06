--=============================================================================
-- TESTBENCH TU KIEM TRA (SELF-CHECKING) CHO CAU 2 - DE SO 2
-- Kiem tra day du cac truong hop:
-- 1. Khong co dau vao nao tich cuc (I = 00000000)
-- 2. Tung dau vao tich cuc mot minh (8 truong hop)
-- 3. Nhieu dau vao cung tich cuc de kiem tra tinh uu tien
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ma_hoa_8_3 is
end entity tb_ma_hoa_8_3;

architecture sim of tb_ma_hoa_8_3 is
    signal s_I : std_logic_vector(7 downto 0) := (others => '0');
    signal s_Y : std_logic_vector(2 downto 0);
    signal s_V : std_logic;
begin
    uut: entity work.ma_hoa_8_3
        port map (
            I => s_I,
            Y => s_Y,
            V => s_V
        );

    stim_proc: process
    begin
        report "==========================================================" severity note;
        report "BAT DAU MO PHONG CAU 2 - BO MA HOA UU TIEN 8 SANG 3..." severity note;
        report "==========================================================" severity note;

        -- 1. Kiem tra khi KHONG co dau vao nao tich cuc
        s_I <= "00000000";
        wait for 20 ns;
        assert (s_V = '0' and s_Y = "000")
            report "Loi tai I=00000000: V phai bang 0" severity failure;

        -- 2. Kiem tra lan luot TUNG dau vao tich cuc mot minh
        s_I <= "00000001"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "000") report "Loi tai I0=1" severity failure;

        s_I <= "00000010"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "001") report "Loi tai I1=1" severity failure;

        s_I <= "00000100"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "010") report "Loi tai I2=1" severity failure;

        s_I <= "00001000"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "011") report "Loi tai I3=1" severity failure;

        s_I <= "00010000"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "100") report "Loi tai I4=1" severity failure;

        s_I <= "00100000"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "101") report "Loi tai I5=1" severity failure;

        s_I <= "01000000"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "110") report "Loi tai I6=1" severity failure;

        s_I <= "10000000"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "111") report "Loi tai I7=1" severity failure;

        -- 3. Kiem tra NHIEU dau vao cung tich cuc (Test tinh uu tien)
        -- TH3.1: I(1) va I(0) cung = 1 -> I(1) uu tien hon
        s_I <= "00000011"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "001") report "Loi uu tien tai I=00000011 (phai uu tien I1)" severity failure;

        -- TH3.2: I(5), I(3), I(1) cung = 1 -> I(5) uu tien nhat
        s_I <= "00101010"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "101") report "Loi uu tien tai I=00101010 (phai uu tien I5)" severity failure;

        -- TH3.3: I(7) va I(0) cung = 1 -> I(7) uu tien nhat
        s_I <= "10000001"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "111") report "Loi uu tien tai I=10000001 (phai uu tien I7)" severity failure;

        -- TH3.4: Tat ca cac bit deu = 1 -> I(7) uu tien nhat
        s_I <= "11111111"; wait for 20 ns;
        assert (s_V = '1' and s_Y = "111") report "Loi uu tien tai I=11111111 (phai uu tien I7)" severity failure;

        report "==========================================================" severity note;
        report "KET QUA CAU 2: TESTBENCH BO MA HOA UU TIEN CHAY DUNG 100%!" severity note;
        report "==========================================================" severity note;

        wait;
    end process;

end architecture sim;
