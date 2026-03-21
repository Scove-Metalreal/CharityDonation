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
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: var(--transition); }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-2 col-xl-2 d-none d-lg-block p-0 position-fixed" style="height: 100vh;">
                <c:set var="currentPage" value="admin-users" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col-lg-10 offset-lg-2 py-0">
                <!-- Top Navbar -->
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4">
                    <div class="card border-0 shadow-sm p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h6 class="fw-bold mb-0 text-muted text-uppercase">Danh sách thành viên</h6>
                            <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary btn-sm px-3 rounded-pill fw-bold"><i class="fas fa-user-plus me-2"></i>Thêm người dùng</a>
                        </div>

                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light">
                                    <tr class="small text-muted text-uppercase">
                                        <th class="border-0">Người dùng</th>
                                        <th class="border-0">Thông tin liên hệ</th>
                                        <th class="border-0">Vai trò</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:if test="${empty users}">
                                        <tr>
                                            <td colspan="5" class="text-center py-5 text-muted">Không tìm thấy người dùng nào.</td>
                                        </tr>
                                    </c:if>
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
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
