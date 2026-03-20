<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - CharityDonation</title>
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
            <div class="col-md-6 d-flex align-items-center justify-content-center bg-white p-5">
                <div class="w-100" style="max-width: 400px;">
                    <div class="text-center mb-5">
                        <div class="mb-3">
                            <i class="fas fa-hand-holding-heart fa-3x text-primary"></i>
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
                        <div class="form-floating mb-4">
                            <input type="password" name="password" class="form-control" id="password" placeholder="Password" required>
                            <label for="password">Mật khẩu</label>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-3 mb-4 shadow-sm">ĐĂNG NHẬP</button>

                        <div class="d-flex align-items-center mb-4 text-muted">
                            <hr class="flex-grow-1">
                            <span class="px-3 small">Hoặc tiếp tục với</span>
                            <hr class="flex-grow-1">
                        </div>

                        <div class="row g-2 mb-4">
                            <div class="col-6">
                                <button type="button" class="btn btn-outline-secondary w-100">
                                    <i class="fab fa-google me-2"></i>Google
                                </button>
                            </div>
                            <div class="col-6">
                                <button type="button" class="btn btn-outline-secondary w-100">
                                    <i class="fab fa-facebook me-2"></i>Facebook
                                </button>
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
