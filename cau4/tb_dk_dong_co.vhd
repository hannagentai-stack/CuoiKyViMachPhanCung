--=============================================================================
-- TRUONG DAI HOC KINH TE - KY THUAT CONG NGHIEP (UNETI)
-- KHOA DIEN TU VA KY THUAT MAY TINH
-- THI CUOI KY: THUC HANH THIET KE VI MACH PHAN CUNG - DE SO 2
-- CAU 4: TESTBENCH KIEM THU MACH DIEU KHIEN DONG CO DC QUA L298 (tb_dk_dong_co)
--
-- Dac ta:
--   SW1 SW0 = 00 -> Duty ENA = 0 %,  IN1 IN2 = 0 0 (tha troi)
--   SW1 SW0 = 01 -> Duty ENA = 30 %, IN1 IN2 theo chieu
--   SW1 SW0 = 10 -> Duty ENA = 60 %, IN1 IN2 theo chieu
--   SW1 SW0 = 11 -> Duty ENA = 90 %, IN1 IN2 theo chieu
--   SW17 = 0: THUAN (IN1 IN2 = 1 0). SW17 = 1: NGUOC (IN1 IN2 = 0 1)
--   Sau reset nho chieu THUAN
--   Khoa chieu khi dang chay, chi doi chieu khi o cap 00
--   Process giam sat luon bat: IN1 va IN2 khong bao gio cung bang 1
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_dk_dong_co is
end entity tb_dk_dong_co;

architecture sim of tb_dk_dong_co is

    -- Ghi de generic bang gia tri nho de mo phong nhanh:
    -- F_CLK = 100_000 Hz (100 kHz), F_PWM = 1_000 Hz (1 kHz)
    -- HC = 100_000 / (1_000 * 100) = 1 chu ky clock / nac 1%
    -- Mot chu ky PWM dai dung 100 * HC = 100 chu ky clock
    constant TEST_F_CLK : integer := 100_000;
    constant TEST_F_PWM : integer := 1_000;
    constant HC_TEST    : integer := TEST_F_CLK / (TEST_F_PWM * 100); -- = 1
    constant PWM_CYCLES : integer := 100 * HC_TEST;                   -- = 100 clock

    -- Chu ky xung nhip CLOCK_50 dung trong testbench (20 ns)
    constant CLK_PERIOD : time := 20 ns;

    -- Tin hieu noi toi DUT
    signal s_clk   : std_logic := '0';
    signal s_rst_n : std_logic := '1';
    signal s_SW    : std_logic_vector(17 downto 0) := (others => '0');
    signal s_ENA   : std_logic;
    signal s_IN1   : std_logic;
    signal s_IN2   : std_logic;

    -- Thu tuc dem so clock ENA = '1' trong dung 1 chu ky PWM (100 clock) de do duty
    procedure do_duty (
        signal   clk      : in  std_logic;
        signal   ena      : in  std_logic;
        constant so_clock : in  integer;
        variable dem_high : out integer
    ) is
        variable cnt : integer := 0;
    begin
        cnt := 0;
        for i in 1 to so_clock loop
            wait until rising_edge(clk);
            if ena = '1' then
                cnt := cnt + 1;
            end if;
        end loop;
        dem_high := cnt;
    end procedure;

begin

    -- Khoi tao DUT voi Generic nho
    uut: entity work.dk_dong_co
        generic map (
            F_CLK => TEST_F_CLK,
            F_PWM => TEST_F_PWM
        )
        port map (
            CLOCK_50 => s_clk,
            KEY0     => s_rst_n,
            SW       => s_SW,
            ENA      => s_ENA,
            IN1      => s_IN1,
            IN2      => s_IN2
        );

    -- 1. Tao xung nhip CLOCK_50
    clk_process: process
    begin
        s_clk <= '0';
        wait for CLK_PERIOD / 2;
        s_clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    ---------------------------------------------------------------------------
    -- 2. TIEN TRINH GIAM SAT LUON BAT (CONTINUOUS MONITOR PROCESS)
    -- O moi suon len clock, kiem tra nghiem ngat IN1 va IN2 khong duoc cung bang 1
    ---------------------------------------------------------------------------
    monitor_proc: process (s_clk)
    begin
        if rising_edge(s_clk) then
            assert not (s_IN1 = '1' and s_IN2 = '1')
                report "SU CO NGUY HIEM: IN1 VA IN2 DONG THOI BANG 1 GAY NGAN MACH CAU H L298!"
                severity failure;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- 3. TIEN TRINH KICH THICH VA KIEM TRA TESTBENCH
    ---------------------------------------------------------------------------
    stim_proc: process
        variable measured_duty : integer;
    begin
        report "==========================================================" severity note;
        report "BAT DAU MO PHONG CAU 4 (DE 2) - DIEU KHIEN DONG CO DC L298" severity note;
        report "GIA TRI GENERIC: F_CLK = 100_000 Hz, F_PWM = 1_000 Hz" severity note;
        report "HE SO HC = 1 clock/nac. MOT CHU KY PWM = 100 CLOCK" severity note;
        report "==========================================================" severity note;

        -- B1. Reset he thong qua KEY0 trong 3 chu ky clock
        s_rst_n <= '0';
        s_SW    <= (others => '0'); -- SW17=0 (Thuan), SW1 SW0=00 (0%)
        wait for CLK_PERIOD * 3;
        s_rst_n <= '1';
        wait for CLK_PERIOD * 5;

        -- B2. Kiem tra CAP 00 (0 %): ENA = 0, IN1 = IN2 = 0 (Tha troi)
        report "-> [TEST 1] Kiem tra Cap toc do 00 (0 %):" severity note;
        wait for CLK_PERIOD * 10;
        assert (s_ENA = '0') 
            report "Loi Cap 00: ENA phai bang 0!" severity failure;
        assert (s_IN1 = '0' and s_IN2 = '0') 
            report "Loi Cap 00: IN1 va IN2 phai cung bang 0 (tha troi)!" severity failure;

        do_duty(s_clk, s_ENA, PWM_CYCLES, measured_duty);
        assert (measured_duty = 0)
            report "Loi: Duty do duoc o cap 00 phai bang 0 clock!" severity failure;
        report "   => Cap 00 DAT CHUAN: Duty = 0 %, IN1=0, IN2=0 (Tha troi)" severity note;

        -- B3. Kiem tra CAP 01 (30 % - Chieu Thuan SW17 = 0)
        report "-> [TEST 2] Kiem tra Cap toc do 01 (30 % - Chieu Thuan):" severity note;
        s_SW(17) <= '0'; -- Chieu thuan
        s_SW(1 downto 0) <= "01";
        -- Cho vai chu ky PWM de dong bo 2 tang FF va mach on dinh
        wait for CLK_PERIOD * PWM_CYCLES * 2;

        assert (s_IN1 = '1' and s_IN2 = '0')
            report "Loi: Chieu thuan phai co IN1=1, IN2=0!" severity failure;

        do_duty(s_clk, s_ENA, PWM_CYCLES, measured_duty);
        assert (measured_duty = 30)
            report "Loi: Duty do duoc o cap 01 phai la 30 clock (thuc te: " & integer'image(measured_duty) & ")" severity failure;
        report "   => Cap 01 DAT CHUAN: Duty = 30 %, IN1=1, IN2=0 (Thuan)" severity note;

        -- B4. Kiem tra CAP 10 (60 % - Chieu Thuan)
        report "-> [TEST 3] Kiem tra Cap toc do 10 (60 % - Chieu Thuan):" severity note;
        s_SW(1 downto 0) <= "10";
        wait for CLK_PERIOD * PWM_CYCLES * 2;

        assert (s_IN1 = '1' and s_IN2 = '0')
            report "Loi: Cap 10 chieu thuan IN1=1, IN2=0" severity failure;

        do_duty(s_clk, s_ENA, PWM_CYCLES, measured_duty);
        assert (measured_duty = 60)
            report "Loi: Duty do duoc o cap 10 phai la 60 clock (thuc te: " & integer'image(measured_duty) & ")" severity failure;
        report "   => Cap 10 DAT CHUAN: Duty = 60 %, IN1=1, IN2=0 (Thuan)" severity note;

        -- B5. Kiem tra CAP 11 (90 % - Chieu Thuan)
        report "-> [TEST 4] Kiem tra Cap toc do 11 (90 % - Chieu Thuan):" severity note;
        s_SW(1 downto 0) <= "11";
        wait for CLK_PERIOD * PWM_CYCLES * 2;

        assert (s_IN1 = '1' and s_IN2 = '0')
            report "Loi: Cap 11 chieu thuan IN1=1, IN2=0" severity failure;

        do_duty(s_clk, s_ENA, PWM_CYCLES, measured_duty);
        assert (measured_duty = 90)
            report "Loi: Duty do duoc o cap 11 phai la 90 clock (thuc te: " & integer'image(measured_duty) & ")" severity failure;
        report "   => Cap 11 DAT CHUAN: Duty = 90 %, IN1=1, IN2=0 (Thuan)" severity note;

        -- B6. KIEM TRA KHOA CHIEU KHI DANG CHAY:
        -- Dang o cap 11 (chay 90%, Thuan IN1=1, IN2=0), gat SW17 = 1 (Chon Nguoc)
        report "-> [TEST 5] Kiem tra KHOA CHIEU khi dang chay o cap 11..." severity note;
        s_SW(17) <= '1';
        wait for CLK_PERIOD * PWM_CYCLES * 2;

        -- Mach van phai giu nguyen chieu THUAN (IN1=1, IN2=0) vi chua ve cap 00!
        assert (s_IN1 = '1' and s_IN2 = '0')
            report "LOI KHOA CHIEU: Dang chay ma chieu bi thay doi khi gat SW17!" severity failure;
        report "   => KHOA CHIEU HOAT DONG DUNG: Chieu van giu THUAN (IN1=1, IN2=0)!" severity note;

        -- B7. Ve cap 00 de chieu moi (SW17 = 1 -> NGUOC) duoc phep cap nhat
        report "-> [TEST 6] Dua ve cap 00 va tang lai de chieu NGUOC co hieu luc..." severity note;
        s_SW(1 downto 0) <= "00";
        wait for CLK_PERIOD * PWM_CYCLES * 2;

        -- O cap 00: tha troi
        assert (s_IN1 = '0' and s_IN2 = '0')
            report "Loi: Cap 00 phai tha troi IN1=0, IN2=0" severity failure;

        -- Tang len cap 10 (60%): Bay gio chieu NGUOC (IN1=0, IN2=1) phai co hieu luc!
        s_SW(1 downto 0) <= "10";
        wait for CLK_PERIOD * PWM_CYCLES * 2;

        assert (s_IN1 = '0' and s_IN2 = '1')
            report "LOI CAP NHAT CHIEU: Sau khi ve 00 ma chieu Nguoc van chua duoc cap nhat!" severity failure;

        do_duty(s_clk, s_ENA, PWM_CYCLES, measured_duty);
        assert (measured_duty = 60)
            report "Loi: Duty o cap 10 chieu nguoc phai la 60 clock" severity failure;
        report "   => CAP NHAT CHIEU NGUOC THANH CONG: IN1=0, IN2=1, Duty=60%" severity note;

        report "==========================================================" severity note;
        report "CHUC MUNG! TESTBENCH CAU 4 CHAY DUNG 100% MOI YEU CAU DE BHO!" severity note;
        report "==========================================================" severity note;

        wait; -- Dung mo phong
    end process;

end architecture sim;
