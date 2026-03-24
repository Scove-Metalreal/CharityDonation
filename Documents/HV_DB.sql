-- =========================================================
-- DATABASE: charity_donation_db
-- =========================================================
DROP DATABASE IF EXISTS charity_donation_db;
CREATE DATABASE charity_donation_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE charity_donation_db;

-- 1. BẢNG: roles
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

-- 2. BẢNG: users
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NULL, 
    phone_number VARCHAR(20) UNIQUE,
    address VARCHAR(255),
    avatar_url VARCHAR(500),
    role_id INT NOT NULL, 
    status TINYINT DEFAULT 1, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- 3. BẢNG: payment_methods
CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL,
    provider VARCHAR(100),
    account_number VARCHAR(100),
    logo_url VARCHAR(500),
    is_active TINYINT DEFAULT 1
);

-- 4. BẢNG: campaigns
CREATE TABLE campaigns (
    id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    background TEXT, 
    content TEXT,    
    image_url VARCHAR(500), 
    image_description VARCHAR(255), 
    gallery_urls TEXT,
    beneficiary_phone VARCHAR(20),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    target_money DECIMAL(15, 2) DEFAULT 0,
    current_money DECIMAL(15, 2) DEFAULT 0,
    status TINYINT DEFAULT 0, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. BẢNG: companions
CREATE TABLE companions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    logo_url VARCHAR(500),
    description VARCHAR(500),
    is_active TINYINT DEFAULT 1
);

-- 6. BẢNG: campaign_companions
CREATE TABLE campaign_companions (
    campaign_id INT NOT NULL,
    companion_id INT NOT NULL,
    PRIMARY KEY (campaign_id, companion_id),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (companion_id) REFERENCES companions(id) ON DELETE CASCADE
);

-- 7. BẢNG: donations
CREATE TABLE donations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    campaign_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    message VARCHAR(500),
    is_anonymous TINYINT DEFAULT 0,
    status TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id)
);

-- 8. BẢNG: user_following
CREATE TABLE user_following (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    campaign_id INT NOT NULL,
    receive_email TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
);

-- =========================================================
-- DỮ LIỆU MẪU (EXPANDED DATA)
-- =========================================================

-- 1. Roles
INSERT INTO roles (role_name, description) VALUES
('GUEST', 'Khách vãng lai'), ('USER', 'Thành viên'), ('ADMIN', 'Quản trị viên');

-- 2. Users (25 users)
INSERT INTO users (full_name, email, password, phone_number, address, role_id, status) VALUES
('Admin Charity', 'admin@charity.vn', '$2a$10$X8...', '0900000000', 'Hà Nội', 3, 1),
('Nguyễn Văn An', 'an.nv@gmail.com', '$2a$10$X8...', '0910000001', 'TP.HCM', 2, 1),
('Trần Thị Bình', 'binh.tt@gmail.com', '$2a$10$X8...', '0910000002', 'Đà Nẵng', 2, 1),
('Lê Hoàng Cường', 'cuong.lh@gmail.com', '$2a$10$X8...', '0910000003', 'Hải Phòng', 2, 1),
('Phạm Minh Đức', 'duc.pm@gmail.com', '$2a$10$X8...', '0910000004', 'Cần Thơ', 2, 1),
('Vũ Thu Hà', 'ha.vt@gmail.com', '$2a$10$X8...', '0910000005', 'Huế', 2, 1),
('Đặng Quốc Huy', 'huy.dq@gmail.com', '$2a$10$X8...', '0910000006', 'Bình Dương', 2, 1),
('Bùi Tuyết Mai', 'mai.bt@gmail.com', '$2a$10$X8...', '0910000007', 'Đồng Nai', 2, 1),
('Đỗ Hữu Nam', 'nam.dh@gmail.com', '$2a$10$X8...', '0910000008', 'Quảng Ninh', 2, 1),
('Hoàng Thùy Linh', 'linh.ht@gmail.com', '$2a$10$X8...', '0910000009', 'Nghệ An', 2, 1),
('Lý Tiểu Long', 'long.lt@gmail.com', NULL, '0810000010', NULL, 1, 1),
('Trần Hào', 'hao.t@gmail.com', NULL, '0810000011', NULL, 1, 1),
('Nguyễn Phi Hùng', 'hung.np@gmail.com', NULL, '0810000012', NULL, 1, 1),
('Mai Phương Thúy', 'thuy.mp@gmail.com', NULL, '0810000013', NULL, 1, 1),
('Sơn Tùng MTP', 'tung.mtp@gmail.com', NULL, '0810000014', NULL, 1, 1),
('Đen Vâu', 'den.vau@gmail.com', NULL, '0810000015', NULL, 1, 1),
('Hồ Ngọc Hà', 'ha.hn@gmail.com', '$2a$10$X8...', '0910000016', 'TP.HCM', 2, 1),
('Phan Mạnh Quỳnh', 'quynh.pm@gmail.com', '$2a$10$X8...', '0910000017', 'Nghệ An', 2, 1),
('Mỹ Tâm', 'tam.m@gmail.com', '$2a$10$X8...', '0910000018', 'Đà Nẵng', 2, 1),
('Đàm Vĩnh Hưng', 'hung.dv@gmail.com', '$2a$10$X8...', '0910000019', 'TP.HCM', 2, 1),
('Tóc Tiên', 'tien.t@gmail.com', NULL, '0810000020', NULL, 1, 1),
('Noo Phước Thịnh', 'noo.pt@gmail.com', NULL, '0810000021', NULL, 1, 1),
('Đông Nhi', 'nhi.d@gmail.com', NULL, '0810000022', NULL, 1, 1),
('Isaac', 'isaac@gmail.com', NULL, '0810000023', NULL, 1, 1),
('Suboi', 'suboi@gmail.com', NULL, '0810000024', NULL, 1, 1);

-- 3. Payment Methods (10)
INSERT INTO payment_methods (method_name, provider, account_number, is_active) VALUES
('Ví MoMo', 'MoMo', '0900000000', 1),
('ZaloPay', 'ZaloPay', '0900000000', 1),
('Vietcombank', 'VCB', '001100223344', 1),
('Techcombank', 'TCB', '190333444555', 1),
('MB Bank', 'MB', '999988887777', 1),
('VNPay', 'VNPay', '0900000000', 1),
('BIDV', 'BIDV', '1234567890', 1),
('Agribank', 'Agribank', '444455556666', 1),
('ShopeePay', 'Shopee', '0900000000', 1),
('Thẻ Visa/Master', 'Cổng thanh toán', '***', 0);

-- 4. Companions (20)
INSERT INTO companions (name, description, logo_url) VALUES
('Ví MoMo', 'Đối tác chiến lược', 'https://upload.wikimedia.org/wikipedia/commons/a/a0/MoMo_Logo_App.svg'),
('UNICEF', 'Quỹ nhi đồng LHQ', 'https://upload.wikimedia.org/wikipedia/commons/e/ed/Logo_of_UNICEF.svg'),
('VTV', 'Đài truyền hình VN', 'https://upload.wikimedia.org/wikipedia/commons/3/39/Vietnam_Television_logo_from_2013.svg'),
('Tuổi Trẻ', 'Báo Tuổi Trẻ', 'https://upload.wikimedia.org/wikipedia/commons/1/1f/Tu%E1%BB%95i_Tr%E1%BA%BB_Logo.svg'),
('Grab', 'Grab Việt Nam', 'https://upload.wikimedia.org/wikipedia/en/1/12/Grab_(application)_logo.svg'),
('Shopee', 'Shopee Việt Nam', 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Shopee.svg'),
('VinGroup', 'Tập đoàn Vingroup', 'https://upload.wikimedia.org/wikipedia/vi/9/98/Vingroup_logo.svg'),
('FPT', 'Tập đoàn FPT', 'https://upload.wikimedia.org/wikipedia/commons/1/11/FPT_logo_2010.svg'),
('Vietcombank', 'Ngân hàng VCB', 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Vietcombank_logo_fixed.svg'),
('Zalo', 'Zalo Group', 'https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg'),
('Hội Chữ Thập Đỏ', 'Hội chữ thập đỏ', 'https://upload.wikimedia.org/wikipedia/commons/e/ee/Red_Cross_icon.svg'),
('Quỹ Thiện Tâm', 'Quỹ từ thiện Vin', 'https://quyhyvong.com/wp-content/uploads/2021/12/Logo_Quy-Thien-Tam.png'),
('Vietnam Airlines', 'Hàng không quốc gia', 'https://upload.wikimedia.org/wikipedia/vi/b/bc/Vietnam_Airlines_logo.svg'),
('Bách Khoa HN', 'ĐH Bách Khoa', 'https://upload.wikimedia.org/wikipedia/vi/e/ef/Logo_%C4%90%E1%BA%A1i_h%E1%BB%8Dc_B%C3%A1ch_Khoa_H%C3%A0_N%E1%BB%99i.svg'),
('Kinh Đô', 'Tập đoàn Kinh Đô', 'https://cdn.haitrieu.com/wp-content/uploads/2022/08/logo-kinh-do.png'),
('Viettel', 'Tập đoàn Viettel', 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Viettel_logo_2021.svg'),
('VNPT', 'Tập đoàn VNPT', 'https://upload.wikimedia.org/wikipedia/vi/6/65/VNPT_Logo.svg'),
('Honda VN', 'Honda Việt Nam', 'https://upload.wikimedia.org/wikipedia/commons/3/38/Honda.svg'),
('Vinamilk', 'Sữa Việt Nam', 'https://upload.wikimedia.org/wikipedia/commons/7/70/Vinamilk_new_logo.svg'),
('Masan', 'Tập đoàn Masan', 'https://cdn.brandfetch.io/idY9yB4mYQ/w/240/h/80/theme/dark/logo.png?c=1bxid64Mup7aczewSAYMX&t=1772602877407');

-- 5. Campaigns (20 campaigns with various statuses)
INSERT INTO campaigns (code, name, background, start_date, end_date, target_money, current_money, status, beneficiary_phone) VALUES
('CMP001', 'Áo ấm Sơn La', 'Trẻ em vùng cao cần áo ấm', '2025-10-01', '2025-12-31', 50000000, 15000000, 1, '0901112223'),
('CMP002', 'Cứu trợ miền Trung', 'Lũ lụt gây thiệt hại nặng', '2025-11-01', '2025-11-30', 100000000, 100000000, 2, '0903334445'),
('CMP003', 'Mổ tim bé An', 'Bé An cần phẫu thuật gấp', '2025-12-01', '2026-02-28', 80000000, 25000000, 1, '0904445556'),
('CMP004', 'Xây cầu Trà Vinh', 'Bà con đi lại khó khăn', '2026-01-01', '2026-06-30', 200000000, 0, 0, '0905556667'),
('CMP005', 'Bữa cơm vùng cao', 'Thêm thịt vào bữa ăn cho bé', '2026-01-15', '2026-12-31', 150000000, 5000000, 1, '0906667778'),
('CMP006', 'Tặng xe đạp', 'Học sinh nghèo hiếu học', '2025-08-01', '2025-09-05', 120000000, 120000000, 3, '0907778889'),
('CMP007', 'Thư viện ước mơ', 'Xây phòng đọc sách cho trẻ', '2026-02-01', '2026-05-31', 60000000, 0, 0, '0908889990'),
('CMP008', 'Học bổng SV nghèo', 'Giúp SV không bỏ học', '2026-03-01', '2026-09-30', 300000000, 0, 0, '0909990001'),
('CMP009', 'Nước sạch miền Tây', 'Lắp máy lọc nước mặn', '2026-04-01', '2026-08-31', 250000000, 0, 0, '0901113334'),
('CMP010', 'Nhà tình thương cụ Bảy', 'Xây lại nhà dột nát', '2025-12-15', '2026-01-30', 50000000, 30000000, 1, '0902224445'),
('CMP011', 'Tết ấm tình thân', 'Quà tết cho người nghèo', '2025-12-20', '2026-01-25', 40000000, 38000000, 1, '0903335556'),
('CMP012', 'Chuyến xe 0 đồng', 'Đưa công nhân về quê', '2025-12-01', '2026-01-20', 80000000, 80000000, 2, '0904446667'),
('CMP013', 'Bảo vệ rùa biển', 'Côn Đảo mùa rùa đẻ', '2026-05-01', '2026-12-31', 100000000, 0, 0, '0905557778'),
('CMP014', 'Cứu trợ chó mèo', 'Trạm cứu hộ quá tải', '2026-01-01', '2026-12-31', 50000000, 2000000, 1, '0906668889'),
('CMP015', 'Cháo sáng BV Nhi', 'Nồi cháo yêu thương', '2026-01-01', '2026-06-30', 30000000, 10000000, 1, '0907779990'),
('CMP016', 'Mắt sáng cho người già', 'Mổ đục thủy tinh thể', '2026-02-15', '2026-04-15', 100000000, 0, 0, '0908880001'),
('CMP017', 'Vắc xin cho em', 'Tiêm chủng vùng sâu', '2026-03-10', '2026-05-10', 70000000, 0, 0, '0909991112'),
('CMP018', 'Trường mới cho bản', 'Xây điểm trường mầm non', '2026-04-20', '2026-10-20', 500000000, 0, 0, '0901112223'),
('CMP019', 'Hỗ trợ nạn nhân hỏa hoạn', 'Chung tay giúp gia đình', '2025-12-25', '2026-01-25', 200000000, 150000000, 1, '0902223334'),
('CMP020', 'Máy tính cho em', 'Phòng tin học vùng xa', '2026-05-15', '2026-08-15', 120000000, 0, 0, '0903334445');

-- 6. Campaign Companions (25 relationships)
INSERT INTO campaign_companions (campaign_id, companion_id) VALUES 
(1,1), (1,3), (2,2), (2,4), (3,2), (3,7), (5,1), (5,5), (6,12), (10,11),
(11,9), (12,13), (14,1), (15,14), (19,10), (1,14), (2,11), (3,12), (5,13), (10,14),
(11,15), (12,16), (14,17), (15,18), (19,19);

-- 7. Donations (30 donations with various statuses)
INSERT INTO donations (user_id, campaign_id, payment_method_id, amount, message, is_anonymous, status) VALUES
(2, 1, 1, 500000, 'Gửi các em', 0, 1),
(3, 1, 3, 1000000, 'Chúc các em ấm áp', 0, 1),
(11, 1, 1, 200000, 'Của ít lòng nhiều', 1, 1),
(17, 3, 4, 2000000, 'Mong bé mau khỏe', 0, 1),
(18, 3, 5, 500000, 'Gửi bé An', 0, 1),
(12, 3, 1, 100000, 'Cố lên bé ơi', 1, 0),
(4, 2, 2, 5000000, 'Miền Trung cố lên', 0, 1),
(13, 2, 3, 1000000, 'Ủng hộ đồng bào', 0, 1),
(19, 5, 1, 300000, 'Bữa cơm cho bé', 0, 1),
(20, 5, 6, 1000000, 'Thương các em', 0, 1),
(14, 5, 1, 50000, 'Mong giúp được chút', 1, 1),
(2, 10, 7, 5000000, 'Xây nhà cho cụ', 0, 1),
(15, 10, 1, 200000, 'Của ít lòng nhiều', 1, 1),
(3, 11, 2, 500000, 'Tết ấm áp', 0, 1),
(16, 11, 1, 1000000, 'Chúc mọi người ăn Tết vui', 1, 1),
(21, 14, 1, 50000, 'Mua hạt cho mấy bé', 0, 1),
(22, 14, 1, 100000, 'Trạm cố lên', 0, 1),
(23, 15, 1, 200000, 'Nồi cháo tình thương', 0, 1),
(24, 15, 1, 500000, 'Gửi bệnh nhi', 0, 1),
(25, 19, 1, 10000000, 'Giúp gia đình vượt qua', 0, 1),
(2, 19, 3, 5000000, 'Chia sẻ mất mát', 0, 1),
(3, 19, 1, 1000000, 'Mong gia đình sớm ổn định', 0, 0),
(4, 1, 1, 200000, 'Áo ấm', 0, 0),
(5, 3, 1, 500000, 'Mổ tim', 0, 0),
(6, 5, 1, 100000, 'Bữa cơm', 0, 0),
(7, 10, 1, 2000000, 'Nhà tình thương', 0, 0),
(8, 11, 1, 500000, 'Quà Tết', 0, 0),
(9, 14, 1, 100000, 'Chó mèo', 0, 0),
(10, 15, 1, 300000, 'Cháo', 0, 0),
(2, 2, 1, 1000000, 'Miền trung', 0, 0);

-- 8. User Following (20 follows)
INSERT INTO user_following (user_id, campaign_id, receive_email) VALUES
(2, 1, 1), (2, 3, 1), (2, 5, 0), (3, 1, 1), (3, 10, 1), 
(4, 2, 1), (4, 11, 0), (5, 3, 1), (5, 19, 1), (17, 3, 1),
(17, 19, 0), (18, 1, 1), (18, 5, 1), (19, 5, 1), (19, 15, 0),
(20, 10, 1), (20, 19, 1), (2, 19, 1), (3, 19, 1), (4, 19, 1);
