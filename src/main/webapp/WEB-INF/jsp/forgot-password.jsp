<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu - CharityDonation</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .brand-primary { color: var(--color-primary) !important; }
    </style>
</head>
<body class="bg-light">
    <div class="container h-100">
        <div class="row justify-content-center align-items-center vh-100">
            <div class="col-md-5">
                <div class="card border-0 shadow-lg p-4">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <div class="mb-3">
                                <i class="fas fa-key fa-3x brand-primary opacity-50"></i>
                            </div>
                            <h2 class="fw-bold">Quên mật khẩu?</h2>
                            <p class="text-muted">Đừng lo lắng, hãy nhập email của bạn để bắt đầu quá trình khôi phục.</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/auth/forgot-password" method="post">
                            <div class="form-floating mb-4">
                                <input type="email" name="email" class="form-control" id="email" placeholder="name@example.com" required>
                                <label for="email">Địa chỉ Email</label>
                            </div>

                            <button type="submit" class="btn btn-brand-primary w-100 py-3 mb-4 shadow-sm">
                                TIẾP TỤC
                            </button>

                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/auth/login" class="text-decoration-none text-muted small">
                                    <i class="fas fa-arrow-left me-1"></i> Quay lại đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
