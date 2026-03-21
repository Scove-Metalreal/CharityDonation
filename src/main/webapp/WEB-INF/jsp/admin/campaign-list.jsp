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
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-2 col-xl-2 d-none d-lg-block p-0 position-fixed" style="height: 100vh;">
                <c:set var="currentPage" value="admin-campaigns" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col-lg-10 offset-lg-2 py-0">
                <!-- Top Navbar -->
                <nav class="bg-white d-flex justify-content-between align-items-center shadow-sm sticky-top px-4 py-3 mb-4">
                    <h5 class="mb-0 fw-bold text-dark">Quản lý Chiến dịch</h5>
                    <div class="d-flex align-items-center">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle shadow-sm" width="40" height="40">
                    </div>
                </nav>

                <div class="px-4">
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <form action="${pageContext.request.contextPath}/admin/campaigns" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label small fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Mới tạo</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Đang diễn ra</option>
                                    <option value="2" ${status == 2 ? 'selected' : ''}>Đã kết thúc</option>
                                    <option value="3" ${status == 3 ? 'selected' : ''}>Đóng quỹ</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-bold text-muted text-uppercase">Mã chiến dịch</label>
                                <input type="text" name="code" class="form-control form-control-sm rounded-pill px-3" value="${code}" placeholder="VD: COVID2024">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label small fw-bold text-muted text-uppercase">SĐT nhận</label>
                                <input type="text" name="phone" class="form-control form-control-sm rounded-pill px-3" value="${phone}" placeholder="Số điện thoại...">
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold"><i class="fas fa-search me-2"></i>Tìm kiếm</button>
                            </div>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold mb-0 text-muted text-uppercase">Danh sách chiến dịch</h6>
                            <a href="${pageContext.request.contextPath}/admin/campaigns/new" class="btn btn-primary btn-sm px-3 rounded-pill fw-bold"><i class="fas fa-plus me-2"></i>Tạo chiến dịch</a>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light">
                                    <tr class="small text-muted text-uppercase">
                                        <th class="border-0">Mã & Tên</th>
                                        <th class="border-0">Thời gian</th>
                                        <th class="border-0">Tiến độ quỹ</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty campaigns}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">Không tìm thấy chiến dịch nào.</td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="c" items="${campaigns}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark text-truncate" style="max-width: 200px;" title="${c.name}">${c.name}</div>
                                                <small class="text-muted">Code: ${c.code}</small>
                                            </td>
                                            <td>
                                                <div class="small text-dark">Bắt đầu: ${c.startDate}</div>
                                                <div class="small text-muted">Kết thúc: ${c.endDate}</div>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-between small mb-1">
                                                    <span class="fw-bold text-primary"><fmt:formatNumber value="${c.currentMoney}" type="number"/>đ</span>
                                                    <span class="text-muted">/ <fmt:formatNumber value="${c.targetMoney}" type="number"/>đ</span>
                                                </div>
                                                <div class="progress" style="height: 6px;">
                                                    <c:set var="percent" value="${(c.currentMoney / c.targetMoney) * 100}"/>
                                                    <div class="progress-bar bg-primary" style="width: ${percent > 100 ? 100 : percent}%"></div>
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
                                                    <a href="${pageContext.request.contextPath}/campaign/${c.id}" class="action-btn bg-info bg-opacity-10 text-info" title="Xem trước (User View)" target="_blank"><i class="far fa-eye"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/campaigns/edit?id=${c.id}" class="action-btn bg-primary bg-opacity-10 text-primary ${c.status == 3 ? 'disabled' : ''}" title="Sửa"><i class="far fa-edit"></i></a>
                                                    
                                                    <c:if test="${c.status == 2}">
                                                        <button class="action-btn bg-warning bg-opacity-10 text-warning" title="Gia hạn" onclick="openExtendModal(${c.id}, '${c.endDate}')">
                                                            <i class="fas fa-calendar-plus"></i>
                                                        </button>
                                                    </c:if>

                                                    <c:if test="${c.status == 0}">
                                                        <form action="${pageContext.request.contextPath}/admin/campaigns/delete" method="post" onsubmit="return confirm('Bạn có chắc muốn xóa?')">
                                                            <input type="hidden" name="id" value="${c.id}">
                                                            <button type="submit" class="action-btn bg-danger bg-opacity-10 text-danger" title="Xóa"><i class="far fa-trash-alt"></i></button>
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
            </div>
        </div>
    </div>
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
                            <label class="form-label small fw-bold text-muted text-uppercase">Ngày kết thúc cũ</label>
                            <input type="text" id="oldEndDate" class="form-control rounded-pill px-4 bg-light" readonly>
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted text-uppercase">Ngày kết thúc mới</label>
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
