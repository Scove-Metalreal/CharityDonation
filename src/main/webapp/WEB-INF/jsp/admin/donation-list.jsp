<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
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
        <div class="row flex-nowrap">
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <div class="col p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <form action="${pageContext.request.contextPath}/admin/donations" method="get" class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Tìm kiếm</label>
                                <input type="text" name="keyword" class="form-control form-control-sm rounded-pill px-3" placeholder="Tên nhà hảo tâm hoặc chiến dịch..." value="${keyword}">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="2" ${status == 2 ? 'selected' : ''}>Đã từ chối</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold">Lọc</button>
                            </div>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light text-uppercase smallest fw-bold text-muted">
                                    <tr>
                                        <th class="border-0">Nhà hảo tâm</th>
                                        <th class="border-0">Chiến dịch</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="d" items="${donations}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${d.user.fullName}</div>
                                                <small class="text-muted smallest">Quyên góp: <fmt:formatNumber value="${d.amount}" type="number"/>đ</small>
                                            </td>
                                            <td><div class="small text-dark text-truncate" style="max-width: 200px;">${d.campaign.name}</div></td>
                                            <td class="text-center">
                                                <span class="badge ${d.status == 0 ? 'bg-warning' : (d.status == 1 ? 'bg-success' : 'bg-danger')} bg-opacity-10 ${d.status == 0 ? 'text-warning' : (d.status == 1 ? 'text-success' : 'text-danger')} rounded-pill px-3">
                                                    ${d.status == 0 ? 'Chờ duyệt' : (d.status == 1 ? 'Đã nhận' : 'Từ chối')}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <c:if test="${d.status == 0}">
                                                    <div class="d-flex justify-content-end gap-1">
                                                        <form action="${pageContext.request.contextPath}/admin/donations/confirm" method="post" class="m-0">
                                                            <input type="hidden" name="donationId" value="${d.id}">
                                                            <button type="submit" class="action-btn bg-success bg-opacity-10 text-success"><i class="fas fa-check"></i></button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/admin/donations/reject" method="post" class="m-0">
                                                            <input type="hidden" name="donationId" value="${d.id}">
                                                            <button type="submit" class="action-btn bg-danger bg-opacity-10 text-danger"><i class="fas fa-times"></i></button>
                                                        </form>
                                                    </div>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Custom Pagination -->
                        <div class="d-flex flex-column align-items-center mt-4">
                            <div class="page-info">Trang ${currentPage} / ${totalPages}</div>
                            <div class="custom-pagination">
                                <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" href="?page=${currentPage - 1}&keyword=${keyword}&status=${status}"><i class="fas fa-chevron-left"></i></a>
                                <c:forEach var="i" begin="1" end="${totalPages > 0 ? totalPages : 1}">
                                    <a class="page-btn ${currentPage == i ? 'active' : ''}" href="?page=${i}&keyword=${keyword}&status=${status}">${i}</a>
                                </c:forEach>
                                <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" href="?page=${currentPage + 1}&keyword=${keyword}&status=${status}"><i class="fas fa-chevron-right"></i></a>
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
