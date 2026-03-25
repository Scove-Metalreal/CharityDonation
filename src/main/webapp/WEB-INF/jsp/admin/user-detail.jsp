<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Chi tiết người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-auto p-0 border-end" style="z-index: 1000;">
                <c:set var="currentPage" value="admin-users" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="p-4 p-xl-5">
                    <div class="mb-4">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-light rounded-pill px-3 mb-3">
                            <i class="fas fa-arrow-left me-2"></i> Quay lại danh sách
                        </a>
                        <h2 class="fw-bold">Hồ sơ chi tiết người dùng</h2>
                    </div>

                    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <div class="card-body p-0">
                            <div class="row g-0">
                                <div class="col-md-4 bg-light p-5 text-center border-end">
                                    <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://ui-avatars.com/api/?name='.concat(user.fullName).concat('&background=10B981&color=fff&size=200')}" class="rounded-circle shadow mb-4" width="150">
                                    <h4 class="fw-bold mb-1">${user.fullName}</h4>
                                    <span class="badge bg-primary rounded-pill px-3">${user.role.roleName}</span>
                                    
                                    <div class="mt-4 pt-4 border-top text-start">
                                        <div class="mb-3">
                                            <label class="smallest text-muted text-uppercase fw-bold">Trạng thái tài khoản</label>
                                            <div class="mt-1">
                                                <c:choose>
                                                    <c:when test="${user.status == 1}">
                                                        <span class="text-success fw-bold"><i class="fas fa-check-circle me-1"></i> Đang hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-danger fw-bold"><i class="fas fa-ban me-1"></i> Đã bị khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div>
                                            <label class="smallest text-muted text-uppercase fw-bold">Ngày tham gia</label>
                                            <div class="mt-1 fw-medium text-dark">${user.createdAt}</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-8 p-5">
                                    <h5 class="fw-bold mb-4 border-bottom pb-2">Thông tin cá nhân</h5>
                                    <div class="row g-4">
                                        <div class="col-sm-6">
                                            <label class="smallest text-muted text-uppercase fw-bold">Địa chỉ Email</label>
                                            <p class="fs-5 fw-medium text-dark">${user.email}</p>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="smallest text-muted text-uppercase fw-bold">Số điện thoại</label>
                                            <p class="fs-5 fw-medium text-dark">${user.phoneNumber}</p>
                                        </div>
                                        <div class="col-12">
                                            <label class="smallest text-muted text-uppercase fw-bold">Địa chỉ thường trú</label>
                                            <p class="fs-5 fw-medium text-dark">${not empty user.address ? user.address : 'Chưa cập nhật'}</p>
                                        </div>
                                    </div>

                                    <div class="mt-5 pt-4 border-top">
                                        <h5 class="fw-bold mb-4">Hoạt động hệ thống</h5>
                                        <div class="row g-3">
                                            <div class="col-md-4">
                                                <div class="p-3 bg-light rounded-3 text-center">
                                                    <div class="text-muted smallest fw-bold">TỔNG QUYÊN GÓP</div>
                                                    <div class="fs-4 fw-bold text-primary mt-1">15.000.000đ</div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="p-3 bg-light rounded-3 text-center">
                                                    <div class="text-muted smallest fw-bold">CHIẾN DỊCH THAM GIA</div>
                                                    <div class="fs-4 fw-bold text-dark mt-1">8</div>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="p-3 bg-light rounded-3 text-center">
                                                    <div class="text-muted smallest fw-bold">THEO DÕI</div>
                                                    <div class="fs-4 fw-bold text-dark mt-1">12</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
