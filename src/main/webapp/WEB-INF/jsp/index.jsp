<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - CharityDonation</title>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="/assets/css/style.css">
    <style>
        html { scroll-behavior: smooth; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        
        .brand-primary { color: var(--color-primary) !important; }
        .bg-brand-primary { background-color: var(--color-primary) !important; }

        /* Section 1: Hero Banner */
        .hero-banner { border-radius: 24px; margin: 20px; overflow: hidden; box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1); }
        .carousel-item { padding: 80px 40px; min-height: 450px; }
        .slide-1 { background: linear-gradient(135deg, #059669 0%, #064e3b 100%); }
        .slide-2 { background: linear-gradient(135deg, #2563eb 0%, #1e3a8a 100%); }
        .slide-3 { background: linear-gradient(135deg, #7c3aed 0%, #4c1d95 100%); }
        .hero-title { font-size: 3.2rem; line-height: 1.1; color: white; letter-spacing: -1px; }

        /* Philosophy Section - Classic Layout */
        .phil-item { margin-bottom: 40px; transition: 0.3s; }
        .phil-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; margin-bottom: 15px; }
        .phil-center-img { width: 100%; border-radius: 50%; border: 8px solid #f8fafc; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); }
        
        .phil-expand-content { 
            max-height: 0; overflow: hidden; opacity: 0; 
            transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1); 
            background: linear-gradient(to bottom, #fff, #f8fafc);
            border-radius: 24px;
        }
        .phil-expand-content.show { max-height: 1000px; opacity: 1; padding: 40px; margin-top: 30px; }

        /* Cards & Stats */
        .stat-item { padding: 25px; border-radius: 20px; background: white; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.05); }
        .stat-value { font-size: 1.75rem; font-weight: 800; color: var(--color-primary); }
        /* Partners */
        .partner-card { 
            background: #fff; border-radius: 20px; padding: 30px; text-align: center; 
            border: 1px solid #f1f5f9; transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.02);
        }
        .partner-card:hover { 
            transform: translateY(-10px); 
            box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1); 
            border-color: var(--color-primary); 
        }
        .partner-logo { 
            height: 60px; max-width: 100%; object-fit: contain; 
            filter: grayscale(1); transition: 0.4s; margin-bottom: 15px; 
            opacity: 0.6; 
        }
        .partner-card:hover .partner-logo { 
            filter: grayscale(0); 
            opacity: 1; 
            transform: scale(1.15); 
        }
        .partner-name { font-size: 0.9rem; color: #64748b; font-weight: 600; transition: 0.3s; }
        .partner-card:hover .partner-name { color: var(--color-primary); }
        /* FAQ Redesign */
        .faq-section { background-color: #f8fafc; padding: 100px 0; }
        .faq-card { background: white; border-radius: 20px; border: none; margin-bottom: 24px; transition: all 0.3s ease; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02); }
        .faq-btn { width: 100%; text-align: left; padding: 25px !important; background: transparent !important; border: none !important; display: flex; align-items: center; gap: 15px; color: #1e293b !important; font-weight: 700 !important; box-shadow: none !important; }
        .faq-icon-wrapper { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; flex-shrink: 0; }
        .faq-body { padding: 0 25px 30px 85px !important; color: #64748b; font-size: 0.95rem; line-height: 1.7; }
        
        .bg-soft-blue { background: #eff6ff; color: #3b82f6; }
        .bg-soft-green { background: #f0fdf4; color: #22c55e; }
        .bg-soft-purple { background: #faf5ff; color: #a855f7; }
        .bg-soft-orange { background: #fff7ed; color: #f97316; }
        .bg-soft-red { background: #fef2f2; color: #ef4444; }
        .btn-view-more { border: 2px solid var(--color-primary); color: var(--color-primary); font-weight: 700; border-radius: 50rem; padding: 12px 40px; transition: 0.3s; background: transparent; }
        .btn-view-more:hover { background: var(--color-primary); color: white; }

        /* Updated Expand Animation */
        .expandable-list {
            display: grid;
            grid-template-rows: 0fr;
            transition: grid-template-rows 0.5s linear;
            overflow: hidden;
        }
        .expandable-list.expanded {
            grid-template-rows: 1fr;
        }
        .expandable-content {
            min-height: 0;
        }

        /* Dropdown Hover Style */
        .dropdown-item:hover {
            background-color: var(--color-primary) !important;
            color: white !important;
        }
        .dropdown-item.active {
            background-color: var(--color-primary) !important;
            color: white !important;
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <!-- Modals -->
        <!-- Donation Modal -->
        <div class="modal fade" id="donateModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0 bg-brand-primary text-white p-4">
                        <h5 class="modal-title fw-bold">QUYÊN GÓP CHO CHIẾN DỊCH</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <h6 id="donateCampaignName" class="fw-bold brand-primary"></h6>
                        </div>
                        <form id="donateForm" action="${pageContext.request.contextPath}/campaign/donate" method="post" onsubmit="return validateDonateForm(this)">
                            <input type="hidden" name="campaignId" id="donateCampaignId" value="">
                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger small py-2 mb-3">${error}</div>
                            </c:if>
                            <c:if test="${not empty param.error}">
                                <div class="alert alert-danger small py-2 mb-3">${param.error}</div>
                            </c:if>

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted text-uppercase">Số tiền quyên góp (VNĐ)</label>
                                <input type="number" name="amount" class="form-control form-control-lg rounded-pill px-4" placeholder="Nhập số tiền..." required min="1000">
                            </div>

                            <c:if test="${empty sessionScope.loggedInUser}">
                                <div class="mb-4 bg-light p-3 rounded-4 border">
                                    <h6 class="fw-bold mb-3 small text-uppercase text-muted">Thông tin người quyên góp</h6>
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <input type="text" name="fullName" class="form-control" placeholder="Họ và tên (Tùy chọn)">
                                        </div>
                                        <div class="col-md-6">
                                            <input type="email" name="email" class="form-control" placeholder="Email (Bắt buộc)" required>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="text" name="phone" class="form-control" placeholder="Số điện thoại (Bắt buộc)" required>
                                            <div class="invalid-feedback ps-3">Vui lòng nhập số điện thoại để tiếp tục.</div>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="text" name="address" class="form-control" placeholder="Địa chỉ (Tùy chọn)">
                                        </div>
                                        <div class="col-12">
                                            <textarea name="message" class="form-control" rows="2" placeholder="Lời nhắn (Tùy chọn)"></textarea>
                                        </div>
                                    </div>
                                    <div class="mt-2 small text-muted">
                                        <i class="fas fa-info-circle me-1"></i> Nhập email để nhận biên lai xác nhận. Nếu email đã được đăng ký, vui lòng đăng nhập.
                                    </div>
                                </div>
                            </c:if>

                            <c:if test="${not empty sessionScope.loggedInUser}">
                                <div class="mb-4">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Lời nhắn gửi đến chiến dịch</label>
                                    <textarea name="message" class="form-control rounded-4 px-4 py-3" rows="2" placeholder="Nhập lời nhắn của bạn (Tùy chọn)..."></textarea>
                                </div>
                            </c:if>

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted text-uppercase d-flex justify-content-between">
                                    <span>Phương thức thanh toán</span>
                                    <a href="javascript:void(0)" id="bankInfoLink" class="text-decoration-none" style="font-size: 0.75rem;" onclick="showBankInfo()">
                                        <i class="fas fa-info-circle me-1"></i>Xem hướng dẫn
                                    </a>
                                </label>
                                <select name="paymentMethodId" id="paymentMethodSelect" class="form-select form-select-lg rounded-pill px-4" required onchange="handlePaymentMethodChange(this)">
                                    <option value="" selected disabled>Chọn phương thức thanh toán...</option>
                                    <c:forEach var="pm" items="${paymentMethods}">
                                        <option value="${pm.id}" data-provider="${pm.provider}">${pm.methodName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="mb-4">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" name="isAnonymous" value="1" id="anonymousCheck">
                                    <label class="form-check-label small fw-bold" for="anonymousCheck">Quyên góp ẩn danh (Không hiện tên trên danh sách)</label>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold shadow">XÁC NHẬN QUYÊN GÓP</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bank Transfer Instructions Modal -->
        <div class="modal fade" id="bankInstructionsModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0 bg-brand-primary text-white p-4">
                        <h5 class="modal-title fw-bold">HƯỚNG DẪN CHUYỂN KHOẢN</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4 text-center">
                        <p class="mb-4">Vui lòng thực hiện chuyển khoản theo thông tin dưới đây để hoàn tất quyên góp:</p>
                        
                        <div class="p-4 bg-light rounded-4 mb-4 text-start">
                            <div class="mb-3">
                                <label class="smallest text-muted text-uppercase fw-bold d-block">Ngân hàng</label>
                                <div class="fw-bold fs-5" id="instrBankName">MB Bank (Quân Đội)</div>
                            </div>
                            <div class="mb-3">
                                <label class="smallest text-muted text-uppercase fw-bold d-block">Số tài khoản</label>
                                <div class="fw-bold fs-4 brand-primary" id="instrAccountNum">0987654321</div>
                            </div>
                            <div class="mb-3">
                                <label class="smallest text-muted text-uppercase fw-bold d-block">Chủ tài khoản</label>
                                <div class="fw-bold" id="instrAccountName">TẠ NGỌC PHƯƠNG</div>
                            </div>
                            <div class="mb-0">
                                <label class="smallest text-muted text-uppercase fw-bold d-block">Nội dung chuyển khoản (BẮT BUỘC)</label>
                                <div class="p-3 bg-white border border-primary border-dashed rounded-3 mt-1">
                                    <span class="fw-bold fs-4 text-danger" id="instrCode">QG123456</span>
                                    <button class="btn btn-sm btn-brand-secondary float-end" onclick="copyToClipboard('instrCode')">Sao chép</button>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold" data-bs-dismiss="modal">ĐÃ HIỂU</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row flex-nowrap">
            <div class="col-auto p-0 border-end" style="z-index: 1000;">
                <c:set var="currentPage" value="home" scope="request"/>
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
                
                <!-- 1. Hero Carousel -->
                <section id="hero" class="hero-banner">
                    <div id="heroCarousel" class="carousel slide carousel-fade" data-bs-ride="carousel" data-bs-interval="5000">
                        <div class="carousel-indicators">
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="0" class="active"></button>
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="1"></button>
                            <button type="button" data-bs-target="#heroCarousel" data-bs-slide-to="2"></button>
                        </div>
                        <div class="carousel-inner">
                            <div class="carousel-item active slide-1">
                                <div class="row align-items-center h-100">
                                    <div class="col-md-8">
                                        <span class="badge bg-warning text-dark mb-3 px-3 py-2 rounded-pill fw-bold">#1 Nền tảng quyên góp</span>
                                        <h1 class="hero-title fw-bold mb-4">TRIỆU NGƯỜI CHUNG TAY QUYÊN GÓP<br><span class="text-warning">Vì một Việt Nam tốt đẹp hơn!</span></h1>
                                        <p class="lead text-white opacity-75 mb-5 fs-5">Mỗi đóng góp của bạn, dù nhỏ nhất, cũng góp phần thắp sáng hy vọng cho những hoàn cảnh khó khăn.</p>
                                        <a href="#campaigns" class="btn btn-warning rounded-pill px-5 py-3 fw-bold shadow-lg">QUYÊN GÓP NGAY</a>
                                    </div>
                                    <div class="col-md-4 d-none d-md-block text-center"><i class="fas fa-hand-holding-heart fa-10x text-white opacity-25"></i></div>
                                </div>
                            </div>
                            <div class="carousel-item slide-2">
                                <div class="row align-items-center h-100">
                                    <div class="col-md-8">
                                        <span class="badge bg-info text-white mb-3 px-3 py-2 rounded-pill fw-bold">Minh bạch & Tin cậy</span>
                                        <h1 class="hero-title fw-bold mb-4">CÔNG KHAI 100% GIAO DỊCH<br><span class="text-info">Niềm tin đặt đúng chỗ!</span></h1>
                                        <p class="lead text-white opacity-75 mb-5 fs-5">Báo cáo thời gian thực giúp bạn theo dõi từng đồng quyên góp được chuyển đến đúng đối tượng.</p>
                                        <a href="#intro" class="btn btn-info text-white rounded-pill px-5 py-3 fw-bold shadow-lg">XEM BÁO CÁO</a>
                                    </div>
                                    <div class="col-md-4 d-none d-md-block text-center"><i class="fas fa-shield-check fa-10x text-white opacity-25"></i></div>
                                </div>
                            </div>
                            <div class="carousel-item slide-3">
                                <div class="row align-items-center h-100">
                                    <div class="col-md-8">
                                        <span class="badge bg-danger text-white mb-3 px-3 py-2 rounded-pill fw-bold">Kết nối yêu thương</span>
                                        <h1 class="hero-title fw-bold mb-4">HÀNH TRÌNH CỦA NHỮNG TRÁI TIM<br><span class="text-light">Lan tỏa nhân ái mỗi ngày</span></h1>
                                        <p class="lead text-white opacity-75 mb-5 fs-5">Tham gia cộng đồng hàng triệu nhà hảo tâm để cùng nhau tạo nên những thay đổi kỳ diệu.</p>
                                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-light brand-primary rounded-pill px-5 py-3 fw-bold shadow-lg">THAM GIA NGAY</a>
                                    </div>
                                    <div class="col-md-4 d-none d-md-block text-center"><i class="fas fa-users-medical fa-10x text-white opacity-25"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 2. Intro & Stats Section (RESTORED LAYOUT) -->
                <section id="intro" class="py-5 px-5 mt-4">
                    <div class="row align-items-center g-5">
                        <div class="col-lg-7">
                            <h2 class="fw-bold mb-4 text-dark display-6">Nền tảng kết nối nhân ái</h2>
                            <p class="text-muted mb-5 fs-5">Chúng tôi mang sứ mệnh cầu nối, giúp các nhà hảo tâm dễ dàng tiếp cận và hỗ trợ các hoàn cảnh khó khăn một cách minh bạch, an toàn và nhanh chóng nhất.</p>
                            <div class="row g-4 mb-5">
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><span class="stat-value">1.2K+</span><div class="text-muted smallest fw-bold">DỰ ÁN</div></div></div>
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><span class="stat-value">106B+</span><div class="text-muted smallest fw-bold">VNĐ</div></div></div>
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><span class="stat-value">1.5M+</span><div class="text-muted smallest fw-bold">NHÀ HẢO TÂM</div></div></div>
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><span class="stat-value">63</span><div class="text-muted smallest fw-bold">TỈNH THÀNH</div></div></div>
                            </div>
                            <div class="d-flex gap-3">
                                <a href="#campaigns" class="btn btn-brand-primary rounded-pill px-4 py-2 fw-bold shadow-sm">Khám phá chiến dịch</a>
                                <a href="#philosophy" class="btn btn-brand-secondary rounded-pill px-4 py-2 fw-bold">Sứ mệnh của chúng tôi</a>
                            </div>
                        </div>
                        <div class="col-lg-5 text-center">
                            <div class="position-relative p-3">
                                <!-- Decorative element behind image -->
                                <div class="position-absolute top-0 start-0 w-100 h-100 bg-brand-primary opacity-10 rounded-4" style="transform: rotate(-3deg); z-index: 0;"></div>
                                <img src="https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80" 
                                     class="img-fluid rounded-4 shadow-lg position-relative" 
                                     style="z-index: 1;" 
                                     alt="Charity Stats">
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 3. Campaigns Section -->
                <section id="campaigns" class="py-5 bg-light px-5">
                    <div class="d-flex justify-content-between align-items-center mb-5">
                        <h2 class="fw-bold section-title mb-0">Chiến dịch quyên góp</h2>
                        <div class="dropdown">
                            <button class="btn btn-white border rounded-pill px-4 dropdown-toggle fw-bold shadow-sm" type="button" data-bs-toggle="dropdown">
                                <i class="fas fa-filter me-2 brand-primary"></i>
                                <c:choose>
                                    <c:when test="${currentStatus == STATUS.CAMPAIGN_NEW}">Mới tạo</c:when>
                                    <c:when test="${currentStatus == STATUS.CAMPAIGN_ONGOING}">Đang diễn ra</c:when>
                                    <c:when test="${currentStatus == STATUS.CAMPAIGN_COMPLETED}">Đã kết thúc</c:when>
                                    <c:when test="${currentStatus == STATUS.CAMPAIGN_CLOSED}">Đã đóng</c:when>
                                    <c:otherwise>Tất cả trạng thái</c:otherwise>
                                </c:choose>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end border-0 shadow-lg rounded-4 mt-2">
                                <li><a class="dropdown-item py-2 px-4 small fw-bold ${currentStatus == STATUS.CAMPAIGN_ONGOING ? 'active' : ''}" href="${pageContext.request.contextPath}/?status=${STATUS.CAMPAIGN_ONGOING}#campaigns">Đang diễn ra</a></li>
                                <li><a class="dropdown-item py-2 px-4 small fw-bold ${currentStatus == STATUS.CAMPAIGN_NEW ? 'active' : ''}" href="${pageContext.request.contextPath}/?status=${STATUS.CAMPAIGN_NEW}#campaigns">Mới tạo</a></li>
                                <li><a class="dropdown-item py-2 px-4 small fw-bold ${currentStatus == STATUS.CAMPAIGN_COMPLETED ? 'active' : ''}" href="${pageContext.request.contextPath}/?status=${STATUS.CAMPAIGN_COMPLETED}#campaigns">Đã kết thúc</a></li>
                                <li><a class="dropdown-item py-2 px-4 small fw-bold ${currentStatus == STATUS.CAMPAIGN_CLOSED ? 'active' : ''}" href="${pageContext.request.contextPath}/?status=${STATUS.CAMPAIGN_CLOSED}#campaigns">Đã đóng</a></li>
                            </ul>
                        </div>
                    </div>
                    
                    <!-- Initial 9 Campaigns -->
                    <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                        <c:forEach var="campaign" items="${campaigns}" varStatus="loop">
                            <c:if test="${loop.index < 9}">
                                <div class="col">
                                    <c:set var="campaign" value="${campaign}" scope="request"/><c:set var="isCompact" value="false" scope="request"/>
                                    <jsp:include page="fragments/donation-card.jsp"/>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <!-- Hidden Campaigns with Animation -->
                    <c:if test="${campaigns.size() > 9}">
                        <div id="campaignExpand" class="expandable-list mt-4">
                            <div class="expandable-content">
                                <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                                    <c:forEach var="campaign" items="${campaigns}" varStatus="loop">
                                        <c:if test="${loop.index >= 9}">
                                            <div class="col">
                                                <c:set var="campaign" value="${campaign}" scope="request"/><c:set var="isCompact" value="false" scope="request"/>
                                                <jsp:include page="fragments/donation-card.jsp"/>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        <div class="text-center mt-5"><button id="btnMoreCampaigns" class="btn btn-view-more" onclick="toggleAnimate('campaign')">XEM THÊM CHIẾN DỊCH</button></div>
                    </c:if>
                </section>

                <!-- 4. Partners Section -->
                <section id="partners" class="py-5 px-5">
                    <div class="text-center mb-5"><h2 class="fw-bold section-title brand-primary">Đối tác đồng hành</h2></div>
                    
                    <!-- Initial 4 Partners -->
                    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4">
                        <c:forEach var="comp" items="${companions}" varStatus="loop">
                            <c:if test="${loop.index < 4}">
                                <div class="col">
                                    <a href="${pageContext.request.contextPath}/companions?id=${comp.id}" class="text-decoration-none">
                                        <div class="partner-card">
                                            <img src="${comp.logoUrl}" class="partner-logo" alt="${comp.name}">
                                            <div class="partner-name fw-bold small text-muted">${comp.name}</div>
                                        </div>
                                    </a>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>

                    <!-- Hidden Partners with Animation -->
                    <c:if test="${companions.size() > 4}">
                        <div id="partnerExpand" class="expandable-list mt-4">
                            <div class="expandable-content">
                                <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4">
                                    <c:forEach var="comp" items="${companions}" varStatus="loop">
                                        <c:if test="${loop.index >= 4}">
                                            <div class="col">
                                                <a href="${pageContext.request.contextPath}/companions?id=${comp.id}" class="text-decoration-none">
                                                    <div class="partner-card">
                                                        <img src="${comp.logoUrl}" class="partner-logo" alt="${comp.name}">
                                                        <div class="partner-name fw-bold small text-muted">${comp.name}</div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                        <div class="text-center mt-5"><button id="btnMorePartners" class="btn btn-view-more" onclick="toggleAnimate('partner')">XEM THÊM ĐỐI TÁC</button></div>
                    </c:if>
                </section>

                <!-- 5. Philosophy Section (RESTORED CLASSIC DESIGN) -->
                <section id="philosophy" class="py-5 bg-white px-5">
                    <div class="text-center mb-5"><h2 class="fw-bold section-title brand-primary">Triết lý hoạt động</h2></div>
                    <div class="row align-items-center g-4">
                        <!-- Left Triết lý -->
                        <div class="col-lg-4">
                            <div class="phil-item text-lg-end">
                                <div class="phil-icon bg-soft-red ms-lg-auto"><i class="fas fa-heart"></i></div>
                                <h5 class="fw-bold">Tận tâm sẻ chia</h5>
                                <p class="text-muted small">Lắng nghe và thấu hiểu từng hoàn cảnh để mang lại sự hỗ trợ kịp thời và thiết thực nhất.</p>
                            </div>
                            <div class="phil-item text-lg-end">
                                <div class="phil-icon bg-soft-blue ms-lg-auto"><i class="fas fa-shield-alt"></i></div>
                                <h5 class="fw-bold">Minh bạch tuyệt đối</h5>
                                <p class="text-muted small">Cam kết công khai 100% dòng tiền quyên góp, đảm bảo niềm tin trọn vẹn của cộng đồng.</p>
                            </div>
                        </div>
                        <!-- Center Image -->
                        <div class="col-lg-4 text-center">
                            <img src="https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=600&q=80" class="phil-center-img animate-pulse" alt="Philosophy">
                        </div>
                        <!-- Right Triết lý -->
                        <div class="col-lg-4">
                            <div class="phil-item">
                                <div class="phil-icon bg-soft-green"><i class="fas fa-link"></i></div>
                                <h5 class="fw-bold">Kết nối bền vững</h5>
                                <p class="text-muted small">Xây dựng mạng lưới hỗ trợ lâu dài giữa nhà hảo tâm, đối tác và những người cần giúp đỡ.</p>
                            </div>
                            <div class="phil-item">
                                <div class="phil-icon bg-soft-orange"><i class="fas fa-star"></i></div>
                                <h5 class="fw-bold">Lan tỏa hy vọng</h5>
                                <p class="text-muted small">Mỗi hành động nhỏ hôm nay là hạt mầm cho một tương lai tươi sáng hơn của ngày mai.</p>
                            </div>
                        </div>
                    </div>

                    <!-- Expandable Deep Philosophy -->
                    <div class="text-center mt-4">
                        <button class="btn btn-view-more" onclick="togglePhilosophy()" id="btnPhil">TÌM HIỂU SÂU HƠN VỀ SỨ MỆNH</button>
                    </div>
                    
                    <div id="philContent" class="phil-expand-content">
                        <div class="row g-5 align-items-center">
                            <div class="col-md-6 border-end">
                                <h3 class="fw-bold text-dark mb-4">Sứ mệnh của chúng tôi</h3>
                                <p>CharityDonation ra đời with khao khát xóa bỏ rào cản giữa lòng tốt và những mảnh đời khó khăn. Chúng tôi tin rằng công nghệ có thể biến sự tử tế trở nên dễ dàng và có tác động lớn hơn bao giờ hết.</p>
                                <p>Hơn cả một nền tảng quyên góp, chúng tôi xây dựng một hệ sinh thái của sự tử tế, nơi mỗi giao dịch không chỉ là con số, mà là một câu chuyện về tình người được viết tiếp.</p>
                            </div>
                            <div class="col-md-6">
                                <h3 class="fw-bold text-dark mb-4">Giá trị cốt lõi</h3>
                                <ul class="list-unstyled">
                                    <li class="mb-3"><i class="fas fa-check-circle text-success me-2"></i> <strong>Chính trực:</strong> Luôn làm điều đúng đắn ngay cả khi không có ai nhìn thấy.</li>
                                    <li class="mb-3"><i class="fas fa-check-circle text-success me-2"></i> <strong>Sáng tạo:</strong> Không ngừng cải tiến công nghệ để tối ưu hóa nguồn lực thiện nguyện.</li>
                                    <li class="mb-3"><i class="fas fa-check-circle text-success me-2"></i> <strong>Cộng đồng:</strong> Sức mạnh nằm ở sự đoàn kết của hàng triệu con người.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 6. FAQ Section -->
                <section id="faq" class="faq-section px-5">
                    <div class="text-center mb-5"><h2 class="fw-bold section-title brand-primary">Câu hỏi thường gặp</h2></div>
                    <div class="row row-cols-1 row-cols-md-2 g-4">
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q1"><div class="faq-icon-wrapper bg-soft-blue"><i class="fas fa-shield-alt"></i></div>Quyên góp có an toàn không?</button></h2><div id="q1" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Hệ thống tích hợp cổng thanh toán uy tín, sử dụng mã hóa SSL đa tầng đảm bảo bảo mật tuyệt đối cho mọi giao dịch của bạn.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q2"><div class="faq-icon-wrapper bg-soft-green"><i class="fas fa-user-check"></i></div>Làm sao tin tưởng tính minh bạch?</button></h2><div id="q2" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Mọi chiến dịch đều có báo cáo sao kê thời gian thực và hình ảnh thực tế từ các hoạt động trao tặng ngay trên trang chi tiết.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q3"><div class="faq-icon-wrapper bg-soft-purple"><i class="fas fa-user-secret"></i></div>Tôi có thể quyên góp ẩn danh?</button></h2><div id="q3" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Có, bạn chỉ cần tích chọn "Quyên góp ẩn danh", tên bạn sẽ được hiển thị là "Nhà hảo tâm ẩn danh" trên danh sách công khai.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q4"><div class="faq-icon-wrapper bg-soft-orange"><i class="fas fa-envelope"></i></div>Có email xác nhận quyên góp?</button></h2><div id="q4" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Hệ thống tự động gửi email xác nhận ngay khi quản trị viên xác nhận giao dịch của bạn thành công.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q5"><div class="faq-icon-wrapper bg-soft-blue"><i class="fas fa-chart-pie"></i></div>Nếu chiến dịch không đạt mục tiêu?</button></h2><div id="q5" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Chúng tôi sẽ trao đổi với đối tác để giải ngân dựa trên số tiền thực tế hoặc chuyển sang dự án tương tự có cùng mục tiêu.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q6"><div class="faq-icon-wrapper bg-soft-purple"><i class="fas fa-handshake"></i></div>Làm đối tác của CharityDonation?</button></h2><div id="q6" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Vui lòng gửi hồ sơ năng lực qua email contact@charitydonation.vn. Chúng tôi sẽ phản hồi trong vòng 48 giờ làm việc.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q7"><div class="faq-icon-wrapper bg-soft-orange"><i class="fas fa-plus-circle"></i></div>Tôi có thể đề xuất chiến dịch mới?</button></h2><div id="q7" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Hãy gửi thông tin trường hợp cần giúp đỡ qua mục "Liên hệ", đội ngũ thẩm định của chúng tôi sẽ liên hệ lại sớm nhất.</div></div></div></div>
                        <div class="col"><div class="faq-card accordion-item"><h2 class="faq-header"><button class="faq-btn collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#q8"><div class="faq-icon-wrapper bg-soft-red"><i class="fas fa-percentage"></i></div>Hệ thống có thu phí quản lý?</button></h2><div id="q8" class="accordion-collapse collapse" data-bs-parent="#faq"><div class="faq-body">Không. 100% số tiền quyên góp được chuyển đến người thụ hưởng. Chi phí vận hành do các đối tác chiến lược tài trợ.</div></div></div></div>
                    </div>
                </section>

                <jsp:include page="fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
        function handlePaymentMethodChange(select) {
            const selectedOption = select.options[select.selectedIndex];
            const provider = selectedOption.getAttribute('data-provider');
            const bankInfoLink = document.getElementById('bankInfoLink');
            
            if (provider === 'BANK') {
                bankInfoLink.classList.remove('d-none');
            } else {
                bankInfoLink.classList.add('d-none');
            }
        }

        function showBankInfo() {
            const modalEl = document.getElementById('bankInstructionsModal');
            // Reset code if it's just a general preview
            const instrCode = document.getElementById('instrCode');
            if (instrCode.innerText === 'QG123456' || !instrCode.innerText) {
                instrCode.innerText = 'QG' + Math.floor(Math.random() * 1000000).toString().padStart(6, '0');
            }
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.show();
        }

        function openQuickDonate(id, name) {
            document.getElementById('donateCampaignId').value = id;
            document.getElementById('donateCampaignName').innerText = name;
            const modalEl = document.getElementById('donateModal');
            const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modal.show();
        }

        window.addEventListener('load', function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success') === 'pending') {
                const code = urlParams.get('code');
                if (code) {
                    document.getElementById('instrCode').innerText = code;
                    const modalEl = document.getElementById('bankInstructionsModal');
                    const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                    modal.show();
                }
            }
        });

        function copyToClipboard(elementId) {
            const text = document.getElementById(elementId).innerText;
            navigator.clipboard.writeText(text).then(() => {
                alert('Đã sao chép mã nội dung!');
            });
        }

        function togglePhilosophy() {
            const content = document.getElementById('philContent');
            const btn = document.getElementById('btnPhil');
            if (content && btn) {
                content.classList.toggle('show');
                if (content.classList.contains('show')) {
                    btn.innerText = 'THU GỌN NỘI DUNG';
                } else {
                    btn.innerText = 'TÌM HIỂU SÂU HƠN VỀ SỨ MỆNH';
                    document.getElementById('philosophy').scrollIntoView({ behavior: 'smooth' });
                }
            }
        }

        function validateDonateForm(form) {
            const email = form.email ? form.email.value.trim() : null;
            const phone = form.phone ? form.phone.value.trim() : null;
            const submitBtn = form.querySelector('button[type="submit"]');

            // 1. Kiểm tra Email (nếu có trường email - dành cho Guest)
            if (email !== null) {
                const emailRegex = /^[a-zA-Z0-9_+&*-]+(?:\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$/;
                if (!emailRegex.test(email)) {
                    Swal.fire('Lỗi định dạng', 'Địa chỉ email không đúng định dạng. Vui lòng kiểm tra lại.', 'error');
                    return false;
                }
            }

            // 2. Kiểm tra Số điện thoại (nếu có trường phone - dành cho Guest)
            if (phone !== null) {
                // Regex chuẩn VN: Bắt đầu bằng 0 hoặc 84, theo sau là 3,5,7,8,9 và đúng 8 chữ số tiếp theo (Tổng 10 số)
                const phoneRegex = /^((0|84)(3|5|7|8|9)[0-9]{8})$/;
                if (!phoneRegex.test(phone)) {
                    Swal.fire('Số điện thoại không lệ', 'Vui lòng nhập đúng số điện thoại Việt Nam (10 chữ số).', 'error');
                    return false;
                }
            }

            // 3. Chống double-submit
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> ĐANG XỬ LÝ...';
            }
            
            return true;
        }

        function toggleAnimate(type) {
            const container = document.getElementById(type === 'campaign' ? 'campaignExpand' : 'partnerExpand');
            const btn = document.getElementById(type === 'campaign' ? 'btnMoreCampaigns' : 'btnMorePartners');
            
            if (container.classList.contains('expanded')) {
                container.classList.remove('expanded');
                btn.innerText = type === 'campaign' ? 'XEM THÊM CHIẾN DỊCH' : 'XEM THÊM ĐỐI TÁC';
                document.getElementById(type === 'campaign' ? 'campaigns' : 'partners').scrollIntoView({ behavior: 'smooth' });
            } else {
                container.classList.add('expanded');
                btn.innerText = 'THU GỌN BỚT';
            }
        }

        function toggleMore(type) {
            toggleAnimate(type);
        }
    </script>
</body>
</html>
   </script>
</body>
</html>
