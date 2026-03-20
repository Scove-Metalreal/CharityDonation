<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .admin-sidebar { width: 260px; height: 100vh; position: fixed; left: 0; top: 0; background: #fff; border-right: 1px solid var(--color-border); z-index: 1000; }
        .admin-content { margin-left: 260px; padding: 20px; min-height: 100vh; background: var(--color-bg-light); }
        .admin-navbar { margin-left: 260px; background: #fff; border-bottom: 1px solid var(--color-border); padding: 15px 30px; }
        .nav-link-admin { padding: 12px 20px; border-radius: 8px; color: var(--color-text-main); margin: 5px 15px; display: flex; align-items: center; text-decoration: none; transition: var(--transition); }
        .nav-link-admin:hover, .nav-link-admin.active { background: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
        .nav-link-admin i { width: 25px; margin-right: 10px; }
        .stat-card { border-left: 4px solid var(--color-primary); }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="admin-sidebar shadow-sm d-none d-md-block">
        <div class="p-4 text-center border-bottom mb-3">
            <h4 class="text-primary fw-bold mb-0"><i class="fas fa-hand-holding-heart me-2"></i>Charity</h4>
            <small class="text-muted">QUẢN TRỊ HỆ THỐNG</small>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-admin active">
            <i class="fas fa-chart-line"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-admin">
            <i class="fas fa-users"></i> Quản lý Người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/campaigns" class="nav-link-admin">
            <i class="fas fa-bullhorn"></i> Quản lý Chiến dịch
        </a>
        <a href="${pageContext.request.contextPath}/admin/donations" class="nav-link-admin">
            <i class="fas fa-check-circle"></i> Xác nhận quyên góp
        </a>
        <hr class="mx-3 opacity-10">
        <a href="${pageContext.request.contextPath}/" class="nav-link-admin">
            <i class="fas fa-external-link-alt"></i> Xem Trang chủ
        </a>
        
        <div class="position-absolute bottom-0 w-100 p-3">
            <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link-admin text-danger">
                <i class="fas fa-sign-out-alt"></i> Đăng xuất
            </a>
        </div>
    </div>

    <!-- Top Navbar -->
    <nav class="admin-navbar d-flex justify-content-between align-items-center shadow-sm sticky-top">
        <div class="d-flex align-items-center">
            <h5 class="mb-0 fw-bold text-dark">Dashboard</h5>
        </div>
        <div class="d-flex align-items-center">
            <div class="me-4 position-relative">
                <i class="far fa-bell fs-5 text-muted"></i>
                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.6rem;">3</span>
            </div>
            <div class="d-flex align-items-center">
                <div class="text-end me-3 d-none d-lg-block">
                    <p class="mb-0 fw-bold small text-dark">${sessionScope.loggedInUser.fullName}</p>
                    <small class="text-muted small">Quản trị viên</small>
                </div>
                <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle shadow-sm" width="40" height="40">
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="admin-content">
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card p-4 shadow-sm border-0 h-100">
                    <small class="text-muted fw-bold">TỔNG NGƯỜI DÙNG</small>
                    <h2 class="mt-2 mb-0 fw-bold text-dark">1,284</h2>
                    <small class="text-success"><i class="fas fa-arrow-up"></i> 12% so với tháng trước</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-4 shadow-sm border-0 h-100" style="border-left-color: var(--color-accent);">
                    <small class="text-muted fw-bold">CHIẾN DỊCH ĐANG CHẠY</small>
                    <h2 class="mt-2 mb-0 fw-bold text-dark">24</h2>
                    <small class="text-muted">4 chiến dịch mới tuần này</small>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-4 shadow-sm border-0 h-100" style="border-left-color: #3b82f6;">
                    <small class="text-muted fw-bold">TỔNG QUYÊN GÓP</small>
                    <h2 class="mt-2 mb-0 fw-bold text-dark">850M đ</h2>
                    <small class="text-success"><i class="fas fa-arrow-up"></i> 5% hôm nay</small>
                </div> 
            </div>
            <div class="col-md-3">
                <div class="card stat-card p-4 shadow-sm border-0 h-100" style="border-left-color: #ef4444;">
                    <small class="text-muted fw-bold">YÊU CẦU CHỜ DUYỆT</small>
                    <h2 class="mt-2 mb-0 fw-bold text-dark">12</h2>
                    <small class="text-danger">Cần xử lý ngay</small>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-lg-8">
                <div class="card p-4 shadow-sm border-0">
                    <h5 class="fw-bold mb-4">Hoạt động quyên góp gần đây</h5>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="bg-light">
                                <tr>
                                    <th class="border-0">Người đóng góp</th>
                                    <th class="border-0">Chiến dịch</th>
                                    <th class="border-0 text-end">Số tiền</th>
                                    <th class="border-0 text-center">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div class="fw-bold small">Nguyễn Văn An</div>
                                        <small class="text-muted">an.nguyen@gmail.com</small>
                                    </td>
                                    <td class="small">Áo ấm vùng cao Sơn La</td>
                                    <td class="text-end fw-bold text-primary">500,000đ</td>
                                    <td class="text-center"><span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Thành công</span></td>
                                </tr>
                                <tr>
                                    <td>
                                        <div class="fw-bold small">Trần Thị Bình</div>
                                        <small class="text-muted">binh.tran@gmail.com</small>
                                    </td>
                                    <td class="small">Mổ tim cho bé An</td>
                                    <td class="text-end fw-bold text-primary">1,000,000đ</td>
                                    <td class="text-center"><span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Chờ duyệt</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card p-4 shadow-sm border-0">
                    <h5 class="fw-bold mb-4">Chiến dịch nổi bật</h5>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <small class="fw-bold">Xây cầu Trà Vinh</small>
                            <small class="text-muted">85%</small>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-primary" style="width: 85%"></div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between mb-1">
                            <small class="fw-bold">Nước sạch miền Tây</small>
                            <small class="text-muted">40%</small>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class="progress-bar bg-primary" style="width: 40%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
