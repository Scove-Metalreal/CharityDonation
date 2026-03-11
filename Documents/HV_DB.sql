-- =========================================================
-- DATABASE: charity_donation_db
-- =========================================================
DROP DATABASE IF EXISTS charity_donation_db;
CREATE DATABASE charity_donation_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE charity_donation_db;

-- =========================================================
-- 1. BẢNG: roles (Quản lý Quyền)
-- =========================================================
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- =========================================================
-- 2. BẢNG: users (Thành viên & Tài khoản ngầm "Shadow Account")
-- =========================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NULL, -- Cho phép NULL đối với khách vãng lai (Guest) chưa đặt mật khẩu
    phone_number VARCHAR(20) UNIQUE,
    address VARCHAR(255),
    avatar_url VARCHAR(500),
    role_id INT NOT NULL, 
    status TINYINT DEFAULT 1, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- =========================================================
-- 3. BẢNG: payment_methods (Phương thức thanh toán)
-- =========================================================
CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    provider VARCHAR(100),
    account_number VARCHAR(100),
    logo_url VARCHAR(500),
    is_active TINYINT DEFAULT 1
);

-- =========================================================
-- 4. BẢNG: campaigns (Chiến dịch quyên góp)
-- =========================================================
CREATE TABLE campaigns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    background TEXT, 
    content TEXT,    
    image_url VARCHAR(500), 
    image_description VARCHAR(255), 
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    target_money DECIMAL(15, 2) DEFAULT 0,
    current_money DECIMAL(15, 2) DEFAULT 0,
    status TINYINT DEFAULT 0, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 5. BẢNG: companions (Nhà đồng hành / Đối tác)
-- =========================================================
CREATE TABLE companions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    logo_url VARCHAR(500),
    description VARCHAR(500),
    is_active TINYINT DEFAULT 1
);

-- =========================================================
-- 6. BẢNG: campaign_companions (Nhiều-Nhiều)
-- =========================================================
CREATE TABLE campaign_companions (
    campaign_id INT NOT NULL,
    companion_id INT NOT NULL,
    PRIMARY KEY (campaign_id, companion_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (companion_id) REFERENCES companions(id) ON DELETE CASCADE
);

-- =========================================================
-- 7. BẢNG: donations (Giao dịch quyên góp - Chuẩn hóa 3NF)
-- =========================================================
CREATE TABLE donations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,       -- Bắt buộc phải có (Là User thật hoặc Shadow User)
    campaign_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    message VARCHAR(500),
    is_anonymous TINYINT DEFAULT 0, -- 1: Ẩn danh (Nhà hảo tâm), 0: Công khai tên
    status TINYINT DEFAULT 0,       -- 0: Chờ xác nhận, 1: Đã nhận, 2: Đã hủy
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- =========================================================
-- THÊM DỮ LIỆU MẪU (DUMMY DATA)
-- =========================================================

-- 1. Dữ liệu Roles
INSERT INTO roles (role_name, description) VALUES
('GUEST', 'Khách vãng lai quyên góp (Tài khoản ngầm)'),
('USER', 'Thành viên chính thức'), 
('ADMIN', 'Quản trị viên hệ thống');

-- 2. Dữ liệu Users (Gồm Admin, User thật và các Shadow User)
-- Admin (Role 3)
INSERT INTO users (full_name, email, password, phone_number, address, role_id, avatar_url) VALUES
('Admin System', 'admin@charity.com', '$2a$10$X8...', '0901234560', 'Hà Nội', 3, '/assets/images/avatars/admin.png');

-- Users thật (Role 2, Có Password)
INSERT INTO users (full_name, email, password, phone_number, address, role_id, avatar_url) VALUES
('Nguyễn Văn An', 'an.nguyen@gmail.com', '$2a$10$X8...', '0912345671', 'TP.HCM', 2, '/assets/images/avatars/user1.png'),
('Trần Thị Bình', 'binh.tran@gmail.com', '$2a$10$X8...', '0923456782', 'Đà Nẵng', 2, '/assets/images/avatars/user2.png'),
('Lê Hoàng Cường', 'cuong.le@gmail.com', '$2a$10$X8...', '0934567893', 'Cần Thơ', 2, '/assets/images/avatars/user3.png'),
('Phạm Dung', 'dung.pham@yahoo.com', '$2a$10$X8...', '0945678904', 'Hải Phòng', 2, '/assets/images/avatars/user4.png'),
('Hoàng Anh Em', 'em.hoang@gmail.com', '$2a$10$X8...', '0956789015', 'Nghệ An', 2, '/assets/images/avatars/user5.png'),
('Vũ Đức Phong', 'phong.vu@test.com', '$2a$10$X8...', '0967890126', 'Thanh Hóa', 2, '/assets/images/avatars/user6.png'),
('Đặng Thu Hà', 'ha.dang@test.com', '$2a$10$X8...', '0978901237', 'Huế', 2, '/assets/images/avatars/user7.png'),
('Bùi Văn Tính', 'tinh.bui@test.com', '$2a$10$X8...', '0989012348', 'Bình Dương', 2, '/assets/images/avatars/user8.png'),
('Đỗ Thị Hoa', 'hoa.do@test.com', '$2a$10$X8...', '0990123459', 'Đồng Nai', 2, '/assets/images/avatars/user9.png');

-- Shadow Users / Guest (Role 1, Password = NULL, do hệ thống tự sinh ra khi quyên góp)
INSERT INTO users (full_name, email, password, phone_number, address, role_id, avatar_url) VALUES
('Khách Vãng Lai A', 'khachA@gmail.com', NULL, '0811111111', NULL, 1, '/assets/images/avatars/default.png'),
('Người Dấu Tên', 'nguoi.qua.duong@test.com', NULL, '0822222222', NULL, 1, '/assets/images/avatars/default.png'),
('Sinh Viên Nghèo', 'sinhvien@test.com', NULL, '0833333333', NULL, 1, '/assets/images/avatars/default.png'),
('Anh Ba Gác', 'anhbagac@test.com', NULL, '0844444444', NULL, 1, '/assets/images/avatars/default.png'),
('Trạm Cứu Hộ', 'tramcuuho@test.com', NULL, '0855555555', NULL, 1, '/assets/images/avatars/default.png');

-- 3. Dữ liệu Payment Methods
INSERT INTO payment_methods (method_name, provider, account_number, logo_url, is_active) VALUES
('Chuyển khoản Vietcombank', 'Vietcombank', '00110022334455', '/assets/images/payments/vcb.png', 1),
('Ví điện tử Momo', 'Momo', '0901234567', '/assets/images/payments/momo.png', 1),
('Ví ZaloPay', 'ZaloPay', '0901234567', '/assets/images/payments/zalopay.png', 1),
('Chuyển khoản Techcombank', 'Techcombank', '19033344455566', '/assets/images/payments/techcombank.png', 1),
('Chuyển khoản MB Bank', 'MBBank', '999988887777', '/assets/images/payments/mbbank.png', 1),
('Chuyển khoản BIDV', 'BIDV', '12345678901234', '/assets/images/payments/bidv.png', 1),
('Chuyển khoản Agribank', 'Agribank', '444455556666', '/assets/images/payments/agribank.png', 1),
('Chuyển khoản VietinBank', 'VietinBank', '111122223333', '/assets/images/payments/vietinbank.png', 1),
('Chuyển khoản ACB', 'ACB', '88889999', '/assets/images/payments/acb.png', 1),
('Chuyển khoản TPBank', 'TPBank', '555566667777', '/assets/images/payments/tpbank.png', 1),
('Chuyển khoản VPBank', 'VPBank', '222233334444', '/assets/images/payments/vpbank.png', 1),
('Chuyển khoản Sacombank', 'Sacombank', '060123456789', '/assets/images/payments/sacombank.png', 1),
('Ví điện tử VNPay', 'VNPay', '0901234567', '/assets/images/payments/vnpay.png', 1),
('Ví điện tử Viettel Money', 'ViettelMoney', '0901234567', '/assets/images/payments/viettelmoney.png', 1),
('Thẻ tín dụng (Bảo trì)', 'Visa/Mastercard', '', '/assets/images/payments/visa.png', 0);

-- 4. Dữ liệu Companions
INSERT INTO companions (name, description, logo_url, is_active) VALUES
('Đài Truyền Hình VTV', 'Đơn vị bảo trợ truyền thông', '/assets/images/companions/vtv.png', 1),
('Báo Tuổi Trẻ', 'Đơn vị bảo trợ thông tin', '/assets/images/companions/tuoitre.png', 1),
('Quỹ Hiểu Về Trái Tim', 'Tổ chức nhân đạo phi chính phủ', '/assets/images/companions/hieuvetraitim.png', 1),
('Hội Chữ Thập Đỏ VN', 'Hội chữ thập đỏ trung ương', '/assets/images/companions/redcross.png', 1),
('Công ty Vingroup', 'Tập đoàn tài trợ chính', '/assets/images/companions/vingroup.png', 1),
('Tập đoàn FPT', 'Tài trợ công nghệ và nhân lực', '/assets/images/companions/fpt.png', 1),
('Ca sĩ Thủy Tiên', 'Đại sứ thiện chí', '/assets/images/companions/thuytien.png', 1),
('MC Phan Anh', 'Đại sứ truyền thông', '/assets/images/companions/phananh.png', 1),
('Ngân hàng Vietcombank', 'Đơn vị miễn phí giao dịch chuyển khoản', '/assets/images/companions/vcb_partner.png', 1),
('Vietnam Airlines', 'Tài trợ vận chuyển hàng hóa', '/assets/images/companions/vna.png', 1),
('Grab Việt Nam', 'Tài trợ chuyến xe tình nguyện', '/assets/images/companions/grab.png', 1),
('Shopee Việt Nam', 'Hỗ trợ nền tảng quyên góp', '/assets/images/companions/shopee.png', 1),
('Hội Liên Hiệp Phụ Nữ', 'Phối hợp triển khai địa phương', '/assets/images/companions/phunu.png', 1),
('Đoàn Thanh Niên HCM', 'Lực lượng tình nguyện viên', '/assets/images/companions/doanthanhnien.png', 1),
('Trường ĐH Bách Khoa', 'Tổ chức sinh viên tình nguyện', '/assets/images/companions/hcmut.png', 1);

-- 5. Dữ liệu Campaigns
INSERT INTO campaigns (code, name, background, content, image_url, image_description, start_date, end_date, target_money, current_money, status) VALUES
('CMP2024_01', 'Áo ấm vùng cao Sơn La', 'Trẻ em Sơn La thiếu áo ấm mùa đông.', 'Cung cấp 10.000 áo ấm và 5.000 bộ sách vở.', '/assets/images/drives/ao-am.jpg', 'Ảnh áo ấm', '2025-10-01', '2025-12-31', 50000000, 15000000, 1),
('CMP2024_02', 'Hỗ trợ đồng bào bão lụt', 'Miền Trung chịu thiệt hại nặng nề sau bão.', 'Phát gạo, mì tôm cho 20.000 hộ dân.', '/assets/images/drives/bao-lut.jpg', 'Ảnh cứu trợ', '2025-11-01', '2025-11-30', 100000000, 100000000, 2),
('CMP2024_03', 'Mổ tim cho bé An', 'Bé An bị bệnh tim bẩm sinh.', 'Hỗ trợ 100% chi phí phẫu thuật.', '/assets/images/drives/mo-tim.jpg', 'Ảnh bé An', '2025-12-01', '2026-02-28', 80000000, 20000000, 1),
('CMP2024_04', 'Xây cầu nông thôn Trà Vinh', 'Bà con phải đi cầu khỉ nguy hiểm.', 'Xây cầu bê tông cốt thép dài 20m.', '/assets/images/drives/xay-cau.jpg', 'Ảnh cầu khỉ', '2026-01-01', '2026-06-30', 200000000, 0, 0),
('CMP2024_05', 'Bữa cơm có thịt vùng cao', 'Học sinh mầm non chỉ ăn cơm với muối.', 'Bổ sung thịt và sữa vào bữa trưa.', '/assets/images/drives/bua-com.jpg', 'Ảnh các bé ăn', '2026-01-15', '2026-12-31', 150000000, 5000000, 1),
('CMP2024_06', 'Tặng xe đạp đến trường', 'Nhiều em phải đi bộ 10km đến lớp.', 'Trao tặng 100 chiếc xe đạp Martin.', '/assets/images/drives/xe-dap.jpg', 'Ảnh học sinh đạp xe', '2025-08-01', '2025-09-05', 120000000, 120000000, 3),
('CMP2024_07', 'Thư viện ước mơ', 'Trường cấp 1 chưa có phòng đọc sách.', 'Xây dựng phòng đọc và tặng 5.000 sách.', '/assets/images/drives/thu-vien.jpg', 'Ảnh đọc sách', '2026-02-01', '2026-05-31', 60000000, 0, 0),
('CMP2024_08', 'Quỹ khuyến học Sinh viên', 'Nhiều SV giỏi có nguy cơ bỏ học vì nghèo.', 'Trao 50 suất học bổng toàn phần.', '/assets/images/drives/hoc-bong.jpg', 'Ảnh trao học bổng', '2026-03-01', '2026-09-30', 300000000, 0, 0),
('CMP2024_09', 'Nước sạch miền Tây', 'Xâm nhập mặn khiến bà con thiếu nước.', 'Lắp đặt 10 máy lọc nước RO.', '/assets/images/drives/nuoc-sach.jpg', 'Ảnh lấy nước', '2026-04-01', '2026-08-31', 250000000, 0, 0),
('CMP2024_10', 'Nhà tình thương Bà Bảy', 'Bà cụ 80 tuổi sống trong căn lều dột nát.', 'Xây nhà cấp 4 diện tích 40m2.', '/assets/images/drives/nha-tinh-thuong.jpg', 'Ảnh nhà cũ', '2025-12-15', '2026-01-30', 50000000, 25000000, 1),
('CMP2024_11', 'Tết ấm tình thương', 'Người vô gia cư thiếu thốn dịp Tết.', 'Phát 500 phần quà Tết và bánh chưng.', '/assets/images/drives/tet-am.jpg', 'Ảnh tặng quà', '2025-12-20', '2026-01-25', 40000000, 35000000, 1),
('CMP2024_12', 'Chuyến xe 0 đồng', 'Công nhân nghèo không có tiền về quê.', 'Bao trọn 5 chiếc xe khách 45 chỗ.', '/assets/images/drives/chuyen-xe.jpg', 'Ảnh lên xe', '2025-12-01', '2026-01-20', 80000000, 80000000, 2),
('CMP2024_13', 'Bảo vệ rùa biển Côn Đảo', 'Rùa biển đối mặt nguy cơ tuyệt chủng.', 'Tài trợ thiết bị theo dõi rùa.', '/assets/images/drives/rua-bien.jpg', 'Ảnh rùa con', '2026-05-01', '2026-12-31', 100000000, 0, 0),
('CMP2024_14', 'Cứu trợ chó mèo hoang', 'Trạm cứu hộ quá tải, thiếu thức ăn.', 'Cung cấp hạt và thuốc thú y.', '/assets/images/drives/cho-meo.jpg', 'Ảnh trạm cứu hộ', '2026-01-01', '2026-12-31', 50000000, 1000000, 1),
('CMP2024_15', 'Nồi cháo tình thương BV Nhi', 'Bệnh nhi nghèo cần dinh dưỡng.', 'Nấu và phát 300 suất cháo sáng.', '/assets/images/drives/noi-chao.jpg', 'Ảnh phát cháo', '2026-01-01', '2026-06-30', 30000000, 5000000, 1);

-- 6. Dữ liệu Campaign_Companions
INSERT INTO campaign_companions (campaign_id, companion_id) VALUES
(1, 1), (1, 14), (2, 2), (2, 4), (2, 10), (3, 3), (3, 7), (4, 5),
(5, 6), (5, 8), (6, 12), (7, 15), (8, 6), (9, 13), (10, 4);

-- 7. Dữ liệu Donations (Mọi giao dịch giờ đều chỉ dùng cột user_id, tham chiếu đến User thật hoặc Shadow User)
INSERT INTO donations (user_id, campaign_id, payment_method_id, amount, message, is_anonymous, status) VALUES
-- Các giao dịch của User thật (Có tài khoản)
(2, 1, 1, 500000, 'Mong giúp được các em', 0, 1),
(3, 1, 2, 1000000, 'Gửi miền núi xa xôi', 0, 1),
(4, 2, 1, 2000000, 'Không cần nêu tên', 1, 1), -- User thật nhưng quyên góp ẩn danh
(5, 3, 5, 300000, 'Góp chút tiền phẫu thuật', 0, 1),
(9, 5, 6, 200000, 'Bữa cơm vùng cao', 0, 1),
(10, 10, 7, 1000000, 'Xây nhà mới cho cụ', 0, 1),
(2, 11, 8, 500000, 'Chúc mừng năm mới', 0, 0),

-- Các giao dịch của Khách vãng lai (Shadow Users - ID từ 11 đến 15)
(11, 2, 3, 5000000, 'Chia sẻ cùng miền Trung', 0, 1),
(12, 3, 4, 500000, 'Cố lên bé An', 1, 0), -- Khách quyên góp ẩn danh
(13, 5, 11, 50000, 'Bớt tô phở cho các em', 0, 1),
(14, 11, 13, 500000, 'Chúc cụ Bảy vui', 0, 1),
(15, 14, 9, 100000, 'Mua hạt cho chó mèo', 0, 1),

-- Các giao dịch khác
(6, 12, 14, 2000000, 'Gửi tặng vé xe', 0, 1),
(7, 15, 10, 500000, 'Phát cháo sáng thứ 7', 0, 1),
(8, 1, 2, 10000000, 'Ủng hộ từ cty', 1, 1);