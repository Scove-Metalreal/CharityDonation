<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - CharityDonation</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="container-fluid p-0">
        <div class="row g-0 vh-100">
            <!-- Left Column: Inspiring Image (Hidden on mobile) -->
            <div class="col-md-6 d-none d-md-flex auth-split-left">
                <div class="auth-quote">
                    <i class="fas fa-quote-left mb-4 d-block fs-1 opacity-50"></i>
                    "Chúng ta không thể giúp đỡ tất cả mọi người, nhưng mọi người đều có thể giúp đỡ một ai đó."
                    <footer class="blockquote-footer mt-3 text-white opacity-75">Ronald Reagan</footer>
                </div>
            </div>

            <!-- Right Column: Login Form -->
            <div class="col-md-6 d-flex align-items-center justify-content-center bg-white p-5 position-relative">
                <a href="${pageContext.request.contextPath}/" class="btn btn-light rounded-circle position-absolute top-0 end-0 m-4 shadow-sm" title="Quay lại trang chủ">
                    <i class="fas fa-times"></i>
                </a>

                <div class="w-100" style="max-width: 400px;">
                    <div class="text-center mb-5">
                        <div class="mb-3">
                            <a href="${pageContext.request.contextPath}/"><i class="fas fa-hand-holding-heart fa-3x text-primary"></i></a>
                        </div>
                        <h2 class="fw-bold">Chào mừng trở lại</h2>
                        <p class="text-muted">Đăng nhập để tiếp tục hành trình nhân ái</p>
                    </div>

                    <c:if test="${param.success eq 'register'}">
                        <div class="alert alert-success border-0 shadow-sm mb-4">Đăng ký thành công! Mời bạn đăng nhập.</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger border-0 shadow-sm mb-4">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/login" method="post">
                        <div class="form-floating mb-3">
                            <input type="email" name="email" class="form-control" id="email" placeholder="name@example.com" required value="${param.email}">
                            <label for="email">Địa chỉ Email</label>
                        </div>
                        <div class="form-floating mb-4 position-relative">
                            <input type="password" name="password" class="form-control" id="password" placeholder="Password" required>
                            <label for="password">Mật khẩu</label>
                            <div class="text-end mt-1">
                                <a href="${pageContext.request.contextPath}/auth/forgot-password" class="small text-muted text-decoration-none">Quên mật khẩu?</a>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-3 mb-4 shadow-sm">ĐĂNG NHẬP</button>

                        <div class="d-flex align-items-center mb-4 text-muted">
                            <hr class="flex-grow-1">
                            <span class="px-3 small">Hoặc tiếp tục với</span>
                            <hr class="flex-grow-1">
                        </div>

                        <div class="row g-2 mb-4">
                            <div class="col-12">
                                <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="btn btn-outline-danger w-100 py-2">
                                    <i class="fab fa-google me-2"></i>Tiếp tục với Google
                                </a>
                            </div>
                        </div>

                        <p class="text-center text-muted mb-0">
                            Bạn chưa có tài khoản? 
                            <a href="${pageContext.request.contextPath}/auth/register" class="text-primary fw-bold text-decoration-none">Đăng ký ngay</a>
                        </p>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
