<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>${campaign.name} - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/assets/css/style.css'/>">
    <style>
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; scroll-behavior: smooth; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .campaign-title { font-size: 2.5rem; line-height: 1.2; letter-spacing: -0.5px; }
        .main-feature-img { width: 100%; height: 500px; object-fit: cover; border-radius: 24px; cursor: pointer; }
        .thumb-img { width: 100%; height: 80px; object-fit: cover; border-radius: 12px; cursor: pointer; opacity: 0.6; transition: 0.3s; border: 2px solid transparent; }
        .thumb-img:hover, .thumb-img.active { opacity: 1; border-color: var(--color-primary); }
        
        .donation-sidebar-card { border-radius: 24px; position: sticky; top: 20px; }
        .sticky-tab-bar { position: sticky; top: 0; background: white; z-index: 100; border-bottom: 1px solid #f1f5f9; margin-top: 40px; }
        .nav-tabs-custom .nav-link { border: none; color: #64748b; font-weight: 700; padding: 15px 25px; position: relative; font-size: 0.95rem; }
        .nav-tabs-custom .nav-link.active { color: var(--color-primary); background: transparent; }
        .nav-tabs-custom .nav-link.active::after { content: ""; position: absolute; bottom: 0; left: 0; right: 0; height: 3px; background: var(--color-primary); border-radius: 3px; }
        
        .donor-container { background: #fff; border: 1px solid #f1f5f9; border-radius: 20px; overflow: hidden; }
        .donor-row { padding: 15px 20px; display: flex; align-items: center; border-bottom: 1px solid #f1f5f9; transition: 0.2s; }
        .donor-row:hover { background: #f8fafc; }
        .sponsor-list { background: rgba(255,255,255,0.1); border-radius: 16px; padding: 15px; margin-bottom: 20px; border: 1px solid rgba(255,255,255,0.2); }
        .brand-primary { color: var(--color-primary) !important; }
        .bg-brand-primary { background-color: var(--color-primary) !important; }

        .btn-brand-primary { 
            background-color: var(--color-primary) !important; 
            border-color: var(--color-primary) !important; 
            color: white !important; 
        }
        .btn-brand-primary:hover, .btn-brand-primary:active, .btn-brand-primary.active { 
            background-color: #059669 !important;
            border-color: #059669 !important;
        }
        
        .btn-outline-brand-primary { 
            border-color: var(--color-primary) !important; 
            color: var(--color-primary) !important; 
            background: transparent !important;
        }
        .btn-outline-brand-primary:hover, .btn-outline-brand-primary:active, .btn-outline-brand-primary.active { 
            background-color: var(--color-primary) !important; 
            color: white !important; 
        }

        .mobile-donate-bar { 
            position: fixed; bottom: 0; left: 0; right: 0; 
            background: white; padding: 15px 25px; 
            box-shadow: 0 -10px 30px rgba(0,0,0,0.08); 
            z-index: 1030; display: none;
            border-top-left-radius: 20px; border-top-right-radius: 20px;
        }

        @media (max-width: 991.98px) {
            .campaign-title { font-size: 1.75rem; }
            .main-feature-img { height: 300px; border-radius: 16px; }
            .donation-sidebar-card { position: static; margin-bottom: 30px; box-shadow: none !important; border: 1px solid #f1f5f9; }
            .mobile-donate-bar { display: flex; align-items: center; justify-content: space-between; gap: 15px; }
            .scrollable-main { padding-bottom: 100px; } /* Space for fixed bar */
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <jsp:include page="fragments/donation-modals.jsp" />

        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0 border-end" style="z-index: 1035;">
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <!-- Main Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
                <div class="p-3 p-md-4 p-xl-5">
                    
                    <!-- Header Info -->
                    <div class="mb-4">
                        <nav aria-label="breadcrumb" class="mb-3">
                            <ol class="breadcrumb smallest fw-bold text-uppercase">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-muted">Trang chủ</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/#campaigns" class="text-decoration-none text-muted">Chiến dịch</a></li>
                                <li class="breadcrumb-item active brand-primary" aria-current="page">${campaign.code}</li>
                            </ol>
                        </nav>
                        <h1 class="campaign-title fw-bold mb-3 text-dark">${campaign.name}</h1>
                        <div class="d-flex align-items-center flex-wrap gap-3 text-muted small">
                            <span class="d-flex align-items-center"><i class="fas fa-heart text-danger me-2"></i> Quyên góp cộng đồng</span>
                            <span class="d-none d-sm-inline">|</span>
                            <span class="d-flex align-items-center"><i class="far fa-calendar-alt me-2"></i> Ngày đăng: ${campaign.startDate}</span>
                        </div>
                    </div>

                    <div class="row g-4 g-xl-5 mb-5">
                        <!-- Left: Visual Content -->
                        <div class="col-lg-8">
                            <div id="campaignCarousel" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner rounded-4 shadow-sm bg-light">
                                    <c:set var="mainImg" value="${not empty campaign.imageUrl ? campaign.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'}"/>
                                    <div class="carousel-item active">
                                        <img src="${mainImg}" class="main-feature-img" onclick="openLightbox('${mainImg}')">
                                    </div>
                                    <c:if test="${not empty campaign.galleryUrls}">
                                        <c:forEach var="url" items="${campaign.galleryUrls.split(',')}">
                                            <div class="carousel-item">
                                                <img src="${url.trim()}" class="main-feature-img" onclick="openLightbox('${url.trim()}')">
                                            </div>
                                        </c:forEach>
                                    </c:if>
                                </div>
                                <button class="carousel-control-prev" type="button" data-bs-target="#campaignCarousel" data-bs-slide="prev"><span class="carousel-control-prev-icon"></span></button>
                                <button class="carousel-control-next" type="button" data-bs-target="#campaignCarousel" data-bs-slide="next"><span class="carousel-control-next-icon"></span></button>
                            </div>

                            <!-- Thumbnails -->
                            <div class="row g-2 mt-3 d-none d-sm-flex">
                                <div class="col-2">
                                    <img src="${mainImg}" class="thumb-img active" data-bs-target="#campaignCarousel" data-bs-slide-to="0">
                                </div>
                                <c:if test="${not empty campaign.galleryUrls}">
                                    <c:forEach var="url" items="${campaign.galleryUrls.split(',')}" varStatus="status">
                                        <div class="col-2">
                                            <img src="${url.trim()}" class="thumb-img" data-bs-target="#campaignCarousel" data-bs-slide-to="${status.index + 1}">
                                        </div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>

                        <!-- Right: Action Sidebar -->
                        <div class="col-lg-4">
                            <div class="donation-sidebar-card shadow-lg p-4 p-xl-5">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h6 class="fw-bold mb-0 text-uppercase text-50">Thông tin quyên góp</h6>
                                    <div class="d-flex gap-2">
                                        <c:choose>
                                            <c:when test="${following}">
                                                <form action="${pageContext.request.contextPath}/campaign/unfollow" method="post" class="m-0">
                                                    <input type="hidden" name="campaignId" value="${campaign.id}">
                                                    <button type="submit" class="btn btn-sm btn-brand-primary rounded-pill px-3 shadow-sm active" title="Đang theo dõi">
                                                        <i class="fas fa-bookmark me-1"></i> <span class="smallest fw-bold">ĐÃ THEO DÕI</span>
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/campaign/follow" method="post" class="m-0">
                                                    <input type="hidden" name="campaignId" value="${campaign.id}">
                                                    <button type="submit" class="btn btn-sm btn-outline-brand-primary rounded-pill px-3 shadow-sm" title="Theo dõi chiến dịch">
                                                        <i class="far fa-bookmark me-1"></i> <span class="smallest fw-bold">THEO DÕI</span>
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="https://www.facebook.com/sharer/sharer.php?u=${requestScope['javax.servlet.forward.request_uri']}" 
                                           target="_blank" class="btn btn-sm btn-outline-brand-primary rounded-pill px-3 shadow-sm" title="Chia sẻ">
                                            <i class="fab fa-facebook-f me-1"></i> <span class="smallest fw-bold">CHIA SẺ</span>
                                        </a>
                                    </div>
                                </div>

                                <div class="sponsor-list">
                                    <c:forEach var="cp" items="${campaign.companions}">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="${cp.logoUrl}" class="rounded border bg-white me-2" width="32" height="32" style="object-fit: contain;">
                                            <div class="overflow-hidden"><div class="smallest text-50">Đồng hành</div><div class="fw-bold smallest text-truncate">${cp.name}</div></div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="funding-stats mt-4">
                                    <div class="mb-3">
                                        <div class="fs-2 fw-bold brand-primary"><fmt:formatNumber value="${campaign.currentMoney}" type="number"/>đ</div>
                                        <div class="text-50 small fw-medium">đã đạt được mục tiêu <fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</div>
                                    </div>
                                    
                                    <c:set var="target" value="${campaign.targetMoney.doubleValue() > 0 ? campaign.targetMoney : 1}"/>
                                    <c:set var="percent" value="${(campaign.currentMoney.doubleValue() / target.doubleValue()) * 100}"/>
                                    
                                    <div class="progress liquid-progress-container" style="height: 24px; background: rgba(255,255,255,0.1); border: none;">
                                        <div class="progress-bar liquid-progress-fill" style="width: ${percent > 100 ? 100 : percent}%">
                                            <div class="liquid-wave"></div>
                                            <div class="liquid-wave"></div>
                                            <div class="liquid-text text-white"><fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%</div>
                                        </div>
                                    </div>

                                    <div class="row g-0 mt-4 py-3 border-top border-bottom border-white border-opacity-10 text-center">
                                        <div class="col-4 border-end border-white border-opacity-10">
                                            <div class="smallest text-50 text-uppercase fw-bold mb-1">Lượt quyên</div>
                                            <div class="fw-bold">${donationCount}</div>
                                        </div>
                                        <div class="col-4 border-end border-white border-opacity-10">
                                            <div class="smallest text-50 text-uppercase fw-bold mb-1">Đạt được</div>
                                            <div class="fw-bold"><fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%</div>
                                        </div>
                                        <div class="col-4">
                                            <div class="smallest text-50 text-uppercase fw-bold mb-1">Còn lại</div>
                                            <div class="fw-bold">${daysRemaining} ngày</div>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${empty sessionScope.loggedInUser or sessionScope.loggedInUser.role.roleName != 'ADMIN'}">
                                    <c:choose>
                                        <c:when test="${campaign.status == STATUS.CAMPAIGN_ONGOING}">
                                            <button class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold mt-4 shadow-lg border-0" data-bs-toggle="modal" data-bs-target="#donateModal">QUYÊN GÓP NGAY</button>
                                        </c:when>
                                        <c:when test="${campaign.status == STATUS.CAMPAIGN_COMPLETED}">
                                            <button class="btn btn-secondary w-100 py-3 rounded-pill fw-bold mt-4 disabled" style="cursor: not-allowed;">CHIẾN DỊCH ĐÃ KẾT THÚC</button>
                                        </c:when>
                                        <c:when test="${campaign.status == STATUS.CAMPAIGN_CLOSED}">
                                            <button class="btn btn-secondary w-100 py-3 rounded-pill fw-bold mt-4 disabled">CHIẾN DỊCH ĐÃ ĐÓNG</button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="btn btn-outline-light w-100 py-3 rounded-pill fw-bold mt-4 disabled opacity-50">SẮP DIỄN RA</button>
                                        </c:otherwise>
                                    </c:choose>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <!-- Tabs Navigation -->
                    <div class="sticky-tab-bar">
                        <ul class="nav nav-tabs nav-tabs-custom">
                            <li class="nav-item"><a class="nav-link active" href="#story">Hoàn cảnh</a></li>
                            <li class="nav-item"><a class="nav-link" href="#details">Nội dung chiến dịch</a></li>
                            <li class="nav-item"><a class="nav-link" href="#donors">Nhà hảo tâm</a></li>
                        </ul>
                    </div>

                    <div class="row g-5 mt-2">
                        <div class="col-lg-8">
                            <div class="tab-content">
                                <!-- Story Tab -->
                                <div class="py-4" id="story">
                                    <h4 class="fw-bold mb-4 d-flex align-items-center"><i class="fas fa-history brand-primary me-2"></i> Hoàn cảnh</h4>
                                    <div class="rich-text-content" style="line-height: 1.8; color: #374151; font-size: 1.1rem;">
                                        <c:choose>
                                            <c:when test="${not empty campaign.background}">${campaign.background}</c:when>
                                            <c:otherwise><p class="text-muted italic">Thông tin hoàn cảnh đang được cập nhật...</p></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <!-- Content Tab -->
                                <div class="py-5 border-top" id="details">
                                    <h4 class="fw-bold mb-4 d-flex align-items-center"><i class="fas fa-file-alt brand-primary me-2"></i> Nội dung chiến dịch</h4>
                                    <div class="p-4 bg-light rounded-4 mb-4 border border-opacity-10 border-dark">
                                        <div class="row row-cols-2 row-cols-md-3 g-3">
                                            <div><div class="smallest text-muted text-uppercase fw-bold">Mã dự án</div><div class="fw-bold">${campaign.code}</div></div>
                                            <div><div class="smallest text-muted text-uppercase fw-bold">Mục tiêu</div><div class="fw-bold text-primary"><fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</div></div>
                                            <div><div class="smallest text-muted text-uppercase fw-bold">Trạng thái</div>
                                                <c:choose>
                                                    <c:when test="${campaign.status == STATUS.CAMPAIGN_NEW}"><span class="badge bg-info">Mới tạo</span></c:when>
                                                    <c:when test="${campaign.status == STATUS.CAMPAIGN_ONGOING}"><span class="badge bg-success">Đang diễn ra</span></c:when>
                                                    <c:when test="${campaign.status == STATUS.CAMPAIGN_COMPLETED}"><span class="badge bg-warning text-dark">Đã kết thúc</span></c:when>
                                                    <c:otherwise><span class="badge bg-secondary">Đã đóng</span></c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="rich-text-content ql-editor p-0" style="white-space: pre-wrap; line-height: 1.8; color: #374151; font-size: 1.1rem;">
                                        <c:choose>
                                            <c:when test="${not empty campaign.content}">${campaign.content}</c:when>
                                            <c:otherwise><p class="text-muted italic">Nội dung chi tiết đang được cập nhật...</p></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Donors Tab -->
                                <div class="py-5 border-top" id="donors">
                                    <h4 class="fw-bold mb-4 d-flex align-items-center"><i class="fas fa-users brand-primary me-2"></i> Nhà hảo tâm</h4>
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <div class="donor-container h-100 shadow-sm">
                                                <div class="p-3 bg-light fw-bold smallest text-muted text-uppercase">Hàng đầu</div>
                                                <c:forEach var="d" items="${topDonors10}" varStatus="loop" end="4">
                                                    <div class="donor-row">
                                                        <div class="fw-bold brand-primary me-3" style="width:20px">${loop.index + 1}</div>
                                                        <div class="flex-grow-1 text-truncate">
                                                            <strong>${d.donorName}</strong>
                                                            <div class="smallest text-muted"><fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="p" type="both" /><fmt:formatDate value="${p}" pattern="dd/MM/yyyy" /></div>
                                                        </div>
                                                        <div class="fw-bold text-dark"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty topDonors10}"><div class="p-4 text-center text-muted smallest">Chưa có dữ liệu</div></c:if>
                                                <button class="btn btn-link w-100 smallest fw-bold text-decoration-none py-3 border-top" data-bs-toggle="modal" data-bs-target="#topDonorsModal">XEM TẤT CẢ</button>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="donor-container h-100 shadow-sm">
                                                <div class="p-3 bg-light fw-bold smallest text-muted text-uppercase">Mới nhất</div>
                                                <c:forEach var="d" items="${recentDonors10}" varStatus="loop" end="4">
                                                    <div class="donor-row">
                                                        <div class="fw-bold brand-primary me-3" style="width:20px">${loop.index + 1}</div>
                                                        <div class="flex-grow-1 text-truncate">
                                                            <strong>${d.donorName}</strong>
                                                            <div class="smallest text-muted"><fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="p" type="both" /><fmt:formatDate value="${p}" pattern="dd/MM/yyyy" /></div>
                                                        </div>
                                                        <div class="fw-bold text-dark"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty recentDonors10}"><div class="p-4 text-center text-muted smallest">Chưa có dữ liệu</div></c:if>
                                                <button class="btn btn-link w-100 smallest fw-bold text-decoration-none py-3 border-top" data-bs-toggle="modal" data-bs-target="#recentDonorsModal">XEM TẤT CẢ</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Sidebar: Ongoing Campaigns -->
                        <div class="col-lg-4">
                            <div class="sticky-top d-none d-lg-block" style="top: 80px;">
                                <h5 class="fw-bold mb-4">Dự án đang diễn ra</h5>
                                <c:forEach var="ongoing" items="${ongoingCampaigns}">
                                    <div class="mb-4">
                                        <c:set var="campaign" value="${ongoing}" scope="request"/><c:set var="isCompact" value="true" scope="request"/>
                                        <jsp:include page="fragments/donation-card.jsp"/>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <!-- Mobile Fixed Bottom Action -->
    <div class="mobile-donate-bar shadow-lg">
        <div class="flex-grow-1">
            <div class="smallest text-muted text-uppercase fw-bold">Hiện đạt được</div>
            <div class="fw-bold brand-primary fs-5"><fmt:formatNumber value="${campaign.currentMoney}" type="number"/>đ</div>
        </div>
        <c:if test="${empty sessionScope.loggedInUser or sessionScope.loggedInUser.role.roleName != 'ADMIN'}">
            <button class="btn btn-brand-primary rounded-pill px-4 py-2 fw-bold" 
                    data-bs-toggle="modal" data-bs-target="#donateModal" 
                    ${campaign.status != STATUS.CAMPAIGN_ONGOING ? 'disabled' : ''}>
                QUYÊN GÓP
            </button>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        // Smooth scrolling for tabs
        document.querySelectorAll('.nav-tabs-custom .nav-link').forEach(link => {
            link.addEventListener('click', e => {
                e.preventDefault();
                const target = document.querySelector(link.getAttribute('href'));
                const scrollable = document.querySelector('.scrollable-main');
                if (target && scrollable) {
                    scrollable.scrollTo({ top: target.offsetTop - 80, behavior: 'smooth' });
                    document.querySelectorAll('.nav-tabs-custom .nav-link').forEach(l => l.classList.remove('active'));
                    link.classList.add('active');
                }
            });
        });

        // Carousel Sync
        const carouselEl = document.getElementById('campaignCarousel');
        if (carouselEl) {
            const carousel = new bootstrap.Carousel(carouselEl);
            const thumbs = document.querySelectorAll('.thumb-img');
            thumbs.forEach((t, i) => t.addEventListener('click', () => carousel.to(i)));
            carouselEl.addEventListener('slide.bs.carousel', e => {
                thumbs.forEach(t => t.classList.remove('active'));
                thumbs[e.to].classList.add('active');
            });
        }

        function openLightbox(src) {
            const lbImg = document.getElementById('lightboxImg');
            if(lbImg) {
                lbImg.src = src;
                new bootstrap.Modal(document.getElementById('lightboxModal')).show();
            }
        }
    </script>
</body>
</html>
