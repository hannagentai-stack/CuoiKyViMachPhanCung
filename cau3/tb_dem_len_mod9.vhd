--=============================================================================
-- TESTBENCH MO PHONG BO DEM MOD-9 DEM LEN DONG BO (CAU 3 - DE SO 2)
-- Ghi de generic DB_LIMIT = 5 va DIV_LIMIT = 10 de mo phong nhanh tren ModelSim
-- Kiem chung:
-- 1. Nhan giu nut khong lam bo dem chay lien tuc
-- 2. Nut doi nhieu lan nhung mach chong doi loc sach, chi sinh dung 1 buoc dem
-- 3. Canh nhay dem sinh ra khi THA tay (Active-Low)
-- 4. Che do tu dong 5 Hz tu chay lien tuc, quay vong tu 8 ve 0
-- 5. Chan bao LEDG0 len 1 khi Q = 8
-- 6. Xoa bat dong bo bang KEY0 (rst_n)
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_dem_len_mod9 is
end entity tb_dem_len_mod9;

architecture sim of tb_dem_len_mod9 is

    -- Hang so chu ky clock 50 MHz (20 ns)
    constant CLK_PERIOD : time := 20 ns;

    -- Tin hieu noi voi DUT
    signal s_clk    : std_logic := '0';
    signal s_rst_n  : std_logic := '1';
    signal s_nut    : std_logic := '1'; -- Mac dinh tha tay ('1')
    signal s_tudong : std_logic := '0'; -- Mac dinh che do tay ('0')
    signal s_Q      : std_logic_vector(3 downto 0);
    signal s_bao    : std_logic;
    signal s_HEX0   : std_logic_vector(6 downto 0);

begin

    -- Khoi tao DUT voi Generic nho de mo phong nhanh
    uut: entity work.dem_len_mod9
        generic map (
            DB_LIMIT  => 5,  -- 5 chu ky clock la loc xong doi
            DIV_LIMIT => 10  -- 10 chu ky clock la 1 buoc dem tu dong
        )
        port map (
            clk    => s_clk,
            rst_n  => s_rst_n,
            nut    => s_nut,
            tudong => s_tudong,
            Q      => s_Q,
            bao    => s_bao,
            HEX0   => s_HEX0
        );

    -- Tao xung nhip CLOCK_50 (chu ky 20 ns)
    clk_process: process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD / 2;
        s_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Kich thich kiem thu
    stim_proc: process
    begin
        report "==========================================================" severity note;
        report "BAT DAU MO PHONG CAU 3 - BO DEM MOD-9 DEM LEN..." severity note;
        report "==========================================================" severity note;

        -- 1. Reset he thong bang KEY0 (rst_n = '0')
        s_rst_n  <= '0';
        s_nut    <= '1';
        s_tudong <= '0';
        wait for 50 ns;
        s_rst_n  <= '1';
        wait for 40 ns;

        assert s_Q = "0000"
            report "Loi: Sau reset, gia tri Q phai bang 0!" severity failure;
        report "-> Reset he thong thanh cong, Q = 0" severity note;

        -- 2. Kiem tra CHE DO TAY (SW1 = '0') voi hien tuong DOI NUT KHI NHAN VA THA
        report "-> [TEST 1] Che do tay: Nhan va tha co doi phim..." severity note;

        -- Gia lap doi nut khi NHAN (chuyen tu 1 xuong 0, doi nhieu lan)
        s_nut <= '0'; wait for 20 ns;
        s_nut <= '1'; wait for 20 ns;
        s_nut <= '0'; wait for 20 ns;
        s_nut <= '1'; wait for 20 ns;
        s_nut <= '0'; -- Nhan on dinh
        wait for 200 ns; -- Giu nut nhan on dinh trong 200 ns (10 chu ky)

        -- Kiem tra: Khi dang NHAN GIU nut, bo dem KHONG duoc phep thay doi!
        assert s_Q = "0000"
            report "Loi: Giu nut nhan khong duoc lam bo dem tang!" severity failure;

        -- Gia lap doi nut khi THA (chuyen tu 0 len 1, doi nhieu lan)
        s_nut <= '1'; wait for 20 ns;
        s_nut <= '0'; wait for 20 ns;
        s_nut <= '1'; wait for 20 ns;
        s_nut <= '0'; wait for 20 ns;
        s_nut <= '1'; -- Tha on dinh
        wait for 150 ns; -- Doi bo chong doi loc xong (5 chu ky = 100 ns)

        -- Sau khi tha tay hoan toan, Q phai tang len 1!
        assert s_Q = "0001"
            report "Loi: Sau khi nha nut, Q phai bang 1!" severity failure;
        report "-> Nhan nut lan 1 co doi: Loc doi tot, Q tang tu 0 len 1 thanh cong!" severity note;

        -- Nhan lan 2 (khong doi) de len 2
        s_nut <= '0'; wait for 150 ns;
        s_nut <= '1'; wait for 150 ns;
        assert s_Q = "0010" report "Loi: Q phai bang 2" severity failure;
        report "-> Nhan nut lan 2: Q tang len 2 thanh cong!" severity note;

        -- 3. Kiem tra CHE DO TU DONG (SW1 = '1')
        report "-> [TEST 2] Chuyen sang che do tu dong (SW1 = 1)..." severity note;
        s_tudong <= '1';

        -- Cho qua cac chu ky dem tu dong (moi buoc dai 10 clock = 200 ns)
        -- Q dang la 2, cho no tu dong dem len 3, 4, 5, 6, 7, 8
        wait for 200 ns * 6; -- Sau 6 buoc, Q phai dat 8
        wait for 20 ns;
        assert s_Q = "1000"
            report "Loi: Bo dem tu dong phai dat Q = 8!" severity failure;
        assert s_bao = '1'
            report "Loi: Chan bao (LEDG0) phai len 1 khi Q = 8!" severity failure;
        report "-> Q dat gia tri lon nhat 8, chan bao len '1' chinh xac!" severity note;

        -- Cho tiep 1 buoc nhip tu dong nua: Q phai quay vong ve 0 va chan bao ve 0!
        wait for 200 ns;
        assert s_Q = "0000"
            report "Loi: Bo dem phai quay vong tu 8 ve 0!" severity failure;
        assert s_bao = '0'
            report "Loi: Chan bao phai tro ve 0 khi Q = 0!" severity failure;
        report "-> Bo dem quay vong tu 8 ve 0 thanh cong!" severity note;

        -- Cho them 2 buoc: Q len 1, len 2
        wait for 400 ns;
        assert s_Q = "0010"
            report "Loi: Bo dem tiep tuc dem tu dong Q = 2" severity failure;

        -- 4. Kiem tra XOA BAT DONG BO khi dang chay tu dong
        report "-> [TEST 3] Kiem tra xoa bat dong bo KEY0..." severity note;
        s_rst_n <= '0';
        wait for 10 ns; -- Kiem tra ngay lap tuc ma khong can cho s suon clock
        assert s_Q = "0000"
            report "Loi: Xoa bat dong bo phai dua Q ve 0 ngay lap tuc!" severity failure;
        wait for 40 ns;
        s_rst_n <= '1';
        wait for 100 ns;

        report "==========================================================" severity note;
        report "TAT CA CAC BAI TEST CHO CAU 3 HOAN TOAN CHINH XAC 100%!" severity note;
        report "==========================================================" severity note;

        wait;
    end process;

end architecture sim;
