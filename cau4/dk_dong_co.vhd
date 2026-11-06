--==========================================================================
-- THI CUOI KY - DE 2 - CAU 4 : MACH DIEU KHIEN DONG CO DC QUA L298
-- (Mach CHO SAN - sinh vien KHONG sua file nay, chi viet testbench)
--   SW1 SW0 : cap toc do  00 = dung, 01 = 30 %, 10 = 60 %, 11 = 90 %
--   SW17    : chieu quay  1 = NGUOC (IN1 IN2 = 0 1), 0 = THUAN (IN1 IN2 = 1 0)
--   KEY0    : reset (tich cuc muc thap)
--   ENA     : xung PWM vao chan EN A cua L298
--   IN1,IN2 : chon chieu; khi cap toc do = 00 thi IN1 = IN2 = 0 (tha troi)
--   Chieu quay CHI duoc doi khi dang o cap 00 (dong co dung).
--==========================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity dk_dong_co is
    generic ( F_CLK : integer := 50_000_000;
              F_PWM : integer := 20_000 );
    port ( CLOCK_50      : in  STD_LOGIC;
           KEY0          : in  STD_LOGIC;
           SW            : in  STD_LOGIC_VECTOR(17 downto 0);
           ENA, IN1, IN2 : out STD_LOGIC );
end entity dk_dong_co;
 
architecture rtl of dk_dong_co is
    constant HC : integer := F_CLK / (F_PWM * 100);   -- so clock cho 1 nac 1 %
    signal dem_chia : integer range 0 to HC - 1 := 0;
    signal nac      : integer range 0 to 99 := 0;
    signal duty     : integer range 0 to 100;
    signal pwm      : STD_LOGIC := '0';
    signal s1, s2   : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal chieu    : STD_LOGIC := '0';
begin
    -- B1. Dong bo cong tac SW17, SW1, SW0 qua 2 tang flip-flop
    process (CLOCK_50) begin
        if rising_edge(CLOCK_50) then
            s1 <= SW(17) & SW(1) & SW(0);
            s2 <= s1;
        end if;
    end process;
 
    -- B2. Doi cap toc do ra duty (%)
    with s2(1 downto 0) select
        duty <= 0  when "00",
                30 when "01",
                60 when "10",
                90 when others;
 
    -- B3. PWM: chia tan -> dem nac 0..99 -> so sanh voi duty
    process (CLOCK_50, KEY0) begin
        if KEY0 = '0' then
            dem_chia <= 0;  nac <= 0;  pwm <= '0';
        elsif rising_edge(CLOCK_50) then
            if dem_chia = HC - 1 then
                dem_chia <= 0;
                if nac = 99 then nac <= 0; else nac <= nac + 1; end if;
            else
                dem_chia <= dem_chia + 1;
            end if;
            if nac < duty then pwm <= '1'; else pwm <= '0'; end if;
        end if;
    end process;
 
    -- B4. Chieu quay: chi chap nhan doi chieu khi cap toc do = 00
    process (CLOCK_50, KEY0) begin
        if KEY0 = '0' then
            chieu <= '0';
        elsif rising_edge(CLOCK_50) then
            if s2(1 downto 0) = "00" then
                chieu <= s2(2);
            end if;
        end if;
    end process;
 
    -- B5. Dau ra
    ENA <= pwm;
    IN1 <= not chieu when duty > 0 else '0';
    IN2 <= chieu     when duty > 0 else '0';
end architecture rtl;
