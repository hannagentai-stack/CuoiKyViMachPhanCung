--=============================================================================
-- TRUONG DAI HOC KINH TE - KY THUAT CONG NGHIEP (UNETI)
-- KHOA DIEN TU VA KY THUAT MAY TINH
-- THI CUOI KY: THUC HANH THIET KE VI MACH PHAN CUNG - DE SO 2
-- CAU 2: BO MA HOA UU TIEN 8 SANG 3 (PRIORITY ENCODER 8-TO-3)
--
-- Dau vao: I(7 downto 0) voi I(7) co uu tien cao nhat, I(0) thap nhat
-- Dau ra: Y(2 downto 0) la ma nhi phan tuong ung
--         V la chan hop le (Valid), len '1' khi co it nhat mot dau vao tich cuc
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ma_hoa_8_3 is
    port (
        I : in  std_logic_vector(7 downto 0); -- SW7..SW0
        Y : out std_logic_vector(2 downto 0); -- LEDR2..LEDR0
        V : out std_logic                     -- LEDG0 (Chan bao hop le)
    );
end entity ma_hoa_8_3;

architecture rtl of ma_hoa_8_3 is
begin
    -- Mach to hop giai ma uu tien dung chuoi if/elsif
    -- I(7) xet dau tien do co muc uu tien cao nhat
    process (I)
    begin
        if I(7) = '1' then
            Y <= "111";
            V <= '1';
        elsif I(6) = '1' then
            Y <= "110";
            V <= '1';
        elsif I(5) = '1' then
            Y <= "101";
            V <= '1';
        elsif I(4) = '1' then
            Y <= "100";
            V <= '1';
        elsif I(3) = '1' then
            Y <= "011";
            V <= '1';
        elsif I(2) = '1' then
            Y <= "010";
            V <= '1';
        elsif I(1) = '1' then
            Y <= "001";
            V <= '1';
        elsif I(0) = '1' then
            Y <= "000";
            V <= '1';
        else
            -- Truong hop khong co dau vao nao tich cuc (I = "00000000")
            -- Bat buoc phai co nhanh else cuoi de tranh tao Latch va khong bi tru diem
            Y <= "000";
            V <= '0';
        end if;
    end process;

end architecture rtl;
