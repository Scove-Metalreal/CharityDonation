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
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: var(--transition); }
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
                        <form action="${pageContext.request.contextPath}/admin/campaigns" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Mới tạo</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Đang chạy</option>
                                    <option value="2" ${status == 2 ? 'selected' : ''}>Kết thúc</option>
                                    <option value="3" ${status == 3 ? 'selected' : ''}>Đóng quỹ</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Mã chiến dịch</label>
                                <input type="text" name="code" class="form-control form-control-sm rounded-pill px-3" value="${code}" placeholder="Mã định danh...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">SĐT nhận</label>
                                <input type="text" name="phone" class="form-control form-control-sm rounded-pill px-3" value="${phone}" placeholder="Số điện thoại...">
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold">Tìm kiếm</button>
                            </div>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light text-uppercase smallest fw-bold text-muted">
                                    <tr>
                                        <th class="border-0">Chiến dịch</th>
                                        <th class="border-0">Tiến độ quỹ</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${campaigns}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark text-truncate" style="max-width: 250px;">${c.name}</div>
                                                <small class="text-muted smallest">Code: ${c.code}</small>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-between smallest mb-1">
                                                    <span class="fw-bold text-primary"><fmt:formatNumber value="${c.currentMoney}" type="number"/>đ</span>
                                                    <span class="text-muted">/ <fmt:formatNumber value="${c.targetMoney}" type="number"/>đ</span>
                                                </div>
                                                <div class="progress" style="height: 6px;">
                                                    <c:set var="percent" value="${(c.currentMoney / c.targetMoney) * 100}"/>
                                                    <div class="progress-bar bg-primary" style="width: ${percent > 100 ? 100 : percent}%"></div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${c.status == 0 ? 'bg-info' : (c.status == 1 ? 'bg-success' : 'bg-warning')} bg-opacity-10 ${c.status == 0 ? 'text-info' : (c.status == 1 ? 'text-success' : 'text-warning')} rounded-pill px-3">
                                                    ${c.status == 0 ? 'Mới tạo' : (c.status == 1 ? 'Đang chạy' : 'Kết thúc')}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex justify-content-end gap-1">
                                                    <a href="${pageContext.request.contextPath}/campaign/${c.id}" class="action-btn bg-info bg-opacity-10 text-info" target="_blank"><i class="far fa-eye"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/campaigns/edit?id=${c.id}" class="action-btn bg-primary bg-opacity-10 text-primary"><i class="far fa-edit"></i></a>
                                                    <c:if test="${c.status == 2}">
                                                        <button class="action-btn bg-warning bg-opacity-10 text-warning" onclick="openExtendModal(${c.id}, '${c.endDate}')"><i class="fas fa-calendar-plus"></i></button>
                                                    </c:if>
                                                </div>
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
                                <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" href="?page=${currentPage - 1}&status=${status}&code=${code}&phone=${phone}"><i class="fas fa-chevron-left"></i></a>
                                <c:forEach var="i" begin="1" end="${totalPages > 0 ? totalPages : 1}">
                                    <a class="page-btn ${currentPage == i ? 'active' : ''}" href="?page=${i}&status=${status}&code=${code}&phone=${phone}">${i}</a>
                                </c:forEach>
                                <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" href="?page=${currentPage + 1}&status=${status}&code=${code}&phone=${phone}"><i class="fas fa-chevron-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <!-- Modal Gia hạn -->
    <div class="modal fade" id="extendModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 bg-dark text-white p-4">
                    <h5 class="modal-title fw-bold">GIA HẠN CHIẾN DỊCH</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/campaigns/extend" method="post">
                        <input type="hidden" name="id" id="extendId">
                        <div class="mb-4">
                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc cũ</label>
                            <input type="text" id="oldEndDate" class="form-control rounded-pill px-4 bg-light" readonly>
                        </div>
                        <div class="mb-4">
                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc mới</label>
                            <input type="date" name="newEndDate" class="form-control rounded-pill px-4" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow">XÁC NHẬN GIA HẠN</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openExtendModal(id, oldDate) {
            document.getElementById('extendId').value = id;
            document.getElementById('oldEndDate').value = oldDate;
            new bootstrap.Modal(document.getElementById('extendModal')).show();
        }
    </script>
</body>
</html>
