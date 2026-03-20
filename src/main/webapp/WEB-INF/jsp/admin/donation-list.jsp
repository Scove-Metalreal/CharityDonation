<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Quyên góp - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .admin-sidebar { width: 260px; height: 100vh; position: fixed; left: 0; top: 0; background: #fff; border-right: 1px solid var(--color-border); z-index: 1000; }
        .admin-content { margin-left: 260px; padding: 20px; min-height: 100vh; background: var(--color-bg-light); }
        .admin-navbar { margin-left: 260px; background: #fff; border-bottom: 1px solid var(--color-border); padding: 15px 30px; }
        .nav-link-admin { padding: 12px 20px; border-radius: 8px; color: var(--color-text-main); margin: 5px 15px; display: flex; align-items: center; text-decoration: none; transition: var(--transition); }
        .nav-link-admin:hover, .nav-link-admin.active { background: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="admin-sidebar shadow-sm d-none d-md-block">
        <div class="p-4 text-center border-bottom mb-3">
            <h4 class="text-primary fw-bold mb-0"><i class="fas fa-hand-holding-heart me-2"></i>Charity</h4>
            <small class="text-muted">QUẢN TRỊ HỆ THỐNG</small>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-admin">
            <i class="fas fa-chart-line"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-admin">
            <i class="fas fa-users"></i> Quản lý Người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/campaigns" class="nav-link-admin">
            <i class="fas fa-bullhorn"></i> Quản lý Chiến dịch
        </a>
        <a href="${pageContext.request.contextPath}/admin/donations" class="nav-link-admin active">
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
        <h5 class="mb-0 fw-bold text-dark">Xác nhận Quyên góp</h5>
        <div class="d-flex align-items-center">
            <img src="https://ui-avatars.com/api/?name=Admin&background=10B981&color=fff" class="rounded-circle shadow-sm" width="35" height="35">
        </div>
    </nav>

    <!-- Main Content -->
    <div class="admin-content">
        <div class="card border-0 shadow-sm p-4">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="bg-light">
                        <tr class="small text-muted">
                            <th class="border-0">NHÀ HẢO TÂM</th>
                            <th class="border-0">CHIẾN DỊCH</th>
                            <th class="border-0">SỐ TIỀN</th>
                            <th class="border-0">NGÀY GỬI</th>
                            <th class="border-0 text-center">TRẠNG THÁI</th>
                            <th class="border-0 text-end">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="d" items="${donations}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${d.user.fullName}</div>
                                    <c:if test="${d.isAnonymous == 1}"><small class="text-warning">(Ẩn danh)</small></c:if>
                                </td>
                                <td>
                                    <div class="small text-dark text-truncate" style="max-width: 200px;">${d.campaign.name}</div>
                                </td>
                                <td>
                                    <div class="fw-bold text-primary"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                </td>
                                <td><small class="text-muted">${d.createdAt}</small></td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${d.status == 0}"><span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Chờ xác nhận</span></c:when>
                                        <c:when test="${d.status == 1}"><span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Đã xác nhận</span></c:when>
                                        <c:when test="${d.status == 2}"><span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Đã từ chối</span></c:when>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <c:if test="${d.status == 0}">
                                        <div class="d-flex justify-content-end gap-1">
                                            <form action="${pageContext.request.contextPath}/admin/donations/confirm" method="post" onsubmit="return confirm('Xác nhận số tiền này đã vào tài khoản?')">
                                                <input type="hidden" name="donationId" value="${d.id}">
                                                <button type="submit" class="action-btn bg-success bg-opacity-10 text-success" title="Xác nhận"><i class="fas fa-check"></i></button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/donations/reject" method="post" onsubmit="return confirm('Từ chối giao dịch này?')">
                                                <input type="hidden" name="donationId" value="${d.id}">
                                                <button type="submit" class="action-btn bg-danger bg-opacity-10 text-danger" title="Từ chối"><i class="fas fa-times"></i></button>
                                            </form>
                                        </div>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
