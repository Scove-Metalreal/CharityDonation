<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Admin</title>
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
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: var(--transition); }
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
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-admin active">
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
        <h5 class="mb-0 fw-bold text-dark">Quản lý Người dùng</h5>
        <div class="d-flex align-items-center">
            <form action="${pageContext.request.contextPath}/admin/users" method="get" class="me-3 d-none d-lg-block">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                    <input type="text" name="keyword" class="form-control border-start-0 ps-0" placeholder="Tìm người dùng..." value="${keyword}">
                </div>
            </form>
            <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle shadow-sm" width="35" height="35">
        </div>
    </nav>

    <!-- Main Content -->
    <div class="admin-content">
        <div class="card border-0 shadow-sm p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h6 class="fw-bold mb-0 text-muted uppercase">DANH SÁCH THÀNH VIÊN</h6>
                <button class="btn btn-primary btn-sm px-3"><i class="fas fa-user-plus me-2"></i>Thêm người dùng</button>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="bg-light">
                        <tr class="small text-muted">
                            <th class="border-0">NGƯỜI DÙNG</th>
                            <th class="border-0">THÔNG TIN LIÊN HỆ</th>
                            <th class="border-0">VAI TRÒ</th>
                            <th class="border-0 text-center">TRẠNG THÁI</th>
                            <th class="border-0 text-end">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="https://ui-avatars.com/api/?name=${u.fullName}&background=random" class="rounded-circle me-3" width="35" height="35">
                                        <div>
                                            <div class="fw-bold text-dark">${u.fullName}</div>
                                            <small class="text-muted">ID: #${u.id}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="small"><i class="far fa-envelope me-1 text-muted"></i> ${u.email}</div>
                                    <div class="small"><i class="fas fa-phone-alt me-1 text-muted"></i> ${u.phoneNumber}</div>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border rounded-pill px-3 fw-normal">${u.role.roleName}</span>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${u.status == 1}">
                                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Đã khóa</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-1">
                                        <a href="#" class="action-btn bg-info bg-opacity-10 text-info" title="Xem chi tiết"><i class="far fa-eye"></i></a>
                                        <form action="${pageContext.request.contextPath}/admin/users/toggle-status" method="post" class="d-inline">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="action-btn ${u.status == 1 ? 'bg-danger bg-opacity-10 text-danger' : 'bg-success bg-opacity-10 text-success'}" title="${u.status == 1 ? 'Khóa tài khoản' : 'Mở khóa tài khoản'}">
                                                <i class="fas ${u.status == 1 ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 0}">
            <nav class="d-flex justify-content-end mt-4">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link border-0 rounded-circle mx-1" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}&keyword=${keyword}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                    
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link border-0 rounded-circle mx-1 ${currentPage == i ? 'bg-primary text-white' : ''}" 
                               href="${pageContext.request.contextPath}/admin/users?page=${i}&keyword=${keyword}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link border-0 rounded-circle mx-1" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}&keyword=${keyword}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                </ul>
            </nav>
            </c:if>
        </div>
    </div>
</body>
</html>
