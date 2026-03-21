<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${user.id == null ? 'Thêm người dùng mới' : 'Chỉnh sửa người dùng'} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
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
                <nav class="bg-white d-flex justify-content-between align-items-center shadow-sm sticky-top px-4 py-3 mb-4">
                    <h5 class="mb-0 fw-bold text-dark">${user.id == null ? 'Thêm người dùng mới' : 'Chỉnh sửa người dùng'}</h5>
                    <div class="d-flex align-items-center">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle shadow-sm" width="40" height="40">
                    </div>
                </nav>

                <div class="px-4 pb-5">
                    <div class="card border-0 shadow-sm overflow-hidden" style="max-width: 800px; margin: 0 auto;">
                        <div class="card-header bg-white py-3 border-0">
                            <h6 class="fw-bold mb-0 text-primary">THÔNG TIN TÀI KHOẢN</h6>
                        </div>
                        <div class="card-body p-4 pt-0">
                            <form action="${pageContext.request.contextPath}/admin/users/save" method="post">
                                <input type="hidden" name="id" value="${user.id}">
                                
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-muted">Họ và tên</label>
                                        <input type="text" name="fullName" class="form-control rounded-pill px-3" value="${user.fullName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-muted">Địa chỉ Email</label>
                                        <input type="email" name="email" class="form-control rounded-pill px-3" value="${user.email}" required ${user.id != null ? 'readonly' : ''}>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-muted">Số điện thoại</label>
                                        <input type="text" name="phoneNumber" class="form-control rounded-pill px-3" value="${user.phoneNumber}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-muted">Vai trò</label>
                                        <select name="role.id" class="form-select rounded-pill px-3" required>
                                            <c:forEach var="role" items="${roles}">
                                                <option value="${role.id}" ${user.role.id == role.id ? 'selected' : ''}>${role.roleName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-muted">Mật khẩu ${user.id == null ? '' : '(Để trống nếu không đổi)'}</label>
                                        <input type="password" name="rawPassword" class="form-control rounded-pill px-3" ${user.id == null ? 'required' : ''}>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label small fw-bold text-muted">Trạng thái</label>
                                        <select name="status" class="form-select rounded-pill px-3">
                                            <option value="1" ${user.status == 1 ? 'selected' : ''}>Hoạt động</option>
                                            <option value="0" ${user.status == 0 ? 'selected' : ''}>Khóa</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="mt-4 pt-3 border-top d-flex gap-2">
                                    <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Lưu thay đổi</button>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-light rounded-pill px-4">Hủy bỏ</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
