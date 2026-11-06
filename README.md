# CuoiKyViMachPhanCung - Đề Số 2
**Môn học:** Thực hành Thiết kế vi mạch phần cứng (Mã HP: 002527)  
**Đơn vị:** Khoa Điện tử & Kỹ thuật Máy tính - Trường Đại học Kinh tế - Kỹ thuật Công nghiệp (UNETI)  
**Phần cứng:** KIT Altera DE2-115 (FPGA Cyclone IV E `EP4CE115F29C7N`)  
**Công cụ:** Intel Quartus Prime 20.1 & ModelSim-Intel FPGA Edition 20.1  

---

## 📂 Cấu trúc thư mục

```
CuoiKyViMachPhanCung/
├── cau1/                      # Rút gọn hàm logic K(A,B,C,D) bằng VHDL
│   ├── ham_k.vhd              # RTL Dataflow (K = /A./B + C)
│   ├── tb_ham_k.vhd           # Testbench quét 16 tổ hợp tự kiểm tra với assert
│   ├── pin_assignments.tcl   # Script Tcl gán chân Kit DE2-115
│   ├── ham_k.qpf / .qsf       # Quartus Project
│   └── run_sim.do             # Script chạy mô phỏng ModelSim
│
├── cau2/                      # Bộ mã hoá ưu tiên 8 sang 3 (Priority Encoder)
│   ├── ma_hoa_8_3.vhd         # RTL xét I(7) ưu tiên cao nhất, I(0) thấp nhất
│   ├── tb_ma_hoa_8_3.vhd      # Testbench tự kiểm tra (assert)
│   ├── pin_assignments.tcl   # Script Tcl gán chân
│   ├── ma_hoa_8_3.qpf / .qsf  # Quartus Project
│   └── run_sim.do             # Script chạy mô phỏng ModelSim
│
├── cau3/                      # Bộ đếm Mod-9 ĐẾM LÊN ĐỒNG BỘ (0..8)
│   ├── dem_len_mod9.vhd       # RTL chuẩn: 1 Clock CLOCK_50, Clock Enable, 3 khối lọc nút
│   ├── tb_dem_len_mod9.vhd    # Testbench với generic nhỏ, test dội phím và quay vòng
│   ├── pin_assignments.tcl   # Script Tcl gán chân (CLOCK_50: 3.3-V LVTTL, ngoại vi: 2.5 V)
│   ├── dem_len_mod9.qpf/.qsf  # Quartus Project
│   └── run_sim.do             # Script chạy mô phỏng ModelSim
│
├── cau4/                      # Testbench kiểm thử Mạch điều khiển Động cơ DC (L298)
│   ├── dk_dong_co.vhd         # Mạch RTL cho sẵn (Đề 2)
│   ├── tb_dk_dong_co.vhd      # Testbench: đo duty, test khóa chiều, process giám sát assert
│   └── run_sim.do             # Script chạy mô phỏng ModelSim
│
├── .gitignore
└── README.md
```

---

## 📋 Tóm tắt Thiết kế & Kết quả kiểm chứng

### 🔹 Câu 1: Rút gọn hàm K(A,B,C,D) = $\Sigma m(0, 1, 2, 3, 6, 7, 10, 11, 14, 15)$
* **Bảng Karnaugh:** Nhóm 8 ô cột $CD$ cho ra $C$; nhóm 4 ô hàng $AB=00$ cho ra $\overline{A}\,\overline{B}$.
* **Biểu thức tối giản:** $K = \overline{A}\,\overline{B} + C$.
* **Biến thừa:** Biến **$D$ là biến thừa** (hàm chỉ phụ thuộc vào $A, B, C$).
* **Gán chân:** $A, B, C, D \rightarrow SW3, SW2, SW1, SW0$; $K \rightarrow LEDR0$.

### 🔹 Câu 2: Bộ mã hoá ưu tiên 8 sang 3 (`ma_hoa_8_3`)
* **Đặc tả:** $I(7)$ ưu tiên cao nhất, $I(0)$ thấp nhất. $V = 1$ khi có ít nhất 1 ngõ vào tích cực.
* **Nguyên lý RTL:** Cấu trúc `if / elsif` kiểm tra tuần tự từ $I(7)$ xuống $I(0)$, có nhánh `else` bao quát trường hợp $I = "00000000"$ tránh tạo Latch.
* **Gán chân:** $I(7..0) \rightarrow SW7..SW0$; $Y(2..0) \rightarrow LEDR2..LEDR0$; $V \rightarrow LEDG0$.

### 🔹 Câu 3: Bộ đếm Mod-9 Đếm Lên Đồng Bộ (`dem_len_mod9`)
* **Dải đếm:** $0 \rightarrow 1 \rightarrow 2 \rightarrow \dots \rightarrow 8 \rightarrow 0$.
* **Xử lý nút KEY1:** Đồng bộ 2 tầng $\rightarrow$ Chống dội 10 ms (500.000 clock) $\rightarrow$ Bắt cạnh thả tay (`'0' \rightarrow '1'`).
* **Chế độ:** SW1=0 (Bằng tay), SW1=1 (Tự động 5 Hz lấy từ CLOCK_50).
* **Clock Enable:** Toàn mạch chỉ dùng 1 đường clock `CLOCK_50`, không cắt xung.
* **Tính toán lý thuyết số Flip-Flop:**
  * Đồng bộ: 2 FFs
  * Chống dội: 19 FFs (bộ đếm) + 1 FF (trạng thái) = 20 FFs
  * Bắt cạnh: 1 FF
  * Tạo nhịp 5 Hz: 24 FFs (bộ đếm) + 1 FF (en) = 25 FFs
  * Bộ đếm Mod-9 ($0..8$): 4 FFs (tối thiểu vì $2^3 < 9 \le 2^4$)
  * **Tổng cộng: 52 Flip-Flops (Registers)** $\rightarrow$ **Khớp 100% với báo cáo Quartus Synthesis (`Total registers = 52`)**.
* **Gán chân:** `clk` (CLOCK_50, 3.3-V LVTTL), `rst_n` (KEY0), `nut` (KEY1), `tudong` (SW1), `Q` (LEDR3..LEDR0), `bao` (LEDG0), `HEX0` (HEX0_6..0).

### 🔹 Câu 4: Testbench Điều khiển Động cơ DC (`tb_dk_dong_co`)
* **Generic ghi đè mô phỏng nhanh:** `F_CLK = 100_000 Hz`, `F_PWM = 1_000 Hz` $\implies HC = 1$ clock/nấc, chu kỳ PWM = 100 clock.
* **Kiểm chứng Duty:** Đo đếm số xung clock `ENA = '1'` trong đúng 100 clock qua `assert` (0% ở 00, 30% ở 01, 60% ở 10, 90% ở 11).
* **Kiểm chứng Khóa chiều:** Gạt SW17 khi đang chạy, mạch giữ nguyên chiều; chỉ khi về 00 chiều mới mới có hiệu lực.
* **Process giám sát độc lập:** `assert not (s_IN1 = '1' and s_IN2 = '1')` tại mọi sườn lên clock để chống ngắn mạch cầu H L298.

---

## 🚀 Hướng dẫn chạy Mô phỏng trên ModelSim 20.1

Khởi động **ModelSim-Intel FPGA Edition 20.1**, tại cửa sổ Transcript:
```tcl
# Câu 1
cd cau1
do run_sim.do

# Câu 2
cd ../cau2
do run_sim.do

# Câu 3
cd ../cau3
do run_sim.do

# Câu 4
cd ../cau4
do run_sim.do
```
Mọi kịch bản testbench đều là **Self-Checking (tự kiểm tra bằng `assert`)**, tự động thông báo Pass 100% trên cửa sổ Console.
