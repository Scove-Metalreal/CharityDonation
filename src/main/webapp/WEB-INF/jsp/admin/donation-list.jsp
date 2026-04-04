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
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <div class="col scrollable-main p-0 bg-white" style="min-width: 0; min-height: 100vh;">
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
                                    <option value="${STATUS.DONATION_PENDING}" ${status == STATUS.DONATION_PENDING ? 'selected' : ''}>Chờ xác nhận</option>
                                    <option value="${STATUS.DONATION_CONFIRMED}" ${status == STATUS.DONATION_CONFIRMED ? 'selected' : ''}>Đã xác nhận</option>
                                    <option value="${STATUS.DONATION_REJECTED}" ${status == STATUS.DONATION_REJECTED ? 'selected' : ''}>Đã từ chối</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Sắp xếp</label>
                                <select name="sortBy" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="createdAt" ${sortBy == 'createdAt' ? 'selected' : ''}>Ngày quyên góp</option>
                                    <option value="amount" ${sortBy == 'amount' ? 'selected' : ''}>Số tiền</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Thứ tự</label>
                                <select name="direction" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="desc" ${direction == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                    <option value="asc" ${direction == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-brand-primary btn-sm w-100 rounded-pill fw-bold">Lọc & Xếp</button>
                            </div>
                        </form>
                    </div>

                    <!-- Donation Table -->
                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="bg-light bg-opacity-50">
                                    <tr class="smallest text-muted text-uppercase">
                                        <th class="border-0 px-4 py-3">Nhà hảo tâm</th>
                                        <th class="border-0 py-3">Chiến dịch</th>
                                        <th class="border-0 py-3 text-end">Số tiền</th>
                                        <th class="border-0 text-center py-3">Trạng thái</th>
                                        <th class="border-0 text-end px-4 py-3">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="d" items="${donations}">
                                        <tr>
                                            <td class="px-4 py-3">
                                                <div class="d-flex align-items-center">
                                                    <img src="https://ui-avatars.com/api/?name=${d.donorName}&background=random&color=fff&size=36" class="rounded-circle me-3">
                                                    <div>
                                                        <div class="fw-bold text-dark small">${d.donorName}</div>
                                                        <div class="smallest text-muted">
                                                            <fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="py-3">
                                                <div class="small text-dark text-truncate" style="max-width: 250px;" title="${d.campaignName}">${d.campaignName}</div>
                                                <div class="smallest text-muted fw-medium">${d.paymentMethodName}</div>
                                            </td>
                                            <td class="py-3 text-end">
                                                <div class="fw-bold text-primary small"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                            </td>
                                            <td class="text-center py-3">
                                                <span class="badge ${d.status == STATUS.DONATION_PENDING ? 'bg-warning' : (d.status == STATUS.DONATION_CONFIRMED ? 'bg-success' : 'bg-danger')} bg-opacity-10 ${d.status == STATUS.DONATION_PENDING ? 'text-warning' : (d.status == STATUS.DONATION_CONFIRMED ? 'text-success' : 'text-danger')} rounded-pill px-3">
                                                    ${d.status == STATUS.DONATION_PENDING ? 'Chờ duyệt' : (d.status == STATUS.DONATION_CONFIRMED ? 'Thành công' : 'Từ chối')}
                                                </span>
                                            </td>
                                            <td class="text-end px-4 py-3">
                                                <c:if test="${d.status == STATUS.DONATION_PENDING}">
                                                    <div class="d-flex gap-2 justify-content-end">
                                                        <form action="${pageContext.request.contextPath}/admin/donations/confirm" method="post" class="m-0">
                                                            <input type="hidden" name="donationId" value="${d.id}">
                                                            <button type="submit" class="action-btn bg-success bg-opacity-10 text-success" title="Xác nhận duyệt">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </form>
                                                        <button type="button" class="action-btn bg-danger bg-opacity-10 text-danger" title="Từ chối duyệt" 
                                                                onclick="confirmRejectDonation(${d.id})">
                                                            <i class="fas fa-times"></i>
                                                        </button>
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
                            <div class="page-info mb-2 text-muted smallest fw-bold">Trang ${currentPage} / ${totalPages}</div>
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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function confirmRejectDonation(donationId) {
            Swal.fire({
                title: 'Từ chối quyên góp',
                text: 'Vui lòng nhập lý do từ chối:',
                input: 'text',
                inputPlaceholder: 'Lý do (ví dụ: Thông tin giao dịch không chính xác)',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                confirmButtonText: 'Từ chối ngay',
                cancelButtonText: 'Hủy bỏ',
                inputValidator: (value) => {
                    if (!value) {
                        return 'Bạn cần nhập lý do từ chối!';
                    }
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '${pageContext.request.contextPath}/admin/donations/reject';

                    const idInput = document.createElement('input');
                    idInput.type = 'hidden';
                    idInput.name = 'donationId';
                    idInput.value = donationId;

                    const reasonInput = document.createElement('input');
                    reasonInput.type = 'hidden';
                    reasonInput.name = 'reason';
                    reasonInput.value = result.value;

                    form.appendChild(idInput);
                    form.appendChild(reasonInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        }
    </script>
</body>
</html>
