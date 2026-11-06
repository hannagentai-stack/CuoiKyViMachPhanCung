--=============================================================================
-- TRUONG DAI HOC KINH TE - KY THUAT CONG NGHIEP (UNETI)
-- KHOA DIEN TU VA KY THUAT MAY TINH
-- THI CUOI KY: THUC HANH THIET KE VI MACH PHAN CUNG - DE SO 2
-- CAU 3: BO DEM MOD-9 DEM LEN DONG BO TREN KIT DE2-115
--
-- Dai dem: 0 -> 1 -> 2 -> ... -> 8 -> 0 (Dung 4 Flip-Flop toi thieu)
-- Che do nhip (SW1):
--   SW1 = '0': Dem bang tay bang cach nhan roi nha KEY1 (canh len khi tha tay)
--   SW1 = '1': Dem tu dong nhip 5 Hz (0.2 s/buoc) tao tu CLOCK_50 (50 MHz)
-- Xoa bat dong bo: KEY0 (tich cuc muc thap '0') ve gia tri 0
-- Chan bao: LEDG0 len '1' khi gia tri dem dat lon nhat (8)
-- Xu ly nut KEY1 qua 3 khoi: Dong bo 2 tang -> Chong doi 10ms -> Bat canh len
-- Chi dung duy nhat 1 xung nhip CLOCK_50 (khong cat xung, dung clock enable)
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dem_len_mod9 is
    generic (
        -- He so chong doi: 10 ms o 50 MHz = 500_000 chu ky (can 19 bit)
        DB_LIMIT  : integer := 500_000;
        -- He so chia tan 5 Hz: 50 MHz / 5 Hz = 10_000_000 chu ky (can 24 bit)
        DIV_LIMIT : integer := 10_000_000
    );
    port (
        clk    : in  std_logic;                    -- CLOCK_50 (PIN_Y2, 3.3-V LVTTL)
        rst_n  : in  std_logic;                    -- KEY0 (PIN_M23, 2.5 V, muc thap)
        nut    : in  std_logic;                    -- KEY1 (PIN_M21, 2.5 V, dem tay)
        tudong : in  std_logic;                    -- SW1  (PIN_AC28, 2.5 V, chon che do)
        Q      : out std_logic_vector(3 downto 0); -- LEDR3..LEDR0 (2.5 V)
        bao    : out std_logic;                    -- LEDG0 (PIN_E21, 2.5 V, bao = 8)
        HEX0   : out std_logic_vector(6 downto 0)  -- HEX0 g..a (2.5 V, muc thap sang)
    );
end entity dem_len_mod9;

architecture rtl of dem_len_mod9 is

    -- 1. Tin hieu cho khoi Dong bo hoa 2 tang cho KEY1 (2 FFs)
    signal sync1, sync2 : std_logic := '1';

    -- 2. Tin hieu cho khoi Chong doi (Debounce) 10 ms (19 FFs counter + 1 FF state)
    signal db_count  : integer range 0 to DB_LIMIT := 0;
    signal btn_clean : std_logic := '1';

    -- 3. Tin hieu cho khoi Phat hien canh len luc THA tay (1 FF)
    -- KEY tich cuc muc thap: Nhan = '0', Tha = '1'. Canh tha tay la '0' -> '1'
    signal btn_clean_d : std_logic := '1';
    signal en_tay      : std_logic := '0';

    -- 4. Tin hieu cho khoi Tao nhip tu dong 5 Hz (24 FFs)
    signal div_count : integer range 0 to DIV_LIMIT := 0;
    signal en_tudong : std_logic := '0';

    -- 5. Tin hieu cho phep dem tong hop (Clock Enable)
    signal en_count  : std_logic;

    -- 6. Thanh ghi bo dem Mod-9 (4 FFs: toi thieu cho dai 0..8)
    signal q_reg : unsigned(3 downto 0) := (others => '0');

begin

    ---------------------------------------------------------------------------
    -- KHOI 1: DONG BO HOA TIN HIEU NUT NHAN KEY1 QUA 2 TANG FLIP-FLOP (2 FFs)
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            sync1 <= nut;
            sync2 <= sync1;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- KHOI 2: CHONG DOI (DEBOUNCE) 10 MS (19 FFs dem + 1 FF luu trang thai)
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            if sync2 /= btn_clean then
                if db_count = DB_LIMIT - 1 then
                    btn_clean <= sync2;
                    db_count  <= 0;
                else
                    db_count <= db_count + 1;
                end if;
            else
                db_count <= 0;
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- KHOI 3: PHAT HIEN CANH LEN LUC THA TAY (EDGE DETECTOR) (1 FF)
    -- Vi nut nhan Active-Low ('0' khi nhan, '1' khi tha),
    -- khi nha tay tin hieu chuyen tu '0' len '1'.
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            btn_clean_d <= btn_clean;
        end if;
    end process;

    -- Phat hien canh len (chuyen tu 0 sang 1), xung duy tri dung 1 chu ky clock
    en_tay <= '1' when (btn_clean = '1' and btn_clean_d = '0') else '0';

    ---------------------------------------------------------------------------
    -- KHOI 4: TAO NHIP TU DONG 5 HZ TU CLOCK_50 (24 FFs)
    -- Moi 0.2 giay (10_000_000 chu ky) phat 1 xung enable dung 1 clock
    ---------------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            if div_count = DIV_LIMIT - 1 then
                div_count <= 0;
                en_tudong <= '1';
            else
                div_count <= div_count + 1;
                en_tudong <= '0';
            end if;
        end if;
    end process;

    ---------------------------------------------------------------------------
    -- KHOI 5: CHON CHE DO NHIP BANG CONG TAC SW1 (MUX TO HOP)
    ---------------------------------------------------------------------------
    en_count <= en_tudong when tudong = '1' else en_tay;

    ---------------------------------------------------------------------------
    -- KHOI 6: BO DEM MOD-9 DEM LEN DONG BO (4 FFs toi thieu cho dai 0..8)
    -- Reset bat dong bo bang KEY0 (rst_n = '0') dua ve 0 ngay lap tuc
    ---------------------------------------------------------------------------
    process (clk, rst_n)
    begin
        if rst_n = '0' then
            q_reg <= (others => '0'); -- Xoa bat dong bo ve 0
        elsif rising_edge(clk) then
            if en_count = '1' then
                if q_reg = 8 then
                    q_reg <= (others => '0'); -- Quay vong ve 0 khi dat gia tri max (8)
                else
                    q_reg <= q_reg + 1;
                end if;
            end if;
        end if;
    end process;

    -- Dau ra gia tri dem Q(3 downto 0) tren LED do
    Q <= std_logic_vector(q_reg);

    -- Chan bao (LEDG0) len muc 1 khi bo dem o gia tri LON NHAT (8)
    bao <= '1' when q_reg = 8 else '0';

    ---------------------------------------------------------------------------
    -- KHOI 7: GIAI MA 7 DOAN HEX0 (ANODE CHUNG, TICH CUC MUC THAP)
    -- Thu tu bit: HEX0(6..0) = g, f, e, d, c, b, a ('0' la sang)
    ---------------------------------------------------------------------------
    process (q_reg)
    begin
        case to_integer(q_reg) is
            when 0 => HEX0 <= "1000000"; -- '0'
            when 1 => HEX0 <= "1111001"; -- '1'
            when 2 => HEX0 <= "0100100"; -- '2'
            when 3 => HEX0 <= "0110000"; -- '3'
            when 4 => HEX0 <= "0011001"; -- '4'
            when 5 => HEX0 <= "0010010"; -- '5'
            when 6 => HEX0 <= "0000010"; -- '6'
            when 7 => HEX0 <= "1111000"; -- '7'
            when 8 => HEX0 <= "0000000"; -- '8'
            when others => HEX0 <= "1111111"; -- Tat het den
        end case;
    end process;

end architecture rtl;
