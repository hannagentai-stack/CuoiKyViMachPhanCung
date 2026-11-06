--=============================================================================
-- TRUONG DAI HOC KINH TE - KY THUAT CONG NGHIEP (UNETI)
-- KHOA DIEN TU VA KY THUAT MAY TINH
-- THI CUOI KY: THUC HANH THIET KE VI MACH PHAN CUNG - DE SO 2
-- CAU 1: RUT GON HAM LOGIC K(A,B,C,D) VA THIET KE BANG VHDL
--
-- Ham goc: K(A,B,C,D) = Sigma_m(0, 1, 2, 3, 6, 7, 10, 11, 14, 15)
-- Bieu thuc toi gian sau K-Map: K = (not A and not B) or C
-- Bien thuc su phu thuoc: A, B, C. Bien thua: D
-- Mo hinh thiet ke: Luong du lieu (Dataflow)
--=============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ham_k is
    port (
        A : in  std_logic; -- SW3 (MSB)
        B : in  std_logic; -- SW2
        C : in  std_logic; -- SW1
        D : in  std_logic; -- SW0 (LSB - Bien thua)
        K : out std_logic  -- LEDR0
    );
end entity ham_k;

architecture dataflow of ham_k is
begin
    -- Thiet ke theo dung bieu thuc da rut gon tren bang Karnaugh:
    -- K = /A./B + C
    K <= (not A and not B) or C;
end architecture dataflow;
