<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .profile-cover { height: 200px; background: linear-gradient(to right, #10b981, #3b82f6); border-radius: 0; }
        .profile-avatar-wrapper { margin-top: -60px; padding-left: 30px; position: relative; z-index: 5; }
        .profile-avatar { width: 120px; height: 120px; border: 4px solid #fff; object-fit: cover; }
        .history-card { border: 1px solid var(--color-border); border-radius: 12px; transition: var(--transition); }
        .history-card:hover { border-color: var(--color-primary); background-color: #f9fafb; }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="row">
            <!-- Left Sidebar (Same as Homepage) -->
            <div class="col-lg-3 d-none d-lg-block">
                <div class="sidebar-x">
                    <div class="mb-4 ps-3">
                        <i class="fas fa-hand-holding-heart fa-2x text-primary"></i>
                    </div>
                    <nav class="nav flex-column mb-4">
                        <a class="nav-link" href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
                        <a class="nav-link" href="#"><i class="fas fa-bullhorn"></i> Chiến dịch</a>
                        <a class="nav-link" href="#"><i class="fas fa-handshake"></i> Nhà đồng hành</a>
                        <a class="nav-link active" href="${pageContext.request.contextPath}/user/profile"><i class="fas fa-user"></i> Hồ sơ</a>
                        <a class="nav-link" href="#"><i class="fas fa-cog"></i> Cài đặt</a>
                    </nav>
                    <div class="sidebar-user-mini d-flex align-items-center bg-light">
                        <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=10B981&color=fff" class="rounded-circle me-3" width="40" height="40">
                        <div class="overflow-hidden">
                            <div class="fw-bold text-dark text-truncate">${user.fullName}</div>
                            <div class="text-muted small text-truncate">@user_${user.id}</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9 bg-white min-vh-100 shadow-sm p-0">
                <!-- Header Section -->
                <div class="profile-cover"></div>
                <div class="profile-avatar-wrapper d-flex justify-content-between align-items-end pe-4">
                    <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=10B981&color=fff&size=256" class="rounded-circle profile-avatar shadow-sm">
                    <div class="mb-2">
                        <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-danger rounded-pill fw-bold me-2">Đăng xuất</a>
                        <button class="btn btn-outline-primary rounded-pill fw-bold" data-bs-toggle="modal" data-bs-target="#editProfileModal">Chỉnh sửa hồ sơ</button>
                    </div>
                </div>

                <div class="px-4 mt-3 mb-5">
                    <h3 class="fw-bold mb-0 text-dark">${user.fullName}</h3>
                    <p class="text-muted mb-3"><i class="fas fa-user-tag me-1 small"></i> ${user.role.roleName}</p>
                    
                    <c:if test="${not empty param.message}">
                        <div class="alert alert-success alert-dismissible fade show small py-2 mb-3" role="alert">
                            Cập nhật thông tin thành công!
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger alert-dismissible fade show small py-2 mb-3" role="alert">
                            <c:choose>
                                <c:when test="${param.error eq 'duplicate-email'}">Email này đã được sử dụng bởi người khác!</c:when>
                                <c:when test="${param.error eq 'duplicate-phone'}">Số điện thoại này đã được sử dụng bởi người khác!</c:when>
                                <c:otherwise>Có lỗi xảy ra, vui lòng thử lại!</c:otherwise>
                            </c:choose>
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.messagePw}">
                        <div class="alert alert-success alert-dismissible fade show small py-2 mb-3" role="alert">
                            Đổi mật khẩu thành công!
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.errorPw}">
                        <div class="alert alert-danger alert-dismissible fade show small py-2 mb-3" role="alert">
                            <c:choose>
                                <c:when test="${param.errorPw eq 'wrong-old'}">Mật khẩu hiện tại không chính xác!</c:when>
                                <c:when test="${param.errorPw eq 'same-password'}">Mật khẩu mới không được trùng với mật khẩu cũ!</c:when>
                                <c:when test="${param.errorPw eq 'mismatch'}">Mật khẩu xác nhận không khớp!</c:when>
                                <c:otherwise>Có lỗi xảy ra, vui lòng thử lại!</c:otherwise>
                            </c:choose>
                            <button type="button" class="btn-close py-2" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="d-flex flex-wrap gap-4 text-muted small">
                        <span><i class="fas fa-map-marker-alt me-1"></i> ${not empty user.address ? user.address : 'Chưa cập nhật địa chỉ'}</span>
                        <span><i class="fas fa-phone me-1"></i> ${user.phoneNumber}</span>
                        <span><i class="fas fa-envelope me-1"></i> ${user.email}</span>
                    </div>
                </div>

                <!-- Statistics Section -->
                <div class="row g-3 px-4 mb-5">
                    <div class="col-md-4">
                        <div class="card p-3 text-center border shadow-none h-100">
                            <small class="text-muted uppercase fw-bold" style="font-size: 0.7rem;">NGÀY THAM GIA</small>
                            <h5 class="mt-2 mb-0 fw-bold">12/03/2026</h5>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3 text-center border border-warning shadow-none h-100 bg-warning bg-opacity-10">
                            <small class="text-warning uppercase fw-bold" style="font-size: 0.7rem;">TỔNG QUYÊN GÓP</small>
                            <h4 class="mt-2 mb-0 fw-bold text-warning"><fmt:formatNumber value="${totalDonated}" type="number"/> đ</h4>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3 text-center border shadow-none h-100">
                            <small class="text-muted uppercase fw-bold" style="font-size: 0.7rem;">CHIẾN DỊCH THAM GIA</small>
                            <h5 class="mt-2 mb-0 fw-bold">${donations.size()}</h5>
                        </div>
                    </div>
                </div>

                <!-- Donation History Section -->
                <div class="px-4 pb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold mb-0">Lịch sử quyên góp</h5>
                        <div class="dropdown">
                            <button class="btn btn-light btn-sm dropdown-toggle rounded-pill" type="button" data-bs-toggle="dropdown">Tất cả</button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-menu small" href="#">Thành công</a></li>
                                <li><a class="dropdown-menu small" href="#">Đang xử lý</a></li>
                            </ul>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${empty donations}">
                            <div class="text-center py-5 bg-light rounded-4">
                                <i class="fas fa-history fa-3x text-muted mb-3 opacity-25"></i>
                                <p class="text-muted">Bạn chưa thực hiện quyên góp nào.</p>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-sm rounded-pill">Khám phá chiến dịch</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="d" items="${donations}">
                                    <div class="p-3 history-card d-flex align-items-center">
                                        <div class="flex-shrink-0 me-3">
                                            <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 45px; height: 45px;">
                                                <i class="fas fa-hand-holding-heart"></i>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1 overflow-hidden">
                                            <div class="fw-bold text-dark text-truncate small">${d.campaign.name}</div>
                                            <div class="text-muted small">ID: #${d.id} • ${d.createdAt}</div>
                                        </div>
                                        <div class="text-center px-3 d-none d-md-block">
                                            <div class="small text-muted">Phương thức</div>
                                            <div class="small fw-bold">${d.paymentMethod.methodName}</div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-primary"><fmt:formatNumber value="${d.amount}" type="number"/> đ</div>
                                            <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3" style="font-size: 0.65rem;">Thành công</span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Profile Modal -->
    <div class="modal fade" id="editProfileModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold">Chỉnh sửa thông tin</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/user/update-profile" method="post" id="updateForm">
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Họ và tên</label>
                            <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Email</label>
                            <input type="email" name="email" class="form-control" value="${user.email}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Số điện thoại</label>
                            <input type="tel" name="phoneNumber" class="form-control" value="${user.phoneNumber}">
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-bold">Địa chỉ</label>
                            <textarea name="address" class="form-control" rows="2">${user.address}</textarea>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 rounded-pill py-2">Lưu thay đổi</button>
                    </form>
                    
                    <hr class="my-4 opacity-10">
                    
                    <h6 class="fw-bold mb-3">Đổi mật khẩu</h6>
                    <form action="${pageContext.request.contextPath}/user/change-password" method="post" id="changePasswordForm">
                        <div class="mb-3">
                            <input type="password" name="oldPassword" class="form-control" placeholder="Mật khẩu hiện tại" required>
                        </div>
                        <div class="mb-3">
                            <input type="password" name="newPassword" id="newPassword" class="form-control" placeholder="Mật khẩu mới" required minlength="6">
                        </div>
                        <div class="mb-3">
                            <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" placeholder="Xác nhận mật khẩu mới" required>
                        </div>
                        <button type="submit" class="btn btn-light w-100 rounded-pill border py-2">Cập nhật mật khẩu</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('changePasswordForm').addEventListener('submit', function(e) {
            const newPw = document.getElementById('newPassword').value;
            const confirmPw = document.getElementById('confirmPassword').value;
            if (newPw !== confirmPw) {
                alert('Mật khẩu xác nhận không khớp!');
                e.preventDefault();
            }
        });
    </script>
</body>
</html>
