# 🌐 Hệ thống Quyên góp Từ thiện (Charity Donation System)

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.1.x-brightgreen)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-17%2B-orange)](https://www.oracle.com/java/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)](https://www.mysql.com/)

Hệ thống kết nối trực tuyến giữa các nhà hảo tâm và các chiến dịch nhân đạo. Nền tảng giúp minh bạch hóa quy trình quyên góp, quản lý chiến dịch và đối soát tài chính một cách chuyên nghiệp.

---

## 🚀 Tính năng chính

Hệ thống được thiết kế với phân quyền rõ ràng cho 3 nhóm đối tượng:

### 1. Dành cho Khách & Thành viên (Public)
*   **Xác thực:** Đăng ký, Đăng nhập (Mật khẩu được mã hóa an toàn với BCrypt).
*   **Chiến dịch:** Khám phá danh sách các chiến dịch đang diễn ra và đã kết thúc.
*   **Quyên góp:** Thực hiện ủng hộ tiền qua nhiều phương thức thanh toán.
*   **Cá nhân hóa:** Quản lý hồ sơ, đổi mật khẩu và xem lịch sử quyên góp cá nhân.

### 2. Dành cho Quản trị viên (Admin)
*   **Quản lý người dùng:** Tìm kiếm, xem danh sách và Khóa/Mở khóa tài khoản.
*   **Quản lý chiến dịch:** Tạo mới, cập nhật thông tin và theo dõi tiến độ quỹ.
*   **Xác nhận giao dịch:** Đối soát sao kê và xác nhận các khoản quyên góp chờ xử lý.

---

## 🛠 Công nghệ sử dụng

Hệ thống được xây dựng theo kiến trúc **N-Tier** với mô hình **MVC** đảm bảo tính mở rộng và bảo trì dễ dàng.

*   **Backend:** Spring Boot (v3.x), Spring Data JPA, Hibernate.
*   **Database:** MySQL (v8.0).
*   **View Engine:** JSP (JavaServer Pages), JSTL.
*   **Frontend:** HTML5, CSS3, Bootstrap 5, FontAwesome, jQuery.
*   **Bảo mật:** Spring Security (hoặc Interceptor custom), BCrypt.

---

## 🏛 Cấu trúc mã nguồn

```text
src/main/java/org/tnphuong/charity/donation/
├── controller/    # Điều hướng Request và điều khiển logic giao diện
├── entity/        # Các lớp Thực thể (Mapping Database)
├── dao/           # Data Access Object (Spring Data JPA Repositories)
├── service/       # Business Logic Layer (Xử lý nghiệp vụ)
├── utils/         # Các lớp hỗ trợ (Security, Config, Interceptor)
└── CharityDonationApplication.java  # File khởi chạy Spring Boot

src/main/webapp/
├── WEB-INF/jsp/   # Các trang giao diện JSP
└── assets/        # Tài nguyên tĩnh (CSS, JS, Images)
```

---

## ⚙️ Hướng dẫn cài đặt

### 1. Chuẩn bị
*   JDK 17 trở lên.
*   MySQL Server 8.0.
*   IDE (IntelliJ IDEA, Eclipse) có hỗ trợ Maven.

### 2. Cài đặt Database
*   Tạo database mới trong MySQL.
*   Chạy script SQL trong file `Documents/HV_DB.sql` để khởi tạo cấu trúc bảng và dữ liệu mẫu.

### 3. Cấu hình ứng dụng
*   Mở file `src/main/resources/application.properties`.
*   Cập nhật thông tin kết nối CSDL của bạn:
    ```properties
    spring.datasource.url=jdbc:mysql://localhost:3306/your_db_name
    spring.datasource.username=your_username
    spring.datasource.password=your_password
    ```

### 4. Khởi chạy
*   Sử dụng Maven để chạy project:
    ```bash
    mvn spring-boot:run
    ```
*   Truy cập ứng dụng tại: `http://localhost:8080/`

---

## 📝 Thông tin dự án
Dự án thuộc bài tập lớn (Lab) phân tích thiết kế và xây dựng phần mềm Java Web.
