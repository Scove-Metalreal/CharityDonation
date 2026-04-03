<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="referrer" content="no-referrer">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Hồ sơ cá nhân - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .brand-primary { color: var(--color-primary) !important; }
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
                        <button class="btn btn-brand-secondary rounded-pill fw-bold" data-bs-toggle="modal" data-bs-target="#editProfileModal">Chỉnh sửa hồ sơ</button>
                    </div>
                </div>

                <div class="px-4 mt-3 mb-5">
                    <h3 class="fw-bold mb-0 text-dark">${user.fullName}</h3>
                    <p class="text-muted mb-3"><i class="fas fa-user-tag me-1 small"></i> ${user.roleName}</p>
                    
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
                            <small class="brand-primary uppercase fw-bold" style="font-size: 0.7rem;">NGÀY THAM GIA</small>
                            <h5 class="mt-2 mb-0 fw-bold brand-primary">
                                <fmt:parseDate value="${user.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedJoinDate" type="both" />
                                <fmt:formatDate value="${parsedJoinDate}" pattern="dd/MM/yyyy" />
                            </h5>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card p-3 text-center border border-warning shadow-none h-100 bg-warning bg-opacity-10">
                            <small class="text-warning uppercase fw-bold" style="font-size: 0.7rem;">TỔNG QUYÊN GÓP</small>
                            <h4 class="mt-2 mb-0 fw-bold text-warning"><fmt:formatNumber value="${user.totalDonatedAmount}" type="number"/> đ</h4>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card p-3 text-center border shadow-none h-100">
                            <small class="brand-primary uppercase fw-bold" style="font-size: 0.7rem;">QUYÊN GÓP</small>
                            <h5 class="mt-2 mb-0 fw-bold brand-primary">${user.campaignCount}</h5>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card p-3 text-center border shadow-none h-100 hover-bg-light transition">
                            <small class="brand-primary uppercase fw-bold" style="font-size: 0.7rem;">ĐANG THEO DÕI</small>
                            <h5 class="mt-2 mb-0 fw-bold brand-primary">${user.followingCount}</h5>
                        </div>
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
                            <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
                                <h5 class="fw-bold mb-0">Lịch sử quyên góp</h5>
                                <div class="d-flex gap-2 align-items-center">
                                    <div class="btn-group border rounded-pill p-1 bg-light">
                                        <button type="button" class="btn btn-sm rounded-pill px-3 active border-0" id="viewGridBtn" onclick="switchView('grid')">
                                            <i class="fas fa-th-large"></i>
                                        </button>
                                        <button type="button" class="btn btn-sm rounded-pill px-3 border-0" id="viewListBtn" onclick="switchView('list')">
                                            <i class="fas fa-list"></i>
                                        </button>
                                    </div>
                                    
                                    <div class="dropdown">
                                        <button type="button" class="btn btn-sm border rounded-pill px-3 bg-white fw-bold dropdown-toggle" data-bs-toggle="dropdown">
                                            <i class="fas fa-sort-amount-down me-1"></i> ${sort == 'asc' ? 'Cũ nhất' : 'Mới nhất'}
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end border-0 shadow-sm rounded-3 mt-2">
                                            <li><a class="dropdown-item small fw-bold ${sort == 'desc' ? 'text-primary' : ''}" href="?sort=desc&donationStatus=${donationStatus}&campaignStatus=${campaignStatus}">Mới nhất</a></li>
                                            <li><a class="dropdown-item small fw-bold ${sort == 'asc' ? 'text-primary' : ''}" href="?sort=asc&donationStatus=${donationStatus}&campaignStatus=${campaignStatus}">Cũ nhất</a></li>
                                        </ul>
                                    </div>

                                    <div class="dropdown">
                                        <button type="button" class="btn btn-sm border rounded-pill px-3 bg-white fw-bold dropdown-toggle" data-bs-toggle="dropdown">
                                            <i class="fas fa-filter me-1"></i> Lọc
                                        </button>
                                        <div class="dropdown-menu dropdown-menu-end p-3 border-0 shadow-lg rounded-4 mt-2" style="min-width: 250px;">
                                            <form action="" method="get">
                                                <input type="hidden" name="sort" value="${sort}">
                                                
                                                <div class="mb-3">
                                                    <label class="form-label smallest fw-bold text-muted text-uppercase">Tình trạng donate</label>
                                                    <select name="donationStatus" class="form-select form-select-sm rounded-pill px-3">
                                                        <option value="">Tất cả</option>
                                                        <option value="0" ${donationStatus == 0 ? 'selected' : ''}>Chờ xác nhận</option>
                                                        <option value="1" ${donationStatus == 1 ? 'selected' : ''}>Đã xác nhận</option>
                                                        <option value="2" ${donationStatus == 2 ? 'selected' : ''}>Đã từ chối</option>
                                                    </select>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label smallest fw-bold text-muted text-uppercase">Tình trạng chiến dịch</label>
                                                    <select name="campaignStatus" class="form-select form-select-sm rounded-pill px-3">
                                                        <option value="">Tất cả</option>
                                                        <option value="0" ${campaignStatus == 0 ? 'selected' : ''}>Mới tạo</option>
                                                        <option value="1" ${campaignStatus == 1 ? 'selected' : ''}>Đang chạy</option>
                                                        <option value="2" ${campaignStatus == 2 ? 'selected' : ''}>Đã kết thúc</option>
                                                        <option value="3" ${campaignStatus == 3 ? 'selected' : ''}>Đã đóng</option>
                                                    </select>
                                                </div>

                                                <div class="d-flex gap-2 mt-4">
                                                    <a href="?" class="btn btn-light btn-sm rounded-pill flex-grow-1 fw-bold text-muted">Xóa lọc</a>
                                                    <button type="submit" class="btn btn-brand-primary btn-sm rounded-pill flex-grow-1 fw-bold">Áp dụng</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <c:choose>
                                <c:when test="${empty donations}">
                                    <div class="text-center py-5 bg-light rounded-4">
                                        <p class="text-muted">Không tìm thấy bản ghi quyên góp nào phù hợp.</p>
                                        <c:if test="${not empty donationStatus || not empty campaignStatus}">
                                            <a href="?" class="btn btn-brand-primary rounded-pill btn-sm px-4">Xem tất cả</a>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div id="donationContainer" class="row g-4 view-grid">
                                        <c:forEach var="d" items="${donations}">
                                            <!-- Card Column -->
                                            <div class="col-md-6 donation-item">
                                                <div class="card border h-100 shadow-none history-card-refined p-4 position-relative" 
                                                     style="cursor: pointer;"
                                                     onclick="window.location.href='${pageContext.request.contextPath}/campaign/${d.campaignId}'">
                                                    <!-- Top Row: Campaign Info & Status -->
                                                    <div class="d-flex justify-content-between align-items-start mb-4">
                                                        <div class="d-flex align-items-center overflow-hidden">
                                                            <div class="campaign-icon-wrapper flex-shrink-0 me-3 bg-light rounded-3 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                                                <i class="fas fa-hand-holding-heart brand-primary fs-4"></i>
                                                            </div>
                                                            <div class="overflow-hidden">
                                                                <span class="text-decoration-none fw-bold text-dark text-truncate d-block mb-1" title="${d.campaignName}">
                                                                    ${d.campaignName}
                                                                </span>
                                                                <span class="badge ${d.status == 1 ? 'bg-success' : (d.status == 2 ? 'bg-danger' : 'bg-warning')} bg-opacity-10 ${d.status == 1 ? 'text-success' : (d.status == 2 ? 'text-danger' : 'text-warning')} rounded-pill px-2" style="font-size: 0.65rem;">
                                                                    <i class="fas ${d.status == 1 ? 'fa-check-circle' : (d.status == 2 ? 'fa-times-circle' : 'fa-clock')} me-1"></i>
                                                                    ${d.status == 1 ? 'Đã xác nhận' : (d.status == 2 ? 'Đã từ chối' : 'Chờ xác nhận')}
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Middle Row: Details Grid -->
                                                    <div class="row g-0 py-3 border-top border-bottom mb-3 stats-row">
                                                        <div class="col-4 border-end pe-2">
                                                            <small class="text-muted smallest d-block text-uppercase fw-bold mb-1">Thời gian</small>
                                                            <div class="small fw-bold text-dark text-nowrap">
                                                                <fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                                                            </div>
                                                        </div>
                                                        <div class="col-4 border-end px-2 text-center">
                                                            <small class="text-muted smallest d-block text-uppercase fw-bold mb-1">Hình thức</small>
                                                            <div class="small fw-bold text-dark text-truncate">${d.paymentMethodName}</div>
                                                        </div>
                                                        <div class="col-4 ps-2 text-end">
                                                            <small class="text-muted smallest d-block text-uppercase fw-bold mb-1">Số tiền</small>
                                                            <div class="small fw-bold brand-primary"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                        </div>
                                                    </div>

                                                    <!-- Bottom Row: Message & Identity -->
                                                    <div class="d-flex justify-content-between align-items-center mt-auto">
                                                        <div class="message-preview small text-muted text-truncate me-3" style="max-width: 70%;">
                                                            <i class="far fa-comment-alt me-1"></i> 
                                                            <c:choose>
                                                                <c:when test="${not empty d.message}">${d.message}</c:when>
                                                                <c:otherwise>Không có lời nhắn</c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="identity-indicator">
                                                            <c:choose>
                                                                <c:when test="${d.isAnonymous == 1}">
                                                                    <span class="smallest fw-bold text-secondary text-uppercase bg-light rounded px-2 py-1">Ẩn danh</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="smallest fw-bold brand-primary text-uppercase border border-success border-opacity-25 rounded px-2 py-1">Công khai</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
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
                                        <a href="${pageContext.request.contextPath}/#campaigns" class="btn btn-brand-primary rounded-pill btn-sm px-4">Khám phá ngay</a>
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
                                                            ${f.campaign.status == 1 ? 'Đang chạy' : (f.campaign.status == 2 ? 'Đã kết thúc' : 'Đã đóng')}
                                                        </span>
                                                        <c:if test="${f.receiveEmail == 1}"><i class="fas fa-bell brand-primary smallest" title="Nhận thông báo email"></i></c:if>
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

    <!-- Script for Tab & View Handling -->
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

        function switchView(view) {
            const container = document.getElementById('donationContainer');
            const gridBtn = document.getElementById('viewGridBtn');
            const listBtn = document.getElementById('viewListBtn');
            const items = document.querySelectorAll('.donation-item');

            if (view === 'grid') {
                container.classList.remove('flex-column');
                container.classList.add('row');
                items.forEach(item => {
                    item.classList.remove('col-12');
                    item.classList.add('col-md-6');
                });
                gridBtn.classList.add('active');
                listBtn.classList.remove('active');
            } else {
                container.classList.remove('row');
                container.classList.add('flex-column');
                items.forEach(item => {
                    item.classList.remove('col-md-6');
                    item.classList.add('col-12');
                });
                listBtn.classList.add('active');
                gridBtn.classList.remove('active');
            }
        }
    </script>
    <style>
        .nav-tabs-custom .nav-link.active::after {
            content: ""; position: absolute; bottom: -1px; left: 0; right: 0; height: 3px; background: var(--color-primary); border-radius: 3px;
        }
        .following-card:last-child { border-bottom: none !important; }
        .hover-bg-light:hover { background-color: #f8fafc; }
        .transition { transition: all 0.2s ease-in-out; }
        .object-fit-cover { object-fit: cover; }
        
        /* Refined History Card Styles */
        .history-card-refined {
            border-radius: 16px;
            transition: all 0.3s ease;
            background: white;
        }
        .history-card-refined:hover {
            border-color: var(--color-primary) !important;
            box-shadow: 0 10px 25px rgba(16, 185, 129, 0.1) !important;
            transform: translateY(-4px);
        }
        .campaign-icon-wrapper {
            background-color: rgba(16, 185, 129, 0.05);
        }
        .stats-row {
            background-color: #fcfdfd;
            margin-left: -1.5rem;
            margin-right: -1.5rem;
            padding-left: 1.5rem;
            padding-right: 1.5rem;
        }
        .btn-group .btn.active {
            background-color: white !important;
            color: var(--color-primary) !important;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }
        .dropdown-item:active {
            background-color: var(--color-primary);
        }
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
                            <div class="invalid-feedback">Vui lòng nhập địa chỉ email hợp lệ.</div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Số điện thoại</label>
                            <input type="tel" name="phoneNumber" class="form-control" value="${user.phoneNumber}">
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-bold">Địa chỉ</label>
                            <textarea name="address" class="form-control" rows="2">${user.address}</textarea>
                        </div>
                        <button type="submit" class="btn btn-brand-primary w-100 rounded-pill py-2">Lưu thay đổi</button>
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
