<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="py-5 px-4 border-top mt-5 custom-footer">
    <div class="container-fluid">
        <div class="row g-4 mb-5 text-start">
            <div class="col-md-4">
                <div class="d-flex align-items-center mb-4">
                    <i class="fas fa-hand-holding-heart fa-2x brand-primary me-2"></i>
                    <h4 class="fw-bold mb-0">Charity</h4>
                </div>
                <p class="text-secondary small">Nền tảng quyên góp cộng đồng lớn nhất Việt Nam, nơi kết nối triệu trái tim chung tay vì những giá trị tốt đẹp.</p>
                <div class="d-flex gap-3 mt-4">
                    <a href="#" class="text-secondary fs-5"><i class="fab fa-facebook"></i></a>
                    <a href="https://www.youtube.com/@Scovy303/" class="text-secondary fs-5"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="text-secondary fs-5"><i class="fab fa-tiktok"></i></a>
                </div>
            </div>
            <div class="col-6 col-md-2">
                <h6 class="fw-bold mb-4">Hoàn cảnh</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/#campaigns" class="text-secondary text-decoration-none">Trẻ em</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/#campaigns" class="text-secondary text-decoration-none">Người già</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/#campaigns" class="text-secondary text-decoration-none">Bệnh hiểm nghèo</a></li>
                </ul>
            </div>
            <div class="col-6 col-md-2">
                <h6 class="fw-bold mb-4">Dịch vụ</h6>
                <ul class="list-unstyled small">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/#campaigns" class="text-secondary text-decoration-none">Quyên góp tiền</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/#intro" class="text-secondary text-decoration-none">Ví Nhân Ái</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/#partners" class="text-secondary text-decoration-none">Đối tác</a></li>
                </ul>
            </div>
            <div class="col-md-4">
                <h6 class="fw-bold mb-4">Tải ứng dụng Charity</h6>
                <div class="d-flex gap-2">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/7/78/Google_Play_Store_badge_EN.svg" height="40" alt="Google Play">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" height="40" alt="App Store">
                </div>
            </div>
        </div>
        <hr class="opacity-10 mb-4">
        <div class="row align-items-center g-3">
            <div class="col-md-6 text-center text-md-start">
                <p class="small text-secondary mb-0">© 2026 Charity Donation Platform. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="small text-secondary text-decoration-none me-3">Chính sách bảo mật</a>
                <a href="#" class="small text-secondary text-decoration-none">Điều khoản sử dụng</a>
            </div>
        </div>
    </div>
</footer>

<style>
    .brand-primary { color: var(--color-primary) !important; }
</style>
