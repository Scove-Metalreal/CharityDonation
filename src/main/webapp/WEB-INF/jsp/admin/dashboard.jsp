<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Dashboard - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .stat-card { border-left: 4px solid var(--color-primary); transition: transform 0.2s; }
        .stat-card:hover { transform: scale(1.02); }
        .notification-dropdown { width: 320px; max-height: 400px; overflow-y: auto; }
        .notification-item { padding: 12px 20px; border-bottom: 1px solid #eee; font-size: 0.85rem; }
        .notification-item:hover { background-color: #f8f9fa; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0">
                <c:set var="activePage" value="admin-dashboard" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <!-- Top Navbar -->
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4">
                    <div class="row g-4 mb-4">
                        <div class="col-md-3">
                            <div class="card stat-card p-4 shadow-sm border-0 h-100">
                                <small class="text-muted fw-bold text-uppercase">Tổng người dùng</small>
                                <h2 class="mt-2 mb-0 fw-bold text-dark">${totalUsers}</h2>
                                <small class="text-muted"><i class="fas fa-users"></i> Thành viên hệ thống</small>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card p-4 shadow-sm border-0 h-100" style="border-left-color: var(--color-accent);">
                                <small class="text-muted fw-bold text-uppercase">Chiến dịch đang chạy</small>
                                <h2 class="mt-2 mb-0 fw-bold text-dark">${activeCampaigns}</h2>
                                <small class="text-success"><i class="fas fa-play-circle"></i> Đang nhận quyên góp</small>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card p-4 shadow-sm border-0 h-100" style="border-left-color: #3b82f6;">
                                <small class="text-muted fw-bold text-uppercase">Tổng tiền quyên góp</small>
                                <h2 class="mt-2 mb-0 fw-bold text-dark"><fmt:formatNumber value="${totalAmount}" type="number"/>đ</h2>
                                <small class="brand-primary"><i class="fas fa-hand-holding-usd"></i> Đã được xác nhận</small>
                            </div> 
                        </div>
                        <div class="col-md-3">
                            <div class="card stat-card p-4 shadow-sm border-0 h-100" style="border-left-color: #ef4444;">
                                <small class="text-muted fw-bold text-uppercase">Quyên góp chờ duyệt</small>
                                <h2 class="mt-2 mb-0 fw-bold text-dark">${pendingDonations}</h2>
                                <small class="text-danger fw-bold"><i class="fas fa-exclamation-circle"></i> Cần xử lý ngay</small>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 pb-5">
                        <div class="col-lg-8">
                            <div class="card p-4 shadow-sm border-0 rounded-4">
                                <h5 class="fw-bold mb-4">Các giao dịch gần đây</h5>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead class="bg-light">
                                            <tr class="smallest text-muted text-uppercase">
                                                <th class="border-0">Nhà hảo tâm</th>
                                                <th class="border-0">Chiến dịch</th>
                                                <th class="border-0 text-end">Số tiền</th>
                                                <th class="border-0 text-center">Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="d" items="${dashboardDonations}">
                                                <tr>
                                                    <td>
                                                        <div class="fw-bold small">${d.user.fullName}</div>
                                                        <small class="text-muted smallest">${d.createdAt}</small>
                                                    </td>
                                                    <td class="small text-truncate" style="max-width: 200px;">${d.campaign.name}</td>
                                                    <td class="text-end fw-bold brand-primary"><fmt:formatNumber value="${d.amount}" type="number"/>đ</td>
                                                    <td class="text-center">
                                                        <c:choose>
                                                            <c:when test="${d.status == 1}"><span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Thành công</span></c:when>
                                                            <c:when test="${d.status == 0}"><span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Chờ duyệt</span></c:when>
                                                            <c:otherwise><span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Từ chối</span></c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="text-center mt-3">
                                    <a href="${pageContext.request.contextPath}/admin/donations" class="btn btn-light btn-sm rounded-pill px-4 fw-bold brand-primary border-0 shadow-sm">
                                        Xem thêm <i class="fas fa-chevron-right ms-1 smallest"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="card p-4 shadow-sm border-0 rounded-4 h-100">
                                <h5 class="fw-bold mb-4">Phân tích hệ thống</h5>
                                <div class="text-center py-5">
                                    <i class="fas fa-chart-pie fa-5x text-light mb-3"></i>
                                    <p class="text-muted small">Biểu đồ đang được xử lý...</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
