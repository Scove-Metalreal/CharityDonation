# KỊCH BẢN THUYẾT TRÌNH DỰ ÁN: NỀN TẢNG QUYÊN GÓP TỪ THIỆN

**Thời lượng dự kiến:** 45 - 60 phút  
**Người thực hiện:** Trần Nguyên Phương

---

## PHẦN 1: GIỚI THIỆU DỰ ÁN VÀ LÝ DO CHỌN ĐỀ TÀI (2 - 3 phút)

Kính thưa Hội đồng và các thầy cô, em tên là Trần Nguyên Phương. Hôm nay em xin phép trình bày về dự án cuối khóa của mình mang tên: **Website Quyên Góp Từ Thiện**.

Ý tưởng và cảm hứng thiết kế của dự án này được em lấy trực tiếp từ nền tảng [Trái tim MoMo](https://momo.vn/trai-tim-momo) - một trong những nền tảng thiện nguyện số hàng đầu Việt Nam. Em mong muốn tái hiện lại trải nghiệm người dùng mượt mà và tính minh bạch trong việc kết nối các tấm lòng hảo tâm với các hoàn cảnh khó khăn.

Lý do em thực hiện dự án này xuất phát từ thực tế: hiện nay các hoạt động thiện nguyện đang ngày càng phổ biến, nhưng việc kết nối giữa nhà hảo tâm và các tổ chức thiện nguyện vẫn còn tồn tại nhiều bất cập về tính minh bạch và quy trình xác nhận. Chính vì vậy, em muốn xây dựng một nền tảng công nghệ tin cậy, nơi mỗi giao dịch đều được ghi nhận rõ ràng, giúp nhà hảo tâm dễ dàng theo dõi dòng tiền của mình và giúp Admin quản lý các chiến dịch thiện nguyện một cách khoa học.

---

## PHẦN 2: PHẠM VI VÀ ĐỐI TƯỢNG SỬ DỤNG (2 - 3 phút)

Dự án này tập trung vào việc quản lý luồng quyên góp từ khi bắt đầu chiến dịch cho đến khi tiền đến tay người cần giúp đỡ. Hệ thống chia thành 3 đối tượng sử dụng chính:

1.  **Khách vãng lai (Guest):** Đây là những người chưa có tài khoản. Họ có thể xem danh sách, chi tiết chiến dịch và thực hiện quyên góp ngay lập tức sau khi cung cấp thông tin định danh cơ bản.
2.  **Thành viên (User):** Đây là những người đã đăng ký. Ngoài các quyền như Guest, họ có thể theo dõi chiến dịch để nhận thông báo qua email, xem lịch sử quyên góp cá nhân và quản lý hồ sơ.
3.  **Quản trị viên (Admin):** Có toàn quyền điều hành hệ thống, bao gồm quản lý người dùng, tạo mới và cập nhật chiến dịch, đặc biệt là nhiệm vụ đối soát và xác nhận các giao dịch tiền tệ.

---

## PHẦN 3: PHÂN TÍCH YÊU CẦU (5 phút)

Các yêu cầu của hệ thống được em xác định và bám sát dựa trên tài liệu **Yêu cầu người dùng (URD)** của đồ án để đảm bảo tính thực tiễn và nghiệp vụ.

Về **yêu cầu chức năng**, hệ thống được chia thành các luồng nghiệp vụ rõ ràng:
1.  **Đăng ký/Đăng nhập:** Hỗ trợ xác thực nội bộ và đăng nhập nhanh qua Google.
2.  **Xem danh sách chiến dịch:** Cung cấp thông tin trực quan về mục tiêu, tiến độ và hoàn cảnh cần giúp đỡ.
3.  **Quyên góp:** Luồng xử lý giao dịch minh bạch, cho phép người dùng tùy chọn ẩn danh.
4.  **Quản lý hồ sơ:** Giúp người dùng theo dõi lịch sử quyên góp và các chiến dịch đang quan tâm.
5.  **Admin - Quản lý:** Quản trị toàn diện Người dùng (User), Chiến dịch (Campaign) và phê duyệt Quyên góp (Donation).

Về **yêu cầu phi chức năng**, em tập trung vào 4 tiêu chí:
*   **Bảo mật:** Mã hóa mật khẩu BCrypt, phân quyền truy cập đa lớp.
*   **Tính nhất quán:** Đảm bảo số dư và tiến độ quyên góp luôn chính xác tuyệt đối.
*   **Giao diện dễ dùng (Usability):** Layout được thiết kế hiện đại với **Sidebar một bên** lấy ý tưởng từ các nền tảng như Twitter, kết hợp cùng các template chuyên dụng cho Admin layout và trang cá nhân để tạo sự chuyên nghiệp và đồng bộ.
*   **Tính mở rộng:** Cấu trúc code cho phép dễ dàng tích hợp thêm các cổng thanh toán (VNPay/Momo) hoặc Cloud Storage sau này.

---

## PHẦN 4: USE CASE TỔNG QUÁT (3 - 5 phút)

Dựa trên phân tích trên, em thiết kế sơ đồ Use Case tổng quát chia làm 2 phần:

**Với người dùng cuối (Guest/User):**
*   Xem danh sách và chi tiết chiến dịch để tìm hiểu thông tin.
*   Thực hiện quyên góp (chức năng cốt lõi).
*   Theo dõi chiến dịch để cập nhật tình hình.
*   Xem lịch sử để biết tiền của mình đã được Admin xác nhận hay chưa.

**Với Quản trị viên (Admin):**
*   Quản lý người dùng để ngăn chặn các tài khoản spam hoặc vi phạm.
*   Quản lý chiến dịch: Từ khâu lên ý tưởng, đặt mục tiêu đến khi đóng chiến dịch.
*   Xác nhận quyên góp: Đây là bước quan trọng nhất để hợp lệ hóa dòng tiền vào quỹ chiến dịch.

---

## PHẦN 5: THIẾT KẾ KIẾN TRÚC HỆ THỐNG (CHUYÊN SÂU)

He thống được thiết kế theo kiến trúc **N-Tier (đa tầng)** trên nền tảng **Spring Boot 3**, nhằm tối ưu hóa việc bảo trì và mở rộng. Thay vì kiến trúc Monolith truyền thống nơi logic bị trộn lẫn, em chia thành 4 lớp tách biệt hoàn toàn:

1.  **Lớp Presentation (Web Layer):** Em sử dụng Spring MVC với `DispatcherServlet` làm trung tâm. Các `@Controller` ở đây chỉ đóng vai trò "lễ tân": tiếp nhận Request, dùng Jakarta Bean Validation để kiểm tra định dạng dữ liệu ngay tại đầu vào, sau đó gọi xuống tầng Service. Em không cho phép Controller tự ý gọi trực tiếp đến Database để tránh làm lộ logic truy vấn ra bên ngoài.
2.  **Lớp Business Logic (Service Layer):** Đây là nơi tập trung toàn bộ "chất xám" của dự án. Em áp dụng nguyên tắc Interface-based Programming. Mỗi Service (như `CampaignService`, `DonationService`) đều có một Interface và một lớp Implementation (Impl). Cách làm này cho phép em triển khai "Loose Coupling" (phụ thuộc lỏng lẻo). *Ví dụ: Nếu sau này chúng ta thay đổi thuật toán tính toán tiền quỹ, em chỉ cần thay lớp Impl mà không cần sửa một dòng code nào ở tầng Controller.* Tại đây, em cũng quản lý các giao dịch bằng `@Transactional` để đảm bảo tính nguyên tử cho dữ liệu.
3.  **Lớp Data Access (Repository Layer):** Em tận dụng sức mạnh của Spring Data JPA. Thay vì viết các lớp DAO với hàng nghìn dòng code JDBC thuần, em chỉ cần khai báo các Interface kế thừa `JpaRepository`. Hibernate sẽ tự động sinh ra các câu lệnh SQL tối ưu. Với các truy vấn phức tạp như tìm kiếm linh hoạt User theo nhiều điều kiện, em sử dụng `@Query` với tham số truyền vào để chống tấn công SQL Injection một cách tuyệt đối.
4.  **Lớp Persistence (Database Layer):** MySQL 8.0 lưu trữ dữ liệu thực tế.

**Tại sao em chọn kiến trúc này?** Tác dụng lớn nhất là khả năng kiểm thử độc lập. Em có thể viết Unit Test cho lớp Service mà không cần phải bật Server hay kết nối Database, giúp tốc độ phát triển nhanh hơn và ít lỗi hơn.

---

## PHẦN 6: CÔNG NGHỆ SỬ DỤNG (3 - 4 phút)

Em sử dụng bộ công nghệ hiện đại bao gồm:
*   **Java 17:** Phiên bản LTS ổn định với nhiều tính năng mới.
*   **Spring Boot 3:** Giúp tự động hóa cấu hình và triển khai nhanh.
*   **Spring Data JPA / Hibernate:** Quản lý ORM và giao tiếp database hiệu quả.
*   **Spring Security OAuth2:** Để hỗ trợ tính năng đăng nhập bằng Google.
*   **BCrypt:** Thuật toán băm mật khẩu tiêu chuẩn quân đội.
*   **Maven:** Quản lý thư viện và build dự án.

Lý do em chọn Spring Boot là vì nó cung cấp Embedded Tomcat, giúp em chạy ứng dụng như một file độc lập mà không cần cấu hình server phức tạp, đồng thời hệ sinh thái của nó rất lớn, hỗ trợ tốt cho việc bảo mật và kiểm thử.

---

## PHẦN 7: THIẾT KẾ CƠ SỞ DỮ LIỆU (CHI TIẾT QUAN HỆ)

ERD của hệ thống được chuẩn hóa đến dạng chuẩn 3 (3NF) để loại bỏ dư thừa dữ liệu. Dưới đây là các đặc điểm thực thể nổi bật và mối quan hệ giữa chúng:

**Các thực thể nổi bật (Entities):**
*   **Users:** Lưu trữ thông tin định danh và hỗ trợ đa dạng phương thức xác thực (`auth_provider` LOCAL/GOOGLE).
*   **Campaigns:** Sử dụng kiểu dữ liệu `DECIMAL(15,2)` để đảm bảo độ chính xác tài chính; trường `content` cho phép lưu trữ mô tả phong phú kèm hình ảnh minh họa.
*   **Donations:** Thực thể trung tâm lưu vết mọi giao dịch, hỗ trợ cờ `is_anonymous` để bảo vệ quyền riêng tư của nhà hảo tâm.
*   **Companions:** Lưu trữ thông tin các đối tác đồng hành chuyên nghiệp (Ví MoMo, UNICEF, VTV...).

**Mối quan hệ giữa các thực thể (Relationships):**
*   **Roles 1 -> N Users:** Phân quyền hệ thống một cách chặt chẽ (ADMIN, USER, GUEST).
*   **Users 1 -> N Donations:** Lưu vết toàn bộ lịch sử ủng hộ của từng thành viên.
*   **Campaigns 1 -> N Donations:** Theo dõi chi tiết dòng tiền đổ vào từng chiến dịch để tính toán tiến độ.
*   **PaymentMethods 1 -> N Donations:** Liên kết mỗi khoản quyên góp với một kênh thanh toán cụ thể.
*   **Campaigns N <-> N Companions:** (Thông qua bảng `campaign_companions`) Thể hiện sự đồng hành của nhiều tổ chức trong một dự án.
*   **Users N <-> N Campaigns:** (Thông qua bảng `user_following`) Tính năng quan tâm và theo dõi sát sao tiến độ chiến dịch.

**Điểm đặc biệt trong thiết kế:** Em sử dụng khóa ngoại (Foreign Key) với các ràng buộc `ON DELETE CASCADE` ở các bảng liên kết như `Donations` và `User_Following`. Nghĩa là nếu một chiến dịch bị xóa (trong trường hợp chưa có giao dịch xác nhận), các dữ liệu liên quan sẽ tự động được dọn dẹp, đảm bảo database luôn nhất quán và sạch sẽ.

---

## PHẦN 8: THIẾT KẾ CHỨC NĂNG CHÍNH VÀ GIẢI QUYẾT VẤN ĐỀ THỰC TẾ

Trong phần này, em xin trình bày logic thiết kế của 5 chức năng cốt lõi được hiển thị theo các bước (steps) thực thi thực tế trong code:

### 1. Luồng Xác thực và Tài khoản (Authentication & Account Flow):
*   **Bước 1:** User chọn "Đăng nhập bằng Google". Spring Security redirect người dùng đến Google Authorization Server.
*   **Bước 2:** Sau khi User xác nhận, Google trả về Authorization Code. Spring Security tự động trao đổi Code lấy Access Token và lấy thông tin UserInfo (Email, Name, Id).
*   **Bước 3:** `OAuth2SuccessHandler` trong code sẽ tiếp nhận thông tin này và kiểm tra Email trong Database:
    *   **Case A (Đã có tài khoản):** Hệ thống cập nhật ProviderId (nếu chưa có), thiết lập HttpSession (userId, role) và redirect về Dashboard/Home.
    *   **Case B (Chưa có tài khoản):** Hệ thống tạm lưu Email/Name vào Session và redirect về trang `/register?google=new` để User nhập thêm SĐT/Địa chỉ (đảm bảo đủ dữ liệu nghiệp vụ).
*   **Bước 4:** Với Đăng nhập LOCAL, Controller dùng BCrypt so khớp mật khẩu hash trước khi tạo Session.
*   **Bước 5:** `SecurityInterceptor` dùng `preHandle` để quét URI. Nếu vào `/admin` hoặc `/user` mà Session trống -> redirect về trang Login ngay lập tức.
*   **Bước 6:** Logic "Auto-upgrade": Hệ thống tự động nâng cấp GUEST lên USER khi họ hoàn tất Đăng ký hoặc Reset Password, giúp hợp nhất lịch sử quyên góp.

### 2. Luồng Quản lý Chiến dịch (Campaign Management Flow):
*   **Bước 1:** Admin tạo/cập nhật chiến dịch kèm theo mục tiêu tài chính (Target Money) và ngày kết thúc.
*   **Bước 2:** Mỗi khi dữ liệu được truy cập, hàm `checkAndUpdateExpiredCampaigns` sẽ tự động quét các chiến dịch hết hạn.
*   **Bước 3:** Hệ thống thực hiện UPDATE trạng thái từ `IN_PROGRESS` sang `CLOSED` một cách âm thầm nếu `endDate < hiện tại`.
*   **Bước 4:** Khi một khoản quyên góp được xác nhận, code tự động tính toán tỷ lệ hoàn thành. Nếu đạt mục tiêu, status sẽ tự động chuyển sang `COMPLETED`.
*   **Bước 5:** Hệ thống hỗ trợ render thông minh nội dung mô tả chiến dịch, tự động biến link ảnh thành thẻ `<img>` trực quan.

### 3. Luồng Quyên góp và Xác nhận (Donation & Confirmation Flow):
*   **Bước 1:** User/Guest thực hiện quyên góp (Amount >= 1,000 VND). Bản ghi được tạo với trạng thái `PENDING`.
*   **Bước 2:** Admin kiểm tra bank/sao kê và bấm "Xác nhận" trên Dashboard.
*   **Bước 3:** `DonationService` thực thi hàm `confirmDonation()` trong một `@Transactional` duy nhất.
*   **Bước 4:** Cập nhật trạng thái Donation sang `CONFIRMED` và đồng thời gọi `CampaignService` để cộng tiền bằng `BigDecimal` (tránh sai số).
*   **Bước 5:** `EmailService` tự động gửi Email thông báo xác nhận và lời cảm ơn đến nhà hảo tâm ngay khi transaction hoàn tất.

### 4. Luồng Quản lý Người dùng (User Management Flow):
*   **Bước 1:** Admin quản lý danh sách thành viên với bộ lọc đa năng: Role, Status, Keyword.
*   **Bước 2:** Chức năng "Lock/Unlock" cho phép Admin tạm ngưng quyền truy cập của tài khoản vi phạm.
*   **Bước 3:** Code trong `AdminController` có cơ chế "Self-action protection": Chặn không cho phép Admin tự khóa hoặc tự xóa chính mình.
*   **Bước 4:** Hệ thống hỗ trợ lọc người dùng không hoạt động (Inactive) theo từng mốc thời gian (1 tuần, 1 tháng...) để Admin dễ dàng quản lý.

### 5. Luồng Theo dõi Chiến dịch và Hồ sơ cá nhân (Tracking & Profile Flow):
*   **Bước 1:** User bấm "Theo dõi" chiến dịch -> Lưu vào bảng `User_Following` để nhận cập nhật.
*   **Bước 2:** Khi vào trang Profile, `UserServiceImpl` thực hiện aggregation: Tính tổng tiền quyên góp, đếm số chiến dịch và số lượng theo dõi realtime.
*   **Bước 3:** User có thể tự quản lý avatar (upload an toàn với UUID) và thay đổi thông tin cá nhân.
*   **Bước 4:** Trang Profile hiển thị lịch sử quyên góp chi tiết, giúp người dùng tự minh bạch hóa mỗi giao dịch thiện nguyện của mình.

---

## PHẦN 9: PHÂN QUYỀN VÀ BẢO MẬT (THỰC THI TRONG CODE)

Hệ thống bảo mật của em không chỉ là lý thuyết mà được thực thi nghiêm ngặt qua 3 lớp:

1.  **Mã hóa dữ liệu nhạy cảm:** Em sử dụng `BCryptPasswordEncoder`. Thay vì lưu "123456", database sẽ lưu một chuỗi ký tự ngẫu nhiên dài 60 ký tự. Điểm hay của BCrypt là nó tự động tạo Salt (mã muối) ngẫu nhiên cho mỗi lần băm. Nghĩa là nếu hai người dùng có cùng mật khẩu là "123456", thì chuỗi hash lưu trong DB của họ vẫn hoàn toàn khác nhau. Điều này triệt tiêu khả năng bị tấn công bằng bảng tra cứu (Rainbow Table).
2.  **Phân quyền bằng Interceptor (Authorization Layer):** Em thiết kế lớp `SecurityInterceptor` kế thừa `HandlerInterceptor`.
    *   **Cách code hoạt động:** Trong phương thức `preHandle`, em lấy đường dẫn URI mà người dùng đang truy cập.
    *   Nếu URI bắt đầu bằng `/admin`, em check Session: Nếu không có Object User hoặc User đó có Role không phải ADMIN, em sẽ dừng luồng request ngay lập tức và redirect về trang login kèm message "Access Denied".
    *   Nếu URI là `/user/profile`, em chỉ cần check xem Session có `userId` hay không.
    *   => Cách này giúp em tập trung logic bảo mật vào một file duy nhất, không cần phải viết if-else kiểm tra quyền ở từng file Controller.
3.  **Tích hợp Google OAuth2:** Đây là điểm nhấn công nghệ của dự án. Em cấu hình OAuth2 Client để lấy thông tin từ Google API.
    *   **Logic xử lý:** Khi người dùng đăng nhập bằng Google thành công, em lấy Email từ Google trả về. Nếu email này đã có trong DB, em cho họ vào luôn. Nếu chưa có, em tự động tạo một tài khoản mới với `auth_provider` là 'GOOGLE'. Điều này vừa tăng trải nghiệm người dùng, vừa tận dụng được lớp bảo mật 2 lớp (2FA) sẵn có của Google.

---

## PHẦN 10: DEMO GIAO DIỆN (5 phút)

Em xin phép trình bày các màn hình tiêu biểu:
*   **Trang chủ:** Thiết kế dạng thẻ (Card) trực quan, có thanh tiến độ (%) giúp người xem biết ngay chiến dịch nào cần giúp đỡ gấp.
*   **Trang chi tiết Campaign:** Render link ảnh thông minh, danh sách nhà hảo tâm được cập nhật realtime.
*   **Dashboard Admin:** Cung cấp các con số thống kê nhanh về tổng tiền và số lượng người dùng.

---

## PHẦN 11: LUỒNG DEMO THỰC TẾ (10 phút)

Sau đây em xin demo một luồng nghiệp vụ hoàn chỉnh:
1.  Đầu tiên, một người dùng mới sẽ thực hiện quyên góp 100,000 VND cho chiến dịch "Áo ấm vùng cao".
2.  Hệ thống ghi nhận và báo trạng thái "Chờ xác nhận".
3.  Em sẽ đăng nhập vào tài khoản Admin, vào danh sách quyên góp để thấy giao dịch vừa rồi.
4.  Sau khi kiểm tra sao kê bank, Admin bấm "Xác nhận".
5.  Ngay lập tức, chúng ta sẽ quay lại trang chủ và thấy số tiền của chiến dịch "Áo ấm vùng cao" đã được cộng thêm 100,000 VND và thanh tiến độ đã tăng lên.

---

## PHẦN 12: KIỂM THỬ (5 phút)

Em đã thực hiện đầy đủ các loại hình kiểm thử:
*   **Validation Test:** Kiểm tra các trường hợp nhập liệu sai như email sai định dạng, mật khẩu quá ngắn.
*   **Service Test (Unit Test):** Dùng Mockito để test logic tính toán tiền tệ mà không cần DB.
*   **Integration Test:** Dùng MockMvc để test luồng từ Controller xuống đến Database.
Một số ca tiêu biểu như: Chặn user thường vào vùng Admin, tự động đóng chiến dịch khi hết hạn ngày kết thúc đều đã Passed.

---

## PHẦN 13: KẾT QUẢ ĐẠT ĐƯỢC (3 phút)

Dự án đã hoàn thành đúng hạn với các kết quả:
*   Hoàn thiện 100% các chức năng cốt lõi (Core functions).
*   Hệ thống phân quyền và bảo mật hoạt động ổn định.
*   Có Dashboard thống kê cho Admin.
*   Bộ tài liệu SRS và HLD đầy đủ, khớp với code thực tế.

---

## PHẦN 14: HẠN CHẾ VÀ HƯỚNG PHÁT TRIỂN (3 phút)

Dự án vẫn còn một số hạn chế em cần khắc phục:
*   Chưa tích hợp cổng thanh toán trực tuyến (VNPay/Momo) mà vẫn đang xác nhận thủ công.
*   Ảnh vẫn đang lưu trên server cục bộ, chưa dùng Cloud Storage như S3 hay Cloudinary.
*   Giao diện có thể tối ưu tốt hơn nữa cho các dòng điện thoại màn hình nhỏ.

**Hướng phát triển tiêu biểu:**
*   Xây dựng API để phát triển ứng dụng di động.
*   Tích hợp thông báo Realtime khi có người quyên góp.

---

## PHẦN 15: KẾT LUẬN (2 phút)

Tổng kết lại, thông qua dự án này, em không chỉ học được cách lập trình Java Spring Boot mà còn rèn luyện được quy trình phân tích yêu cầu, thiết kế database và đặc biệt là tư duy giải quyết các vấn đề logic nghiệp vụ phức tạp. Em xin cảm ơn Mentor và Hội đồng đã lắng nghe. Em rất mong nhận được ý kiến đóng góp từ các thầy cô.
