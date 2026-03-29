<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản - CharityDonation</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .strength-meter { height: 6px; border-radius: 3px; transition: all 0.3s; margin-top: 8px; }
        .strength-0 { width: 0%; }
        .strength-1 { width: 25%; background-color: #ef4444; }
        .strength-2 { width: 50%; background-color: #f59e0b; }
        .strength-3 { width: 75%; background-color: #10b981; }
        .strength-4 { width: 100%; background-color: #059669; }
    </style>
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0 vh-100">
            <!-- Left Column: Inspiring Image (Hidden on mobile) -->
            <div class="col-md-5 d-none d-md-flex auth-split-left" style="background-image: url('https://images.unsplash.com/photo-1593113598332-cd288d649433?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80');">
                <div class="auth-quote">
                    <i class="fas fa-heart mb-4 d-block fs-1 opacity-50"></i>
                    "Hạnh phúc là khi được sẻ chia những gì mình đang có cho những mảnh đời kém may mắn hơn."
                </div>
            </div>

            <!-- Right Column: Register Form -->
            <div class="col-md-7 d-flex align-items-center justify-content-center bg-white p-5 overflow-auto position-relative">
                <a href="${pageContext.request.contextPath}/" class="btn btn-light rounded-circle position-absolute top-0 end-0 m-4 shadow-sm" title="Quay lại trang chủ">
                    <i class="fas fa-times"></i>
                </a>

                <div class="w-100" style="max-width: 500px;">
                    <div class="text-center mb-4">
                        <div class="mb-2">
                            <a href="${pageContext.request.contextPath}/"><i class="fas fa-user-plus fa-2x text-primary"></i></a>
                        </div>
                        <h2 class="fw-bold">Tạo tài khoản mới</h2>
                        <p class="text-muted small">Hãy trở thành một phần của cộng đồng thiện nguyện</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger border-0 shadow-sm mb-4 small">${error}</div>
                    </c:if>

                    <c:if test="${googleMode}">
                        <div class="alert alert-info border-0 shadow-sm mb-4 small">
                            <i class="fab fa-google me-2"></i> Đã kết nối với Google! Vui lòng hoàn tất thông tin còn thiếu.
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/register" method="post" class="needs-validation" novalidate>
                        <input type="hidden" name="authProvider" value="${user.authProvider}">
                        <input type="hidden" name="providerId" value="${user.providerId}">
                        <input type="hidden" name="avatarUrl" value="${user.avatarUrl}">

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" name="fullName" class="form-control" id="fullName" placeholder="Nguyễn Văn A" required value="${user.fullName}" ${googleMode ? 'readonly' : ''}>
                                    <label for="fullName">Họ và tên</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="tel" name="phoneNumber" class="form-control" id="phone" placeholder="09xxx" required pattern="^(0|84)(3|5|7|8|9)[0-9]{8}$" value="${user.phoneNumber}">
                                    <label for="phone">Số điện thoại</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-floating mb-3">
                            <input type="email" name="email" class="form-control" id="email" placeholder="name@example.com" required value="${user.email}" ${googleMode ? 'readonly' : ''}>
                            <label for="email">Địa chỉ Email</label>
                        </div>

                        <c:if test="${!googleMode}">
                            <div class="form-floating mb-3">
                                <input type="password" name="password" class="form-control" id="passwordInput" placeholder="Password" required minlength="6">
                                <label for="passwordInput">Mật khẩu</label>
                                <div class="progress strength-meter bg-light">
                                    <div id="strengthBar" class="progress-bar strength-0"></div>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                    <small class="text-muted small">Độ mạnh: <span id="strengthText">Rất yếu</span></small>
                                    <small class="text-muted small">Tối thiểu 6 ký tự</small>
                                </div>
                            </div>

                            <div class="form-floating mb-4">
                                <input type="password" class="form-control" id="rePassword" placeholder="Confirm Password" required>
                                <label for="rePassword">Nhập lại mật khẩu</label>
                            </div>
                        </c:if>

                        <button type="submit" class="btn btn-primary w-100 py-3 mb-4 shadow-sm">
                            ${googleMode ? 'HOÀN TẤT ĐĂNG KÝ' : 'ĐĂNG KÝ NGAY'}
                        </button>

                        <c:if test="${!googleMode}">
                            <div class="d-flex align-items-center mb-4 text-muted">
                                <hr class="flex-grow-1">
                                <span class="px-3 small">Hoặc đăng ký bằng</span>
                                <hr class="flex-grow-1">
                            </div>

                            <div class="row g-2 mb-4">
                                <div class="col-12">
                                    <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="btn btn-outline-danger w-100 py-2">
                                        <i class="fab fa-google me-2"></i>Google
                                    </a>
                                </div>
                            </div>
                        </c:if>

                        <p class="text-center text-muted mb-0">
                            Bạn đã có tài khoản? 
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-primary fw-bold text-decoration-none">Đăng nhập</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/4.4.2/zxcvbn.js"></script>
    <script>
        const passwordInput = document.getElementById('passwordInput');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const texts = ['Rất yếu', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];

        passwordInput.addEventListener('input', function() {
            const val = passwordInput.value;
            const result = zxcvbn(val);
            const score = val.length > 0 ? result.score + 1 : 0;

            strengthBar.className = 'progress-bar strength-' + score;
            strengthText.innerText = val.length > 0 ? texts[result.score] : 'Rất yếu';
            
            if(score < 3) strengthText.className = 'text-danger';
            else if(score === 3) strengthText.className = 'text-warning';
            else strengthText.className = 'text-success';
        });

        // Form Validation
        (() => {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    const pass = document.getElementById('passwordInput').value;
                    const rePass = document.getElementById('rePassword').value;
                    if (pass !== rePass) {
                        alert('Mật khẩu nhập lại không khớp!');
                        event.preventDefault();
                        return;
                    }
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>

