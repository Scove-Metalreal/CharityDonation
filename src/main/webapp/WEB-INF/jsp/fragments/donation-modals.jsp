<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- 1. Donation Modal -->
<div class="modal fade" id="donateModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-brand-primary border-0 p-4">
                <h5 class="modal-title fw-bold">QUYÊN GÓP CHO CHIẾN DỊCH</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4">
                <div class="mb-3">
                    <h6 id="donateCampaignName" class="fw-bold brand-primary">${campaign.name}</h6>
                </div>
                <form action="${pageContext.request.contextPath}/campaign/donate" method="post" onsubmit="return validateDonateForm(this)">
                    <input type="hidden" name="campaignId" id="donateCampaignId" value="${campaign.id}">
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted text-uppercase">Số tiền quyên góp ( VNĐ)</label>
                        <input type="number" name="amount" class="form-control form-control-lg rounded-pill px-4 shadow-none border" placeholder="Nhập số tiền..." required min="1000">
                    </div>

                    <c:if test="${empty sessionScope.loggedInUser}">
                        <div class="mb-4 bg-light p-3 rounded-4 border border-opacity-10 border-dark">
                            <h6 class="fw-bold mb-3 small text-uppercase text-muted">Thông tin người quyên góp</h6>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <input type="text" name="fullName" class="form-control rounded-pill px-3" placeholder="Họ và tên (Tùy chọn)">
                                </div>
                                <div class="col-md-6">
                                    <input type="email" name="email" class="form-control rounded-pill px-3" placeholder="Email (Bắt buộc)" required>
                                </div>
                                <div class="col-md-6">
                                    <input type="text" name="phone" class="form-control rounded-pill px-3" placeholder="SĐT (Bắt buộc)" required>
                                </div>
                                <div class="col-md-6">
                                    <input type="text" name="address" class="form-control rounded-pill px-3" placeholder="Địa chỉ (Tùy chọn)">
                                </div>
                                <div class="col-12">
                                    <textarea name="message" class="form-control rounded-4 px-3" rows="2" placeholder="Lời nhắn (Tùy chọn)"></textarea>
                                </div>
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.loggedInUser}">
                        <div class="mb-4">
                            <label class="form-label small fw-bold text-muted text-uppercase">Lời nhắn của bạn</label>
                            <textarea name="message" class="form-control rounded-4 px-4 py-3 shadow-none border" rows="2" placeholder="Nhập lời nhắn gửi đến chiến dịch..."></textarea>
                        </div>
                    </c:if>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted text-uppercase d-flex justify-content-between">
                            <span>Phương thức thanh toán</span>
                            <a href="javascript:void(0)" class="text-decoration-none smallest" onclick="showBankInfo()"><i class="fas fa-info-circle me-1"></i>Hướng dẫn</a>
                        </label>
                        <select name="paymentMethodId" id="paymentMethodSelect" class="form-select form-select-lg rounded-pill px-4 shadow-none border" required>
                            <option value="" selected disabled>Chọn phương thức...</option>
                            <c:forEach var="pm" items="${paymentMethods}">
                                <option value="${pm.id}">${pm.methodName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-4">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="isAnonymous" value="1" id="anonymousCheck">
                            <label class="form-check-label small fw-bold" for="anonymousCheck">Quyên góp ẩn danh</label>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold shadow">XÁC NHẬN QUYÊN GÓP</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- 2. Bank Transfer Instructions -->
<div class="modal fade" id="bankInstructionsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header border-0 bg-brand-primary p-4">
                <h5 class="modal-title fw-bold">HƯỚNG DẪN CHUYỂN KHOẢN</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-4 text-center">
                <p class="mb-4">Vui lòng thực hiện chuyển khoản theo thông tin dưới đây:</p>
                <div class="p-4 bg-light rounded-4 mb-4 text-start border">
                    <div class="mb-3">
                        <label class="smallest text-muted text-uppercase fw-bold d-block">Số tài khoản</label>
                        <div class="fw-bold fs-4 brand-primary">0987654321</div>
                    </div>
                    <div class="mb-3">
                        <label class="smallest text-muted text-uppercase fw-bold d-block">Chủ tài khoản</label>
                        <div class="fw-bold">TẠ NGỌC PHƯƠNG (MB Bank)</div>
                    </div>
                    <div class="mb-0">
                        <label class="smallest text-muted text-uppercase fw-bold d-block">Nội dung chuyển khoản (BẮT BUỘC)</label>
                        <div class="p-3 bg-white border border-primary border-dashed rounded-3 mt-1 d-flex justify-content-between align-items-center">
                            <span class="fw-bold fs-4 text-danger" id="instrCode">QG123456</span>
                            <button class="btn btn-sm btn-brand-secondary rounded-pill px-3" onclick="copyToClipboard('instrCode')">Sao chép</button>
                        </div>
                    </div>
                </div>
                <button type="button" class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold" data-bs-dismiss="modal">ĐÃ HIỂU</button>
            </div>
        </div>
    </div>
</div>

<!-- 3. Lightbox Modal -->
<div class="modal fade" id="lightboxModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content bg-transparent border-0">
            <div class="modal-body p-0 text-center position-relative">
                <img id="lightboxImg" src="" class="img-fluid rounded shadow-lg" style="max-height: 90vh;">
                <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
        </div>
    </div>
</div>

<!-- 4. Top Donors Modal -->
<div class="modal fade" id="topDonorsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-brand-primary p-4 border-0">
                <h5 class="modal-title fw-bold">NHÀ HẢO TÂM HÀNG ĐẦU</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0" style="max-height: 60vh; overflow-y: auto;">
                <c:forEach var="d" items="${topDonors20}" varStatus="loop">
                    <div class="donor-row px-4 py-3">
                        <div class="fw-bold brand-primary me-3" style="width:25px">${loop.index + 1}</div>
                        <div class="flex-grow-1 text-truncate">
                            <div class="fw-bold small">${d.donorName}</div>
                            <div class="smallest text-muted"><fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="p" type="both" /><fmt:formatDate value="${p}" pattern="dd/MM/yyyy" /></div>
                        </div>
                        <div class="fw-bold text-dark"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<!-- 5. Recent Donors Modal -->
<div class="modal fade" id="recentDonorsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg rounded-4">
            <div class="modal-header bg-brand-primary p-4 border-0">
                <h5 class="modal-title fw-bold">QUYÊN GÓP MỚI NHẤT</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body p-0" style="max-height: 60vh; overflow-y: auto;">
                <c:forEach var="d" items="${recentDonors20}" varStatus="loop">
                    <div class="donor-row px-4 py-3">
                        <div class="fw-bold brand-primary me-3" style="width:25px">${loop.index + 1}</div>
                        <div class="flex-grow-1 text-truncate">
                            <div class="fw-bold small">${d.donorName}</div>
                            <div class="smallest text-muted"><fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="p" type="both" /><fmt:formatDate value="${p}" pattern="dd/MM/yyyy" /></div>
                        </div>
                        <div class="fw-bold text-dark"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    function validateDonateForm(form) {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> ĐANG XỬ LÝ...';
        return true;
    }
    function copyToClipboard(id) {
        const text = document.getElementById(id).innerText;
        navigator.clipboard.writeText(text).then(() => alert('Đã sao chép!'));
    }
    function showBankInfo() {
        new bootstrap.Modal(document.getElementById('bankInstructionsModal')).show();
    }
</script>
