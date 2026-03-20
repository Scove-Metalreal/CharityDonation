<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Chiến dịch - Admin</title>
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
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-admin">
            <i class="fas fa-users"></i> Quản lý Người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/campaigns" class="nav-link-admin active">
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
        <h5 class="mb-0 fw-bold text-dark">Quản lý Chiến dịch</h5>
        <div class="d-flex align-items-center">
            <img src="https://ui-avatars.com/api/?name=Admin&background=10B981&color=fff" class="rounded-circle shadow-sm" width="35" height="35">
        </div>
    </nav>

    <!-- Main Content -->
    <div class="admin-content">
        <div class="card border-0 shadow-sm p-4 mb-4">
            <form action="${pageContext.request.contextPath}/admin/campaigns" method="get" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Trạng thái</label>
                    <select name="status" class="form-select form-select-sm">
                        <option value="">Tất cả trạng thái</option>
                        <option value="0" ${status == 0 ? 'selected' : ''}>Mới tạo</option>
                        <option value="1" ${status == 1 ? 'selected' : ''}>Đang diễn ra</option>
                        <option value="2" ${status == 2 ? 'selected' : ''}>Đã kết thúc</option>
                        <option value="3" ${status == 3 ? 'selected' : ''}>Đóng quỹ</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold">Mã chiến dịch</label>
                    <input type="text" name="code" class="form-control form-control-sm" value="${code}" placeholder="VD: COVID2024">
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold">SĐT nhận</label>
                    <input type="text" name="phone" class="form-control form-control-sm" value="${phone}" placeholder="Số điện thoại...">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary btn-sm w-100"><i class="fas fa-search me-2"></i>Tìm kiếm</button>
                </div>
            </form>
        </div>

        <div class="card border-0 shadow-sm p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h6 class="fw-bold mb-0 text-muted uppercase">DANH SÁCH CHIẾN DỊCH</h6>
                <a href="${pageContext.request.contextPath}/admin/campaigns/new" class="btn btn-primary btn-sm px-3"><i class="fas fa-plus me-2"></i>Tạo chiến dịch</a>
            </div>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="bg-light">
                        <tr class="small text-muted">
                            <th class="border-0">MÃ & TÊN</th>
                            <th class="border-0">THỜI GIAN</th>
                            <th class="border-0">TIẾN ĐỘ QUỸ</th>
                            <th class="border-0 text-center">TRẠNG THÁI</th>
                            <th class="border-0 text-end">HÀNH ĐỘNG</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${campaigns}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark">${c.name}</div>
                                    <small class="text-muted">Code: ${c.code}</small>
                                </td>
                                <td>
                                    <div class="small text-dark">${c.startDate}</div>
                                    <div class="small text-muted">${c.endDate}</div>
                                </td>
                                <td>
                                    <div class="d-flex justify-content-between small mb-1">
                                        <span><fmt:formatNumber value="${c.currentMoney}" type="number"/>đ</span>
                                        <span class="text-muted">/ <fmt:formatNumber value="${c.targetMoney}" type="number"/>đ</span>
                                    </div>
                                    <div class="progress" style="height: 5px;">
                                        <c:set var="percent" value="${(c.currentMoney / c.targetMoney) * 100}"/>
                                        <div class="progress-bar" style="width: ${percent}%"></div>
                                    </div>
                                </td>
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${c.status == 0}"><span class="badge bg-info bg-opacity-10 text-info rounded-pill px-3">Mới tạo</span></c:when>
                                        <c:when test="${c.status == 1}"><span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Đang diễn ra</span></c:when>
                                        <c:when test="${c.status == 2}"><span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Đã kết thúc</span></c:when>
                                        <c:when test="${c.status == 3}"><span class="badge bg-secondary bg-opacity-10 text-secondary rounded-pill px-3">Đóng quỹ</span></c:when>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <div class="d-flex justify-content-end gap-1">
                                        <a href="${pageContext.request.contextPath}/campaign/${c.id}" class="action-btn bg-info bg-opacity-10 text-info" title="Xem chi tiết"><i class="far fa-eye"></i></a>
                                        <a href="${pageContext.request.contextPath}/admin/campaigns/edit?id=${c.id}" class="action-btn bg-primary bg-opacity-10 text-primary ${c.status == 3 ? 'disabled' : ''}" title="Sửa"><i class="far fa-edit"></i></a>
                                        <c:if test="${c.status == 0}">
                                            <form action="${pageContext.request.contextPath}/admin/campaigns/delete" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa?')">
                                                <input type="hidden" name="id" value="${c.id}">
                                                <button type="submit" class="action-btn bg-danger bg-opacity-10 text-danger"><i class="far fa-trash-alt"></i></button>
                                            </form>
                                        </c:if>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
            <nav class="d-flex justify-content-end mt-4">
                <ul class="pagination pagination-sm mb-0">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link border-0 rounded-circle mx-1" href="?page=${currentPage - 1}&status=${status}&code=${code}&phone=${phone}"><i class="fas fa-chevron-left"></i></a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link border-0 rounded-circle mx-1 ${currentPage == i ? 'bg-primary text-white' : ''}" href="?page=${i}&status=${status}&code=${code}&phone=${phone}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link border-0 rounded-circle mx-1" href="?page=${currentPage + 1}&status=${status}&code=${code}&phone=${phone}"><i class="fas fa-chevron-right"></i></a>
                    </li>
                </ul>
            </nav>
            </c:if>
        </div>
    </div>
</body>
</html>
