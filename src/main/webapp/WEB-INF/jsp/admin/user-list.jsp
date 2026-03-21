<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: var(--transition); }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <!-- Filters -->
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Tìm kiếm</label>
                                <input type="text" name="keyword" class="form-control form-control-sm rounded-pill px-3" placeholder="Tên, email, SĐT..." value="${keyword}">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Vai trò</label>
                                <select name="roleId" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="r" items="${roles}">
                                        <option value="${r.id}" ${roleId == r.id ? 'selected' : ''}>${r.roleName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Đã khóa</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Không hoạt động</label>
                                <select name="inactive" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">-- Mặc định --</option>
                                    <option value="1w" ${inactive == '1w' ? 'selected' : ''}>Hơn 1 tuần</option>
                                    <option value="1m" ${inactive == '1m' ? 'selected' : ''}>Hơn 1 tháng</option>
                                    <option value="1q" ${inactive == '1q' ? 'selected' : ''}>Hơn 1 quý</option>
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
                                        <th class="border-0">Người dùng</th>
                                        <th class="border-0">Vai trò</th>
                                        <th class="border-0">Đăng nhập cuối</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${u.fullName}</div>
                                                <small class="text-muted smallest">${u.email}</small>
                                            </td>
                                            <td><span class="badge bg-light text-dark border px-3 rounded-pill">${u.role.roleName}</span></td>
                                            <td class="smallest">
                                                <c:choose>
                                                    <c:when test="${not empty u.lastLogin}">
                                                        <fmt:parseDate value="${u.lastLogin}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                                        <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy" />
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">Chưa đăng nhập</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${u.status == 1 ? 'bg-success' : 'bg-danger'} bg-opacity-10 ${u.status == 1 ? 'text-success' : 'text-danger'} rounded-pill px-3">
                                                    ${u.status == 1 ? 'Hoạt động' : 'Bị khóa'}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex justify-content-end gap-1">
                                                    <a href="${pageContext.request.contextPath}/admin/users/detail/${u.id}" class="action-btn bg-info bg-opacity-10 text-info"><i class="far fa-eye"></i></a>
                                                    <form action="${pageContext.request.contextPath}/admin/users/toggle-status" method="post" class="m-0">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <button type="submit" class="action-btn ${u.status == 1 ? 'bg-danger bg-opacity-10 text-danger' : 'bg-success bg-opacity-10 text-success'}">
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

                        <!-- Custom Pagination -->
                        <div class="d-flex flex-column align-items-center mt-4">
                            <div class="page-info">Trang ${currentPage} / ${totalPages}</div>
                            <div class="custom-pagination">
                                <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" 
                                   href="?page=${currentPage - 1}&keyword=${keyword}&roleId=${roleId}&status=${status}&inactive=${inactive}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                                
                                <c:forEach var="i" begin="1" end="${totalPages > 0 ? totalPages : 1}">
                                    <a class="page-btn ${currentPage == i ? 'active' : ''}" 
                                       href="?page=${i}&keyword=${keyword}&roleId=${roleId}&status=${status}&inactive=${inactive}">${i}</a>
                                </c:forEach>
                                
                                <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" 
                                   href="?page=${currentPage + 1}&keyword=${keyword}&roleId=${roleId}&status=${status}&inactive=${inactive}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
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
