<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khôi phục mật khẩu - CharityDonation</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .brand-primary { color: var(--color-primary) !important; }
        .vh-100-center { min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .step-indicator { font-size: 0.8rem; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 1px; }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center align-items-center vh-100">
            <div class="col-md-5">
                <div class="card border-0 shadow-lg p-4">
                    <div class="card-body">
                        <c:choose>
                            <%-- STEP 1: ENTER EMAIL --%>
                            <c:when test="${empty sessionScope.resetEmail}">
                                <div class="text-center mb-4">
                                    <div class="mb-3">
                                        <i class="fas fa-key fa-3x brand-primary opacity-50"></i>
                                    </div>
                                    <h2 class="fw-bold">Quên mật khẩu?</h2>
                                    <p class="text-muted">Nhập email của bạn để nhận mã xác thực (OTP).</p>
                                </div>

                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger py-2 small mb-4">${error}</div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
                                    <div class="form-floating mb-4">
                                        <input type="email" name="email" class="form-control" id="email" placeholder="name@example.com" required>
                                        <label for="email">Địa chỉ Email</label>
                                    </div>
                                    <button type="submit" class="btn btn-brand-primary w-100 py-3 shadow-sm fw-bold">GỬI MÃ XÁC THỰC</button>
                                </form>
                            </c:when>

                            <%-- STEP 2: VERIFY OTP --%>
                            <c:when test="${not empty sessionScope.resetEmail and empty sessionScope.otpVerified}">
                                <div class="text-center mb-4">
                                    <div class="step-indicator mb-2">BƯỚC 2: XÁC THỰC</div>
                                    <div class="mb-3">
                                        <i class="fas ${sessionScope.isSMS ? 'fa-sms' : 'fa-envelope-open-text'} fa-3x brand-primary opacity-50"></i>
                                    </div>
                                    <h2 class="fw-bold">Nhập mã OTP</h2>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${sessionScope.isSMS}">
                                                Mã OTP đã được gửi đến SĐT: <strong>${sessionScope.maskedPhone}</strong>
                                            </c:when>
                                            <c:otherwise>
                                                Mã OTP đã được gửi đến Email: <strong>${sessionScope.resetEmail}</strong>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>

                                <c:if test="${not empty message}">
                                    <div class="alert alert-success py-2 small mb-4">${message}</div>
                                </c:if>
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger py-2 small mb-4">${error}</div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/auth/verify-otp" method="post">
                                    <div class="form-floating mb-4">
                                        <input type="text" name="otp" class="form-control text-center fs-4 fw-bold" id="otp" placeholder="000000" maxlength="6" required pattern="[0-9]{6}">
                                        <label for="otp">Mã OTP (6 chữ số)</label>
                                    </div>
                                    <button type="submit" class="btn btn-brand-primary w-100 py-3 shadow-sm fw-bold">XÁC THỰC</button>
                                </form>
                                <div class="text-center mt-3">
                                    <a href="${pageContext.request.contextPath}/auth/forgot-password?restart=true" class="text-decoration-none small text-muted">Gửi lại mã khác?</a>
                                </div>
                            </c:when>

                            <%-- STEP 3: RESET PASSWORD --%>
                            <c:when test="${sessionScope.otpVerified}">
                                <div class="text-center mb-4">
                                    <div class="step-indicator mb-2">BƯỚC 3: HOÀN TẤT</div>
                                    <div class="mb-3">
                                        <i class="fas fa-lock-open fa-3x brand-primary opacity-50"></i>
                                    </div>
                                    <h2 class="fw-bold">Mật khẩu mới</h2>
                                    <p class="text-muted">Vui lòng thiết lập mật khẩu mới cho tài khoản của bạn.</p>
                                </div>

                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger py-2 small mb-4">${error}</div>
                                </c:if>

                                <form action="${pageContext.request.contextPath}/auth/reset-password" method="post" id="resetForm">
                                    <div class="form-floating mb-3">
                                        <input type="password" name="password" class="form-control" id="newPassword" placeholder="Password" required minlength="6">
                                        <label for="newPassword">Mật khẩu mới</label>
                                    </div>
                                    <div class="form-floating mb-4">
                                        <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" placeholder="Confirm" required>
                                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                                    </div>
                                    <button type="submit" class="btn btn-brand-primary w-100 py-3 shadow-sm fw-bold">CẬP NHẬT MẬT KHẨU</button>
                                </form>
                            </c:when>
                        </c:choose>

                        <div class="text-center mt-4 border-top pt-3">
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none text-muted small">
                                <i class="fas fa-arrow-left me-1"></i> Quay lại đăng nhập
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('resetForm')?.addEventListener('submit', function(e) {
            const pw = document.getElementById('newPassword').value;
            const cf = document.getElementById('confirmPassword').value;
            if (pw !== cf) {
                alert('Mật khẩu xác nhận không khớp!');
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
