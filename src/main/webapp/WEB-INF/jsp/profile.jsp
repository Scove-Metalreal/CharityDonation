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
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .profile-cover { height: 200px; background: linear-gradient(to right, #10b981, #3b82f6); border-radius: 0; }
        .profile-avatar-wrapper { margin-top: -60px; padding-left: 30px; position: relative; z-index: 5; }
        .profile-avatar { width: 120px; height: 120px; border: 4px solid #fff; object-fit: cover; }
        .history-card { border: 1px solid var(--color-border); border-radius: 12px; transition: var(--transition); }
        .history-card:hover { border-color: var(--color-primary); background-color: #f9fafb; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0 border-end" style="z-index: 1000;">
                <c:set var="currentPage" value="profile" scope="request"/>
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <!-- Main Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
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
                    <h5 class="fw-bold mb-4">Lịch sử quyên góp</h5>
                    <c:choose>
                        <c:when test="${empty donations}">
                            <div class="text-center py-5 bg-light rounded-4">
                                <p class="text-muted">Bạn chưa thực hiện quyên góp nào.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex flex-column gap-3">
                                <c:forEach var="d" items="${donations}">
                                    <div class="p-3 history-card d-flex align-items-center">
                                        <div class="flex-grow-1 overflow-hidden">
                                            <div class="fw-bold text-dark text-truncate small">${d.campaign.name}</div>
                                            <div class="text-muted small"><fmt:formatDate value="${d.createdAt}" pattern="dd/MM/yyyy HH:mm"/></div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-primary"><fmt:formatNumber value="${d.amount}" type="number"/> đ</div>
                                            <span class="badge ${d.status == 1 ? 'bg-success' : 'bg-warning'} bg-opacity-10 ${d.status == 1 ? 'text-success' : 'text-warning'} rounded-pill px-2" style="font-size: 0.6rem;">
                                                ${d.status == 1 ? 'Đã xác nhận' : 'Chờ xác nhận'}
                                            </span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <jsp:include page="fragments/footer.jsp"/>
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
                    <form action="${pageContext.request.contextPath}/user/update-profile" method="post">
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
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
