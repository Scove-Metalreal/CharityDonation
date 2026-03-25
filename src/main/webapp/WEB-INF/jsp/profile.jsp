<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Hồ sơ cá nhân - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .profile-cover { height: 200px; background: linear-gradient(to right, #10b981, #3b82f6); border-radius: 0; }
        .profile-avatar-wrapper { margin-top: -60px; padding-left: 30px; position: relative; z-index: 5; }
        .profile-avatar-container { position: relative; width: 120px; height: 120px; cursor: pointer; }
        .profile-avatar { width: 120px; height: 120px; border: 4px solid #fff; object-fit: cover; transition: filter 0.3s; }
        .avatar-overlay { 
            position: absolute; top: 0; left: 0; width: 120px; height: 120px; 
            background: rgba(0,0,0,0.4); border-radius: 50%; border: 4px solid #fff;
            display: flex; align-items: center; justify-content: center; 
            opacity: 0; transition: opacity 0.3s; color: white; font-size: 1.5rem;
        }
        .profile-avatar-container:hover .avatar-overlay { opacity: 1; }
        .profile-avatar-container:hover .profile-avatar { filter: brightness(0.7); }
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
                    <div class="profile-avatar-container" onclick="document.getElementById('avatarInput').click()">
                        <img src="${not empty user.avatarUrl ? user.avatarUrl : 'https://ui-avatars.com/api/?name='.concat(user.fullName).concat('&background=10B981&color=fff&size=256')}" 
                             class="rounded-circle profile-avatar shadow-sm">
                        <div class="avatar-overlay">
                            <i class="fas fa-camera"></i>
                        </div>
                    </div>
                    <form id="avatarForm" action="${pageContext.request.contextPath}/user/upload-avatar" method="post" enctype="multipart/form-data" class="d-none">
                        <input type="file" name="avatar" id="avatarInput" accept="image/*" onchange="document.getElementById('avatarForm').submit()">
                    </form>
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
                                <c:when test="${param.error eq 'upload-failed'}">Tải lên ảnh đại diện thất bại!</c:when>
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
                    <div class="col-md-3">
                        <div class="card p-3 text-center border shadow-none h-100">
                            <small class="text-muted uppercase fw-bold" style="font-size: 0.7rem;">NGÀY THAM GIA</small>
                            <h5 class="mt-2 mb-0 fw-bold">12/03/2026</h5>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card p-3 text-center border border-warning shadow-none h-100 bg-warning bg-opacity-10">
                            <small class="text-warning uppercase fw-bold" style="font-size: 0.7rem;">TỔNG QUYÊN GÓP</small>
                            <h4 class="mt-2 mb-0 fw-bold text-warning"><fmt:formatNumber value="${totalDonated}" type="number"/> đ</h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card p-3 text-center border shadow-none h-100">
                            <small class="text-muted uppercase fw-bold" style="font-size: 0.7rem;">QUYÊN GÓP</small>
                            <h5 class="mt-2 mb-0 fw-bold">${donations.size()}</h5>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <a href="#following" class="text-decoration-none h-100">
                            <div class="card p-3 text-center border border-primary shadow-none h-100 hover-bg-light transition">
                                <small class="text-primary uppercase fw-bold" style="font-size: 0.7rem;">ĐANG THEO DÕI</small>
                                <h5 class="mt-2 mb-0 fw-bold text-primary">${followingList.size()}</h5>
                            </div>
                        </a>
                    </div>
                </div>

                <div class="px-4 mb-5">
                    <ul class="nav nav-tabs nav-tabs-custom border-bottom mb-4">
                        <li class="nav-item"><button class="nav-link active fw-bold border-0 bg-transparent text-dark px-0 me-4 position-relative" data-bs-toggle="tab" data-bs-target="#historyTab">Lịch sử quyên góp</button></li>
                        <li class="nav-item"><button class="nav-link fw-bold border-0 bg-transparent text-muted px-0 position-relative" data-bs-toggle="tab" data-bs-target="#followingTab" id="following-tab-btn">Đang theo dõi</button></li>
                    </ul>

                    <div class="tab-content">
                        <!-- Donation History -->
                        <div class="tab-pane fade show active" id="historyTab">
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
                                                    <a href="${pageContext.request.contextPath}/campaign/${d.campaign.id}" class="text-decoration-none fw-bold text-dark text-truncate small d-block">${d.campaign.name}</a>
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

                        <!-- Following Campaigns -->
                        <div class="tab-pane fade" id="followingTab">
                            <div id="following"></div>
                            <c:choose>
                                <c:when test="${empty followingList}">
                                    <div class="text-center py-5 bg-light rounded-4">
                                        <p class="text-muted">Bạn chưa theo dõi chiến dịch nào.</p>
                                        <a href="${pageContext.request.contextPath}/#campaigns" class="btn btn-primary rounded-pill btn-sm px-4">Khám phá ngay</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="following-list d-flex flex-column border rounded-4 overflow-hidden">
                                        <c:forEach var="f" items="${followingList}">
                                            <div class="following-card p-3 d-flex align-items-center border-bottom hover-bg-light transition">
                                                <img src="${not empty f.campaign.imageUrl ? f.campaign.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80'}" 
                                                     class="rounded-3 me-3 object-fit-cover" width="80" height="80">
                                                <div class="flex-grow-1 overflow-hidden me-3">
                                                    <a href="${pageContext.request.contextPath}/campaign/${f.campaign.id}" class="fw-bold text-dark text-decoration-none text-truncate d-block">${f.campaign.name}</a>
                                                    <p class="text-muted small text-truncate mb-1">${f.campaign.content.replaceAll("<[^>]*>", "").substring(0, 100)}...</p>
                                                    <div class="d-flex gap-2 align-items-center">
                                                        <span class="badge ${f.campaign.status == 1 ? 'bg-success' : 'bg-secondary'} bg-opacity-10 ${f.campaign.status == 1 ? 'text-success' : 'text-secondary'} rounded-pill smallest">
                                                            ${f.campaign.status == 1 ? 'Đang chạy' : 'Kết thúc'}
                                                        </span>
                                                        <c:if test="${f.receiveEmail == 1}"><i class="fas fa-bell text-primary smallest" title="Nhận thông báo email"></i></c:if>
                                                    </div>
                                                </div>
                                                <form action="${pageContext.request.contextPath}/campaign/unfollow" method="post" class="m-0">
                                                    <input type="hidden" name="campaignId" value="${f.campaign.id}">
                                                    <input type="hidden" name="redirect" value="profile">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3 fw-bold">Bỏ theo dõi</button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <jsp:include page="fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <!-- Script for Tab Handling -->
    <script>
        window.addEventListener('load', function() {
            if (window.location.hash === '#following') {
                const triggerEl = document.querySelector('#following-tab-btn');
                if (triggerEl) {
                    bootstrap.Tab.getInstance(triggerEl)?.show() || new bootstrap.Tab(triggerEl).show();
                }
            }
        });
        
        document.querySelectorAll('.nav-tabs-custom .nav-link').forEach(btn => {
            btn.addEventListener('shown.bs.tab', function (e) {
                document.querySelectorAll('.nav-tabs-custom .nav-link').forEach(l => {
                    l.classList.remove('text-dark');
                    l.classList.add('text-muted');
                });
                e.target.classList.remove('text-muted');
                e.target.classList.add('text-dark');
            });
        });
    </script>
    <style>
        .nav-tabs-custom .nav-link.active::after {
            content: ""; position: absolute; bottom: -1px; left: 0; right: 0; height: 3px; background: var(--color-primary); border-radius: 3px;
        }
        .following-card:last-child { border-bottom: none !important; }
        .hover-bg-light:hover { background-color: #f8fafc; }
        .transition { transition: all 0.2s ease-in-out; }
        .object-fit-cover { object-fit: cover; }
    </style>

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
        document.getElementById('changePasswordForm')?.addEventListener('submit', function(e) {
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
