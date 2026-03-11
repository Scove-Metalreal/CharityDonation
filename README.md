🌐 Website Quyên Góp Từ Thiện (Charity Donation System)

Đây là dự án ứng dụng Web được xây dựng nhằm tạo ra một nền tảng kết nối trực tuyến giữa các nhà hảo tâm và các chiến dịch nhân đạo. Hệ thống giúp số hóa quy trình quyên góp, quản lý chiến dịch và minh bạch hóa quá trình đối soát tài chính.

🚀 Các chức năng chính (Key Features)

Dự án phân chia quyền hạn rõ ràng cho 3 nhóm đối tượng: Khách vãng lai (Guest), Thành viên (User) và Quản trị viên (Admin).

1. Dành cho Guest & User (Trang Public)

Xác thực: Đăng ký, Đăng nhập (Mật khẩu được mã hóa an toàn).

Khám phá: Xem danh sách các chiến dịch quyên góp đang diễn ra và đã kết thúc.

Quyên góp: Thực hiện đóng góp tiền thông qua chuyển khoản ngân hàng (hỗ trợ cả quyên góp ẩn danh cho khách vãng lai).

Cá nhân hóa (User): Quản lý hồ sơ cá nhân, đổi mật khẩu và xem lịch sử các lần quyên góp cùng trạng thái xác nhận.

2. Dành cho Admin (Trang Quản trị)

Quản lý Người dùng: Xem danh sách thành viên, tìm kiếm và Khóa/Mở khóa tài khoản vi phạm.

Quản lý Chiến dịch: Tạo mới, cập nhật thông tin và thay đổi trạng thái của các đợt quyên góp.

Xác nhận giao dịch: Đối soát sao kê ngân hàng và xác nhận các giao dịch "Chờ xác nhận" để tự động cộng dồn vào quỹ của chiến dịch.

🛠 Công nghệ sử dụng (Tech Stack)

Dự án được xây dựng theo kiến trúc N-Tier kết hợp mô hình MVC (Model-View-Controller) tuần thủ nguyên tắc thiết kế lỏng lẻo (Loose Coupling) và Single Responsibility.

Ngôn ngữ: Java 8+

Backend: Java Servlet, JSP, JSTL

Database: MySQL 8.x (sử dụng JDBC thuần)

Web Server: Apache Tomcat 9+

Frontend: HTML5, CSS3, Bootstrap 5, jQuery, FontAwesome

Bảo mật: jBCrypt (Mã hóa mật khẩu một chiều)

🏛 Cấu trúc mã nguồn (Project Structure)

Dự án được tổ chức theo chuẩn cấu trúc thư mục của Java Dynamic Web Project:

CharityDonationProject
├── src/main/java/com/charity/
│ ├── model/ # Các lớp Thực thể (User, Role, Campaign, Donation...)
│ ├── utils/ # Lớp hỗ trợ: DBContext (Kết nối CSDL), Security (BCrypt)
│ ├── dao/ # Data Access Layer (Các Interface DAO)
│ │ └── impl/ # Các lớp thực thi (UserDAOImpl, CampaignDAOImpl...)
│ ├── service/ # Business Logic Layer (Các Interface Service)
│ │ └── impl/ # Các lớp thực thi nghiệp vụ (AuthServiceImpl...)
│ └── controller/ # Servlet (Presentation Layer điều hướng request)
│
└── src/main/webapp/
├── assets/ # Tài nguyên tĩnh: css, js, thư mục images
├── view/ # Các trang giao diện .jsp (public và admin)
└── WEB-INF/ # Cấu hình web.xml và thư mục lib chứa .jar

🗄 Cấu trúc Cơ sở dữ liệu (Database Schema)

Hệ thống sử dụng cơ sở dữ liệu quan hệ được chuẩn hóa (3NF) với các bảng chính:

roles: Quản lý phân quyền (ADMIN, USER, GUEST).

users: Thông tin tài khoản người dùng và tài khoản ngầm (Shadow Account) của khách.

campaigns: Thông tin chi tiết các chiến dịch từ thiện.

payment_methods: Quản lý cổng thanh toán / ngân hàng nhận tiền.

donations: Bảng lưu trữ giao dịch quyên góp.

companions & campaign_companions: Quản lý các nhà đồng hành của chiến dịch.

⚙️ Hướng dẫn cài đặt và chạy dự án (Installation)

Chuẩn bị môi trường: Cài đặt JDK 8+, Apache Tomcat 9+ và MySQL Server.

Cài đặt Database:

Mở MySQL Workbench hoặc công cụ quản lý DB bất kỳ.

Chạy toàn bộ script trong file HV_DB.sql để khởi tạo cấu trúc bảng và nạp dữ liệu mẫu (Dummy Data).

Cấu hình dự án:

Mở dự án bằng IDE (Eclipse, IntelliJ IDEA, ...).

Đảm bảo các file .jar (MySQL Connector, jBCrypt, JSTL) đã được add vào thư mục WEB-INF/lib.

Mở file src/main/java/com/charity/utils/DBContext.java và cấu hình lại thông số kết nối CSDL (Tên DB, Username, Password) cho phù hợp với máy cá nhân của bạn.

Deploy & Chạy:

Build project và Deploy lên server Apache Tomcat.

Truy cập ứng dụng qua đường dẫn mặc định: http://localhost:8080/CharityDonationProject

Dự án thuộc bài tập lớn (Lab) phân tích thiết kế và xây dựng phần mềm.
