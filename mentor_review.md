# Báo cáo Nhận xét Mentor - Dự án Quyên Góp Từ Thiện

**Sinh viên:** Trần Nguyễn Phương (Fx35576)  
**Môn học:** LAB301x — Lab 3  
**Tài liệu tham chiếu:** Software Requirement Specification (SRS), Mã nguồn dự án

---

## 📌 Nhận xét chung

Dự án được thực hiện nghiêm túc và có chiều sâu. Tài liệu SRS được viết bài bản, đủ các chương mục (Use Case, Yêu cầu phi chức năng, Kiến trúc, Database), cho thấy sinh viên đã dành thời gian phân tích và thiết kế trước khi code. Mã nguồn bám sát tài liệu SRS ở mức độ cao. Đây là điểm cộng lớn thể hiện tư duy làm việc chuyên nghiệp.

---

## ✅ Phần I — Đánh giá Tài liệu SRS

### 1. Ưu điểm của Tài liệu

| Tiêu chí | Nhận xét |
|---|---|
| **Cấu trúc** | Đủ chương (Giới thiệu, Yêu cầu, Kiến trúc, DB, UI) — đúng chuẩn SRS |
| **Use Case** | 18 Use Case với Goal, Pre/Post-condition, các bước rõ ràng — Rất tốt |
| **Phân quyền** | Mô tả rõ 3 nhóm (Guest, User, Admin) và từng quyền — Tốt |
| **Phi chức năng** | Có yêu cầu Usability, Reliability, Availability — Đủ |

### 2. Điểm cần cải thiện trong Tài liệu

*   **UC-USR-01-E2 (Đổi mật khẩu) — Bước 4 sai logic:** Trong SRS, Bước 4 của Use Case đổi mật khẩu lại mô tả "_kiểm tra Email hoặc Số điện thoại đã tồn tại_" — đây là nội dung của UC Đăng ký, bị copy nhầm sang đây. Đây là lỗi nghiêm trọng trong tài liệu.
*   **UC-DRV-02 — nhãn bước sai:** Step 1 và 3 của UC-DRV-02 dùng nhãn "Link Đăng ký" và "Button Đăng ký" thay vì nút chỉnh sửa — rõ ràng là copy-paste lỗi.
*   **Yêu cầu phi chức năng về DB:** SRS nêu dùng `BIGINT` cho tiền tệ, nhưng DB design lại dùng `DECIMAL(15,2)` — có sự không nhất quán (tuy nhiên `DECIMAL` thực ra là lựa chọn đúng hơn về mặt kỹ thuật).

---

## ✅ Phần II — Đánh giá Mã nguồn (So sánh với SRS)

### 1. Mức độ tuân thủ Use Case

| Use Case | Yêu cầu SRS | Mã nguồn | Ghi chú |
|---|---|---|---|
| UC-AUTH-01: Đăng ký | ✅ Đầy đủ | ✅ Triển khai đúng | BCrypt, check email/SĐT trùng |
| UC-AUTH-02: Đăng nhập | ✅ Đầy đủ | ✅ Triển khai đúng | Role-based redirect, status check |
| UC-USR-01: Xem Profile | ✅ | ✅ | OK |
| UC-USR-01-E1: Cập nhật Profile | ✅ | ✅ | OK |
| UC-USR-01-E2: Đổi mật khẩu | ✅ | ✅ | OK |
| UC-ADM-USR: Quản lý User | ✅ | ✅ Đầy đủ | Có phân trang, tìm kiếm, filter |
| UC-ADM-USR-E3: Thêm User | ✅ | ✅ | OK |
| UC-ADM-USR-E4/E5: Khóa/Mở tài khoản | ✅ | ✅ | Toggle status đúng |
| UC-DRV-01: Tạo chiến dịch | ✅ | ✅ Tốt | Có upload ảnh, chọn đối tác |
| UC-DRV-02: Cập nhật chiến dịch | ✅ | ✅ | Có gia hạn, đổi trạng thái |
| UC-DRV-03: Duyệt danh sách | ✅ | ✅ | Có filter trạng thái |
| UC-DRV-04: Xem chi tiết | ✅ | ✅ | Có Progress Bar |
| UC-DON-01: Quyên góp | ✅ | ✅ | Trạng thái Pending đúng |
| UC-DON-02: Xác nhận tiền | ✅ | ✅ | Tự động cộng current_money vào campaign |
| UC-DON-03: Xem lịch sử | ✅ | ✅ | OK |

> **Kết luận:** Tỷ lệ tuân thủ Use Case rất cao, khoảng **~95%**. Đây là thành tích xuất sắc.

---

### 2. Điểm SRS yêu cầu nhưng Code chưa/thiếu triển khai

*   **NFR — Transaction Database (Yêu cầu quan trọng):** SRS yêu cầu "_Xác nhận quyên góp và cộng tiền phải nằm trong một database Transaction_". Nhưng trong mã nguồn (`DonationServiceImpl`), hai thao tác cập nhật `donation.status` và `campaign.currentMoney` được gọi riêng biệt mà không có `@Transactional`. Nếu lỗi xảy ra ở bước 2, dữ liệu sẽ bị mất đồng bộ.

    ```java
    // Cần thêm annotation này vào method confirmDonation()
    @Transactional
    public void confirmDonation(Integer donationId) { ... }
    ```

*   **UC-AUTH-02 — Bảo mật thông báo lỗi:** SRS yêu cầu "_Hiển thị lỗi chung 'Sai Email hoặc Mật khẩu' để không lộ cái nào bị sai_". Code hiện tại ([AuthController](/src/main/java/org/tnphuong/charity/donation/controller/AuthController.java#16-112)) đã làm đúng điểm này — tốt.

*   **UC-DON-01 — Guest quyên góp ẩn danh không cần tài khoản:** SRS cho phép Guest nhập họ tên và email để quyên góp. Cần kiểm tra phần này trong `UserController` để đảm bảo Guest không bị bắt đăng nhập trước.

---

### 3. Điểm mạnh của mã nguồn (vượt trên SRS)

*   **Notification badge cho Admin:** Admin dashboard có badge đếm số giao dịch chờ xác nhận — không có trong SRS nhưng là tính năng UX rất hay.
*   **Tự động chuyển trạng thái chiến dịch:** Khi đủ tiền, chiến dịch tự động chuyển sang `STATUS_ENDED` — logic nghiệp vụ thông minh, SRS không đề cập.
*   **Chặn xóa chiến dịch đang hoạt động** trong [CampaignServiceImpl](src/main/java/org/tnphuong/charity/donation/service/CampaignServiceImpl.java#14-118) — bảo vệ toàn vẹn dữ liệu tốt.

---

## 🛠️ Phần III — Các điểm cần cải thiện (Kỹ thuật)

### 1. Thiếu `@Transactional` — Ưu tiên cao nhất
Như đã phân tích ở trên, đây là lỗi có thể gây mất đồng bộ dữ liệu thực tế.

### 2. Repository bị inject thẳng vào Controller  
```java
// AdminController.java - Line 41-47
@Autowired
private org.tnphuong.charity.donation.dao.UserRepository userRepository;
@Autowired
private org.tnphuong.charity.donation.dao.CampaignRepository campaignRepository;
```
Controller không nên gọi trực tiếp Repository. Mọi thao tác phải đi qua Service layer.

### 3. Mật khẩu mặc định hardcode  
```java
// UserServiceImpl.java - Line 38
user.setPassword(PasswordUtils.hashPassword("123456"));
```
Mật khẩu mặc định "123456" được hardcode — cần chuyển vào [application.properties](src/main/resources/application.properties).

### 4. `System.out.println()` còn trong code production  
```java
// AuthController.java - Line 71, 92
System.out.println("DEBUG: Dang nhap voi email...");
```
Nên thay bằng `Logger` (SLF4J/Logback) — Spring Boot đã tích hợp sẵn.

### 5. Thiếu xử lý ngoại lệ tập trung  
```java
// AdminController.java - Line 320
} catch (Exception e) {} // Empty catch block
```
Bắt exception rỗng (empty catch) là code smell nghiêm trọng.

## 🛠 Những điểm cần cải thiện (Areas for Improvement)

### 1. Kiến trúc (Architecture)
*   **Thiếu lớp DTO (Data Transfer Object)**: Hiện tại bạn đang dùng trực tiếp `Entity` ở tầng View và Controller.
    *   *Rủi ro*: Lộ các trường nhạy cảm (như `password`), gây lỗi `LazyInitializationException` khi render JSP.
    *   *Lời khuyên*: Nên dùng DTO để nhận dữ liệu từ Form và trả dữ liệu ra View thông qua một Mapper (như MapStruct hoặc ModelMapper).

### 2. Bảo mật (Security)
*   **Security Interceptor**: Việc dùng Interceptor thủ công để check quyền là cách tiếp cận cơ bản.
    *   *Cải thiện*: Hãy tìm hiểu và tích hợp **Spring Security**. Nó cung cấp giải pháp mạnh mẽ hơn cho phân quyền (RBAC), chống tấn công CSRF, Session Fixation, v.v.
*   **Quản lý mật khẩu**: Trong [UserServiceImpl](src/main/java/org/tnphuong/charity/donation/service/UserServiceImpl.java#12-85), bạn đang kiểm tra mật khẩu đã hash bằng cách check prefix `$2a$`. Cách này hơi "thủ công".
    *   *Cải thiện*: Nên có logic nhất quán: Luôn hash mật khẩu ở tầng Service trước khi lưu, hoặc dùng `PasswordProxy` để xử lý.

### 3. Chất lượng mã nguồn (Code Quality)
*   **Magic Strings & Numbers**: Các trạng thái (`STATUS_NEW = 0`, `"ADMIN"`, `"USER"`) xuất hiện nhiều dưới dạng giá trị cứng.
    *   *Cải thiện*: Nên sử dụng **Enum** cho tất cả các trạng thái (CampaignStatus, UserRole). Ví dụ: `CampaignStatus.NEW` thay vì `0`.
*   **Validation**: Bạn đang validate dữ liệu thủ công trong Controller (dùng `if-else`).
    *   *Cải thiện*: Hãy dùng **JSR-303 / Jakarta Bean Validation** (các annotation như `@NotBlank`, `@Email`, `@Min`). Nó sẽ giúp Controller gọn gàng hơn nhiều.
*   **Xử lý ngoại lệ (Exception Handling)**: Hiện tại bạn dùng `try-catch` cục bộ hoặc gán lỗi vào `Model`.
    *   *Cải thiện*: Nên sử dụng `@ControllerAdvice` và `@ExceptionHandler` để quản lý lỗi tập trung.

### 4. Cơ sở dữ liệu (Database)
*   **Migration**: Việc phải chạy file [.sql](Documents/HV_DB.sql) thủ công có thể gây sai lệch giữa các môi trường.
    *   *Cải thiện*: Thử tích hợp **Flyway** hoặc **Liquibase** để quản lý phiên bản Database ngay trong mã nguồn.
