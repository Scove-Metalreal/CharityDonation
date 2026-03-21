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
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-2 col-xl-2 d-none d-lg-block p-0 position-fixed" style="height: 100vh;">
                <c:set var="currentPage" value="admin-donations" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col-lg-10 offset-lg-2 py-0">
                <!-- Top Navbar -->
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4">
                    <div class="card border-0 shadow-sm p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light">
                                    <tr class="small text-muted text-uppercase">
                                        <th class="border-0">Nhà hảo tâm</th>
                                        <th class="border-0">Chiến dịch</th>
                                        <th class="border-0">Số tiền</th>
                                        <th class="border-0">Ngày gửi</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty donations}">
                                        <tr>
                                            <td colspan="6" class="text-center py-5 text-muted">Không có yêu cầu quyên góp nào cần xử lý.</td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="d" items="${donations}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${d.user.fullName}</div>
                                                <c:if test="${d.isAnonymous == 1}"><small class="text-warning">(Ẩn danh)</small></c:if>
                                            </td>
                                            <td>
                                                <div class="small text-dark text-truncate" style="max-width: 250px;" title="${d.campaign.name}">${d.campaign.name}</div>
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
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
