<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${campaign.name} - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .campaign-title { font-size: 2.2rem; line-height: 1.3; }
        .main-feature-img { width: 100%; height: 400px; object-fit: cover; border-radius: 20px; }
        .thumb-img { width: 100%; height: 80px; object-fit: cover; border-radius: 12px; cursor: pointer; opacity: 0.6; transition: 0.3s; }
        .thumb-img:hover, .thumb-img.active { opacity: 1; border: 2px solid var(--color-primary); }
        .donation-action-card { background: #1a1a1a; color: white; border-radius: 24px; padding: 30px; position: sticky; top: 20px; }
        .sticky-tab-bar { position: sticky; top: 0; background: white; z-index: 100; border-bottom: 1px solid var(--color-border); margin-top: 40px; }
        .nav-tabs-custom .nav-link { border: none; color: var(--color-text-muted); font-weight: 600; padding: 15px 25px; position: relative; }
        .nav-tabs-custom .nav-link.active { color: var(--color-primary); background: transparent; }
        .nav-tabs-custom .nav-link.active::after { content: ""; position: absolute; bottom: 0; left: 0; right: 0; height: 3px; background: var(--color-primary); border-radius: 3px; }
        .donor-container { background: #f9fafb; border: 1px solid var(--color-border); border-radius: 20px; overflow: hidden; }
        .donor-row { padding: 15px 20px; display: flex; align-items: center; border-bottom: 1px solid var(--color-border); }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
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

                    <div class="row g-4 mb-5">
                        <div class="col-lg-7 col-xl-8">
                            <img src="${not empty campaign.imageUrl ? campaign.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'}" class="main-feature-img shadow-sm mb-3">
                            <div class="row g-2">
                                <c:if test="${not empty campaign.galleryUrls}">
                                    <c:forEach var="url" items="${campaign.galleryUrls.split(',')}">
                                        <div class="col-3"><img src="${url.trim()}" class="thumb-img"></div>
                                    </c:forEach>
                                </c:if>
                            </div>
                        </div>

                        <div class="col-lg-5 col-xl-4">
                            <div class="donation-action-card shadow-lg">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h6 class="fw-bold mb-0 text-uppercase">Thông tin quyên góp</h6>
                                    <div class="d-flex gap-2">
                                        <form action="${pageContext.request.contextPath}/campaign/follow" method="post" class="m-0">
                                            <input type="hidden" name="campaignId" value="${campaign.id}">
                                            <button type="submit" class="btn btn-sm ${following ? 'btn-primary' : 'btn-dark'} rounded-pill border-secondary px-3">
                                                <i class="fas fa-bookmark me-1"></i> ${following ? 'Đã theo dõi' : 'Theo dõi'}
                                            </button>
                                        </form>
                                        <a href="https://www.facebook.com/sharer/sharer.php?u=${requestScope['javax.servlet.forward.request_uri']}" target="_blank" class="btn btn-sm btn-dark rounded-pill border-secondary px-3"><i class="fab fa-facebook-f me-1"></i>Chia sẻ</a>
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
                                    <div class="progress" style="height: 8px; background: rgba(255,255,255,0.1);">
                                        <div class="progress-bar bg-primary" style="width: ${percent > 100 ? 100 : percent}%"></div>
                                    </div>
                                </div>

                                <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold mt-4 shadow" data-bs-toggle="modal" data-bs-target="#donateModal" ${campaign.status != 1 ? 'disabled' : ''}>
                                    ${campaign.status == 1 ? 'QUYÊN GÓP NGAY' : 'CHIẾN DỊCH ĐÃ KẾT THÚC'}
                                </button>
                                
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
                            <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#story">Hoàn cảnh</button></li>
                            <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#details">Nội dung chiến dịch</button></li>
                            <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#donors">Nhà hảo tâm</button></li>
                        </ul>
                    </div>

                    <div class="row g-5 mt-2">
                        <div class="col-lg-7 col-xl-8">
                            <div class="tab-content">
                                <div class="tab-pane fade show active" id="story">
                                    <div class="rich-text-content">${campaign.content}</div>
                                    <div class="mt-5 pt-4 border-top">
                                        <h4 class="fw-bold mb-4">Nhà hảo tâm hàng đầu</h4>
                                        <div class="donor-container mb-4">
                                            <c:forEach var="d" items="${topDonors}" varStatus="loop">
                                                <div class="donor-row">
                                                    <div class="fw-bold text-primary me-3" style="width:20px">${loop.index + 1}</div>
                                                    <div class="flex-grow-1"><strong>${d.isAnonymous == 1 ? 'Nhà hảo tâm ẩn danh' : d.user.fullName}</strong></div>
                                                    <div class="fw-bold text-primary"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade" id="details">
                                    <div class="p-4 bg-light rounded-4">
                                        <table class="table table-borderless">
                                            <tr><td class="text-muted">Mã dự án:</td><td class="fw-bold">${campaign.code}</td></tr>
                                            <tr><td class="text-muted">Mục tiêu:</td><td class="fw-bold text-primary"><fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</td></tr>
                                            <tr><td class="text-muted">SĐT thụ hưởng:</td><td class="fw-bold">${campaign.beneficiaryPhone}</td></tr>
                                        </table>
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

    <!-- Donation Modal -->
    <div class="modal fade" id="donateModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header border-0 bg-dark text-white p-4">
                    <h5 class="modal-title fw-bold">QUYÊN GÓP CHO CHIẾN DỊCH</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/campaign/donate" method="post">
                        <input type="hidden" name="campaignId" value="${campaign.id}">
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted text-uppercase">Số tiền quyên góp (VNĐ)</label>
                            <input type="number" name="amount" class="form-control form-control-lg rounded-pill px-4" placeholder="Nhập số tiền..." required min="1000">
                        </div>
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted text-uppercase">Phương thức thanh toán</label>
                            <div class="payment-methods">
                                <c:forEach var="pm" items="${paymentMethods}">
                                    <div class="form-check border rounded-pill p-3 mb-2 px-4 d-flex align-items-center">
                                        <input class="form-check-input me-3" type="radio" name="paymentMethodId" value="${pm.id}" id="pm_${pm.id}" required>
                                        <label class="form-check-label flex-grow-1 fw-bold" for="pm_${pm.id}">${pm.name}</label>
                                        <i class="fas fa-wallet text-primary"></i>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="mb-4">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isAnonymous" value="1" id="anonymousCheck">
                                <label class="form-check-label small fw-bold" for="anonymousCheck">Quyên góp ẩn danh</label>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow">XÁC NHẬN QUYÊN GÓP</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
