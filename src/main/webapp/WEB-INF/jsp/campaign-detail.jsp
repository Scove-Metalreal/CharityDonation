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
        .campaign-title { font-size: 2.2rem; line-height: 1.3; }
        .main-feature-img { width: 100%; height: 500px; object-fit: cover; border-radius: 20px; cursor: pointer; }
        .thumb-img { width: 100%; height: 80px; object-fit: cover; border-radius: 12px; cursor: pointer; opacity: 0.6; transition: 0.3s; }
        .thumb-img:hover, .thumb-img.active { opacity: 1; border: 2px solid var(--color-primary); }
        .donation-action-card-themed { background: var(--card-dark-bg); color: var(--card-dark-text); border-radius: 24px; padding: 30px; position: sticky; top: 20px; }
        .sticky-tab-bar { position: sticky; top: 0; background: white; z-index: 100; border-bottom: 1px solid var(--color-border); margin-top: 40px; }
        .nav-tabs-custom .nav-link { border: none; color: var(--color-text-muted); font-weight: 600; padding: 15px 25px; position: relative; }
        .nav-tabs-custom .nav-link.active { color: var(--color-primary); background: transparent; }
        .nav-tabs-custom .nav-link.active::after { content: ""; position: absolute; bottom: 0; left: 0; right: 0; height: 3px; background: var(--color-primary); border-radius: 3px; }
        .donor-container { background: #f9fafb; border: 1px solid var(--color-border); border-radius: 20px; overflow: hidden; }
        .donor-row { padding: 15px 20px; display: flex; align-items: center; border-bottom: 1px solid var(--color-border); }
        .donor-row:last-child { border-bottom: none; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <!-- Modals -->
        <!-- Donation Modal -->
        <div class="modal fade" id="donateModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0 bg-dark text-white p-4">
                        <h5 class="modal-title fw-bold">QUYÊN GÓP CHO CHIẾN DỊCH</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <h6 id="donateCampaignName" class="fw-bold text-primary">${campaign.name}</h6>
                        </div>
                        <form action="${pageContext.request.contextPath}/campaign/donate" method="post">
                            <input type="hidden" name="campaignId" id="donateCampaignId" value="${campaign.id}">
                            
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">${error}</div>
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
                                            <input type="text" name="phone" class="form-control" placeholder="Số điện thoại (Tùy chọn)">
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

                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted text-uppercase">Phương thức thanh toán</label>
                                <div class="payment-methods">
                                    <c:forEach var="pm" items="${paymentMethods}">
                                        <div class="form-check border rounded-pill p-3 mb-2 px-4 d-flex align-items-center">
                                            <input class="form-check-input me-3" type="radio" name="paymentMethodId" value="${pm.id}" id="pm_${pm.id}" required>
                                            <label class="form-check-label flex-grow-1 fw-bold" for="pm_${pm.id}">${pm.methodName}</label>
                                            <i class="fas fa-wallet text-primary"></i>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="mb-4">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" name="isAnonymous" value="1" id="anonymousCheck">
                                    <label class="form-check-label small fw-bold" for="anonymousCheck">Quyên góp ẩn danh (Không hiện tên trên danh sách)</label>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow">XÁC NHẬN QUYÊN GÓP</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bank Transfer Instructions Modal -->
        <div class="modal fade" id="bankInstructionsModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 shadow-lg rounded-4">
                    <div class="modal-header border-0 bg-primary text-white p-4">
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
                                <div class="fw-bold fs-4 text-primary" id="instrAccountNum">0987654321</div>
                            </div>
                            <div class="mb-3">
                                <label class="smallest text-muted text-uppercase fw-bold d-block">Chủ tài khoản</label>
                                <div class="fw-bold" id="instrAccountName">TẠ NGỌC PHƯƠNG</div>
                            </div>
                            <div class="mb-0">
                                <label class="smallest text-muted text-uppercase fw-bold d-block">Nội dung chuyển khoản (BẮT BUỘC)</label>
                                <div class="p-3 bg-white border border-primary border-dashed rounded-3 mt-1">
                                    <span class="fw-bold fs-4 text-danger" id="instrCode">QG123456</span>
                                    <button class="btn btn-sm btn-outline-primary float-end" onclick="copyToClipboard('instrCode')">Sao chép</button>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn btn-primary w-100 py-3 rounded-pill fw-bold" data-bs-dismiss="modal">ĐÃ HIỂU</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lightbox Modal -->
        <div class="modal fade" id="lightboxModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-xl">
                <div class="modal-content bg-transparent border-0">
                    <div class="modal-body p-0 text-center">
                        <img id="lightboxImg" src="" class="img-fluid rounded shadow-lg" style="max-height: 90vh;">
                        <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row flex-nowrap">
            <div class="col-auto p-0 border-end" style="z-index: 1000;">
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
                <div class="p-4 p-xl-5">
                    <div class="mb-4">
                        <h1 class="campaign-title fw-bold mb-3">${campaign.name}</h1>
                        <div class="d-flex align-items-center text-muted small">
                            <i class="fas fa-heart text-danger me-2"></i> 
                            <span>Chiến dịch quyên góp vì cộng đồng</span>
                            <span class="mx-3">|</span>
                            <i class="far fa-calendar-alt me-2"></i>
                            <span>Ngày đăng: ${campaign.startDate}</span>
                        </div>
                    </div>

                    <div class="d-flex gap-4 mb-5">
                        <div class="col-lg-8">
                            <!-- Image Carousel -->
                            <div id="campaignCarousel" class="carousel slide" data-bs-ride="carousel">
                                <div class="carousel-inner rounded-4 shadow-sm">
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
                                <button class="carousel-control-prev" type="button" data-bs-target="#campaignCarousel" data-bs-slide="prev">
                                    <span class="carousel-control-prev-icon"></span>
                                </button>
                                <button class="carousel-control-next" type="button" data-bs-target="#campaignCarousel" data-bs-slide="next">
                                    <span class="carousel-control-next-icon"></span>
                                </button>
                            </div>

                            <!-- Thumbnails -->
                            <div class="row g-2 mt-3">
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

                        <div class="col-lg-4">
                            <div class="donation-action-card-themed shadow-lg">
                                <div class="d-flex justify-content-between align-items-center mb-4 gap-2">
                                    <h6 class="fw-bold mb-0 text-uppercase d-none d-sm-block">Thông tin quyên góp</h6>
                                    <div class="d-flex gap-2 flex-nowrap">
                                        <c:choose>
                                            <c:when test="${following}">
                                                <form action="${pageContext.request.contextPath}/campaign/unfollow" method="post" class="m-0">
                                                    <input type="hidden" name="campaignId" value="${campaign.id}">
                                                    <button type="submit" class="btn btn-sidebar-action active btn-fixed-action">
                                                        <i class="fas fa-bookmark me-1"></i> Đã theo dõi
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <form action="${pageContext.request.contextPath}/campaign/follow" method="post" class="m-0">
                                                    <input type="hidden" name="campaignId" value="${campaign.id}">
                                                    <button type="submit" class="btn btn-sidebar-action btn-fixed-action">
                                                        <i class="far fa-bookmark me-1"></i> Theo dõi
                                                    </button>
                                                </form>
                                            </c:otherwise>
                                        </c:choose>
                                        <a href="https://www.facebook.com/sharer/sharer.php?u=${requestScope['javax.servlet.forward.request_uri']}" target="_blank" class="btn btn-sidebar-action btn-fixed-action"><i class="fab fa-facebook-f me-1"></i>Chia sẻ</a>
                                    </div>
                                </div>

                                <div class="sponsor-list">
                                    <c:forEach var="cp" items="${campaign.companions}">
                                        <div class="d-flex align-items-center mb-3">
                                            <img src="${cp.logoUrl}" class="rounded border bg-white me-3" width="40" height="40">
                                            <div><div class="smallest text-white-50">Nhà đồng hành</div><div class="fw-bold small">${cp.name}</div></div>
                                        </div>
                                    </c:forEach>
                                </div>

                                <div class="funding-stats mt-4">
                                    <div class="mb-2">
                                        <span class="fs-3 fw-bold"><fmt:formatNumber value="${campaign.currentMoney}" type="number"/>đ</span>
                                        <span class="text-white-50 small"> / <fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</span>
                                    </div>
                                    <c:set var="target" value="${campaign.targetMoney.doubleValue() > 0 ? campaign.targetMoney : 1}"/>
                                    <c:set var="percent" value="${(campaign.currentMoney.doubleValue() / target.doubleValue()) * 100}"/>
                                    <div class="progress liquid-progress-container" style="height: 20px;">
                                        <div class="progress-bar liquid-progress-fill" style="width: ${percent > 100 ? 100 : percent}%">
                                            <div class="liquid-wave"></div>
                                            <div class="liquid-wave"></div>
                                            <div class="liquid-text">${percent > 100 ? 100 : Math.round(percent)}%</div>
                                        </div>
                                    </div>
                                </div>

                                <c:if test="${empty sessionScope.loggedInUser or sessionScope.loggedInUser.role.roleName != 'ADMIN'}">
                                    <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold mt-4 shadow" data-bs-toggle="modal" data-bs-target="#donateModal" ${campaign.status != 1 ? 'disabled' : ''}>
                                        ${campaign.status == 1 ? 'QUYÊN GÓP NGAY' : 'CHIẾN DỊCH ĐÃ KẾT THÚC'}
                                    </button>
                                </c:if>
                                
                                <c:if test="${following}">
                                    <div class="mt-3 text-center">
                                        <form action="${pageContext.request.contextPath}/campaign/follow" method="post">
                                            <input type="hidden" name="campaignId" value="${campaign.id}">
                                            <input type="hidden" name="email" value="${receiveEmail ? 0 : 1}">
                                            <button type="submit" class="btn btn-link btn-sm text-white-50 text-decoration-none">
                                                <i class="fas ${receiveEmail ? 'fa-bell' : 'fa-bell-slash'} me-1"></i> ${receiveEmail ? 'Tắt thông báo email' : 'Nhận thông báo qua email'}
                                            </button>
                                        </form>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="sticky-tab-bar">
                        <ul class="nav nav-tabs nav-tabs-custom">
                            <li class="nav-item"><a class="nav-link active" href="#story">Hoàn cảnh</a></li>
                            <li class="nav-item"><a class="nav-link" href="#details">Nội dung chiến dịch</a></li>
                            <li class="nav-item"><a class="nav-link" href="#donors">Nhà hảo tâm</a></li>
                        </ul>
                    </div>

                    <div class="row g-5 mt-2">
                        <div class="col-lg-7 col-xl-8">
                            <div class="tab-content">
                                <div class="py-4" id="story">
                                    <h4 class="fw-bold mb-4">Hoàn cảnh</h4>
                                    <div class="rich-text-content">
                                        <c:choose>
                                            <c:when test="${not empty campaign.background}">
                                                ${campaign.background}
                                            </c:when>
                                            <c:otherwise>
                                                <p>Trong cuộc hành trình nhân ái này, chúng tôi hướng tới những mảnh đời còn nhiều gian khó, nơi mà sự giúp đỡ kịp thời có thể thay đổi cả một tương lai. Mỗi chiến dịch không chỉ là sự hỗ trợ về vật chất mà còn là niềm an ủi tinh thần to lớn, giúp các hoàn cảnh khó khăn có thêm nghị lực để vươn lên trong cuộc sống.</p>
                                                <p>Chúng tôi đã chứng kiến biết bao nụ cười rạng rỡ của trẻ em khi được đến trường, sự nhẹ lòng của những người già khi được chăm sóc y tế. Đó chính là động lực để CharityDonation tiếp tục sứ mệnh cầu nối, lan tỏa tình yêu thương đến mọi miền tổ quốc.</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="py-5 border-top" id="details">
                                    <h4 class="fw-bold mb-4">Nội dung chiến dịch</h4>
                                    <div class="p-4 bg-light rounded-4 mb-4">
                                        <table class="table table-borderless m-0">
                                            <tr><td class="text-muted">Mã dự án:</td><td class="fw-bold">${campaign.code}</td></tr>
                                            <tr><td class="text-muted">Mục tiêu:</td><td class="fw-bold text-primary"><fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</td></tr>
                                            <tr><td class="text-muted">SĐT thụ hưởng:</td><td class="fw-bold">${campaign.beneficiaryPhone}</td></tr>
                                            <tr><td class="text-muted">Ngày bắt đầu:</td><td class="fw-bold">${campaign.startDate}</td></tr>
                                            <tr><td class="text-muted">Trạng thái:</td><td><span class="badge ${campaign.status == 1 ? 'bg-success' : 'bg-secondary'} rounded-pill">${campaign.status == 1 ? 'Đang quyên góp' : 'Đã kết thúc'}</span></td></tr>
                                        </table>
                                    </div>
                                    <div class="rich-text-content">
                                        <c:choose>
                                            <c:when test="${not empty campaign.content}">
                                                ${campaign.content}
                                            </c:when>
                                            <c:otherwise>
                                                <p>Chiến dịch này tập trung vào việc huy động nguồn lực từ cộng đồng để hiện thực hóa các mục tiêu đã đề ra. Chúng tôi cam kết sử dụng 100% số tiền quyên góp được đúng mục đích và minh bạch hoàn toàn các giao dịch.</p>
                                                <p>Kế hoạch triển khai bao gồm:</p>
                                                <ul>
                                                    <li>Khảo sát thực tế và lập danh sách các đối tượng cần hỗ trợ chính xác nhất.</li>
                                                    <li>Phối hợp với các cơ quan địa phương và nhà đồng hành để triển khai trao tặng trực tiếp.</li>
                                                    <li>Cập nhật báo cáo tiến độ và kết quả thực hiện ngay trên trang thông tin của chiến dịch.</li>
                                                </ul>
                                                <p>Hãy cùng chúng tôi chung tay thắp sáng những hy vọng mới!</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="py-5 border-top" id="donors">
                                    <h4 class="fw-bold mb-4">Nhà hảo tâm</h4>
                                    <div class="row g-4">
                                        <!-- Table A: Top Donors -->
                                        <div class="col-md-6">
                                            <div class="donor-container h-100">
                                                <div class="p-3 donor-header-themed fw-bold">NHÀ HẢO TÂM HÀNG ĐẦU</div>
                                                <c:forEach var="d" items="${topDonors10}" varStatus="loop">
                                                    <div class="donor-row">
                                                        <div class="fw-bold text-primary me-3" style="width:20px">${loop.index + 1}</div>
                                                        <div class="flex-grow-1 text-truncate"><strong>${d.isAnonymous == 1 ? 'Nhà hảo tâm ẩn danh' : d.user.fullName}</strong></div>
                                                        <div class="fw-bold text-primary"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty topDonors10}"><div class="p-4 text-center text-muted small">Chưa có quyên góp nào.</div></c:if>
                                                <div class="p-3 text-center border-top">
                                                    <button class="btn btn-link btn-sm fw-bold text-decoration-none" data-bs-toggle="modal" data-bs-target="#topDonorsModal">XEM THÊM</button>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Table B: Latest Donors -->
                                        <div class="col-md-6">
                                            <div class="donor-container h-100">
                                                <div class="p-3 bg-light fw-bold text-dark border-bottom">NHÀ HẢO TÂM MỚI NHẤT</div>
                                                <c:forEach var="d" items="${recentDonors10}">
                                                    <div class="donor-row">
                                                        <div class="flex-grow-1 text-truncate">
                                                            <strong>${d.isAnonymous == 1 ? 'Nhà hảo tâm ẩn danh' : d.user.fullName}</strong>
                                                            <div class="smallest text-muted">${d.createdAt}</div>
                                                        </div>
                                                        <div class="fw-bold text-dark"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                    </div>
                                                </c:forEach>
                                                <c:if test="${empty recentDonors10}"><div class="p-4 text-center text-muted small">Chưa có quyên góp nào.</div></c:if>
                                                <div class="p-3 text-center border-top">
                                                    <button class="btn btn-link btn-sm fw-bold text-decoration-none" data-bs-toggle="modal" data-bs-target="#recentDonorsModal">XEM THÊM</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-5 col-xl-4">
                            <div class="sticky-top" style="top: 80px;">
                                <h5 class="fw-bold mb-4">Chương trình khác</h5>
                                <c:forEach var="ongoing" items="${ongoingCampaigns}">
                                    <div class="mb-4">
                                        <c:set var="campaign" value="${ongoing}" scope="request"/>
                                        <c:set var="isCompact" value="true" scope="request"/>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openQuickDonate(id, name) {
            if (id == '${campaign.id}') {
                const modalEl = document.getElementById('donateModal');
                const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
                modal.show();
            } else {
                window.location.href = '${pageContext.request.contextPath}/campaign/' + id;
            }
        }

        // Check for success parameters on load
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

        function openLightbox(src) {
            document.getElementById('lightboxImg').src = src;
            const modalEl = document.getElementById('lightboxModal');
            const modal = bootstrap.Modal.getInstance(modalEl) || new bootstrap.Modal(modalEl);
            modal.show();
        }

        // Sync Carousel with Thumbnails and handle manual clicks
        const carouselEl = document.getElementById('campaignCarousel');
        if (carouselEl) {
            const carousel = new bootstrap.Carousel(carouselEl);
            const thumbs = document.querySelectorAll('.thumb-img');
            
            thumbs.forEach((thumb, index) => {
                thumb.addEventListener('click', () => {
                    carousel.to(index);
                });
            });

            carouselEl.addEventListener('slide.bs.carousel', event => {
                thumbs.forEach(t => t.classList.remove('active'));
                thumbs[event.to].classList.add('active');
            });
        }

        // Smooth Scrolling for Tabs
        document.querySelectorAll('.nav-tabs-custom .nav-link').forEach(link => {
            link.addEventListener('click', e => {
                e.preventDefault();
                const target = document.querySelector(link.getAttribute('href'));
                const scrollable = document.querySelector('.scrollable-main');
                if (target && scrollable) {
                    scrollable.scrollTo({
                        top: target.offsetTop - 80,
                        behavior: 'smooth'
                    });
                    document.querySelectorAll('.nav-tabs-custom .nav-link').forEach(l => l.classList.remove('active'));
                    link.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>