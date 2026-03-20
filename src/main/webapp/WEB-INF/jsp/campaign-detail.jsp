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
        .detail-header-img { width: 100%; height: 400px; object-fit: cover; border-radius: 20px; }
        .donor-avatar { width: 40px; height: 40px; border-radius: 50%; }
        .sticky-donation-card { position: sticky; top: 100px; }
    </style>
</head>
<body class="bg-light">
    <div class="container py-5">
        <div class="row g-5">
            <!-- Left Side: Detail Content -->
            <div class="col-lg-8">
                <nav aria-label="breadcrumb" class="mb-4">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                        <li class="breadcrumb-item active">${campaign.name}</li>
                    </ol>
                </nav>

                <c:if test="${param.success eq 'donated'}">
                    <div class="alert alert-success border-0 shadow-sm mb-4 rounded-4 py-3">
                        <i class="fas fa-check-circle me-2"></i> Quyên góp thành công! Khoản đóng góp của bạn đang chờ quản trị viên xác nhận.
                    </div>
                </c:if>

                <img src="${not empty campaign.imageUrl ? campaign.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'}" class="detail-header-img mb-5 shadow-sm" alt="header">

                <div class="d-flex align-items-center mb-4">
                    <c:choose>
                        <c:when test="${campaign.status == 0}"><span class="badge bg-info rounded-pill px-3 py-2 me-3">Mới tạo</span></c:when>
                        <c:when test="${campaign.status == 1}"><span class="badge bg-success rounded-pill px-3 py-2 me-3">Đang diễn ra</span></c:when>
                        <c:when test="${campaign.status == 2}"><span class="badge bg-warning rounded-pill px-3 py-2 me-3">Đã kết thúc</span></c:when>
                        <c:when test="${campaign.status == 3}"><span class="badge bg-secondary rounded-pill px-3 py-2 me-3">Đóng quỹ</span></c:when>
                    </c:choose>
                    <span class="text-muted"><i class="far fa-calendar-alt me-2"></i>${campaign.startDate} - ${campaign.endDate}</span>
                </div>

                <h1 class="fw-bold text-dark mb-4">${campaign.name}</h1>
                <div class="lead text-muted mb-5">${campaign.background}</div>

                <div class="content-body text-secondary mb-5">
                    ${campaign.content}
                </div>

                <hr class="my-5 opacity-10">

                <h4 class="fw-bold mb-4">Danh sách nhà hảo tâm (${donors.size()})</h4>
                <div class="table-responsive">
                    <table class="table table-hover align-middle border-0">
                        <tbody>
                            <c:if test="${empty donors}">
                                <tr><td class="text-center py-4 text-muted">Chưa có lượt quyên góp nào được xác nhận.</td></tr>
                            </c:if>
                            <c:forEach var="d" items="${donors}">
                                <tr>
                                    <td style="width: 50px;">
                                        <img src="https://ui-avatars.com/api/?name=${d.isAnonymous == 1 ? 'Anonymous' : d.user.fullName}&background=random" class="donor-avatar">
                                    </td>
                                    <td>
                                        <div class="fw-bold">${d.isAnonymous == 1 ? 'Nhà hảo tâm ẩn danh' : d.user.fullName}</div>
                                        <small class="text-muted"><fmt:formatDate value="${d.createdAt}" pattern="dd/MM/yyyy HH:mm"/></small>
                                    </td>
                                    <td class="text-end">
                                        <div class="fw-bold text-primary">+<fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Right Side: Progress & Donation Box -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm rounded-4 p-4 sticky-donation-card">
                    <c:set var="target" value="${campaign.targetMoney != null ? campaign.targetMoney : 1}"/>
                    <c:set var="current" value="${campaign.currentMoney != null ? campaign.currentMoney : 0}"/>
                    <c:set var="percent" value="${(current / target) * 100}"/>
                    <c:if test="${percent > 100}"><c:set var="percent" value="100"/></c:if>

                    <h3 class="fw-bold text-dark mb-2"><fmt:formatNumber value="${campaign.currentMoney}" type="number"/>đ</h3>
                    <div class="text-muted small mb-3">mục tiêu <fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</div>

                    <div class="progress bg-light mb-3" style="height: 10px;">
                        <div class="progress-bar" role="progressbar" style="width: ${percent}%"></div>
                    </div>

                    <div class="d-flex justify-content-between mb-4">
                        <div class="text-center">
                            <div class="fw-bold"><fmt:formatNumber value="${percent}" maxFractionDigits="1"/>%</div>
                            <small class="text-muted">Hoàn thành</small>
                        </div>
                        <div class="text-center">
                            <div class="fw-bold">${donors.size()}</div>
                            <small class="text-muted">Lượt đóng góp</small>
                        </div>
                        <div class="text-center">
                            <div class="fw-bold">12</div>
                            <small class="text-muted">Ngày còn lại</small>
                        </div>
                    </div>

                    <c:choose>
                        <c:when test="${campaign.status == 1}">
                            <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow-sm mb-3" data-bs-toggle="modal" data-bs-target="#donateModal">QUYÊN GÓP NGAY</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn btn-secondary w-100 py-3 rounded-pill fw-bold shadow-sm mb-3" disabled>ĐÃ NGỪNG NHẬN</button>
                        </c:otherwise>
                    </c:choose>
                    
                    <button class="btn btn-outline-secondary w-100 py-2 rounded-pill small"><i class="fas fa-share-alt me-2"></i>Chia sẻ chiến dịch</button>
                    
                    <div class="mt-4 p-3 bg-light rounded-3 small text-muted">
                        <i class="fas fa-shield-alt text-success me-2"></i>Khoản quyên góp của bạn được bảo mật và chuyển trực tiếp tới đơn vị thụ hưởng.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Donation Modal -->
    <div class="modal fade" id="donateModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0">
                    <h5 class="fw-bold">Gửi quyên góp của bạn</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <c:choose>
                        <c:when test="${empty sessionScope.userId}">
                            <div class="text-center py-4">
                                <p class="text-muted">Vui lòng đăng nhập để thực hiện quyên góp.</p>
                                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-primary rounded-pill px-4">Đăng nhập ngay</a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/campaign/donate" method="post">
                                <input type="hidden" name="campaignId" value="${campaign.id}">
                                
                                <div class="mb-3">
                                    <label class="form-label small fw-bold">Số tiền quyên góp (VNĐ)</label>
                                    <input type="number" name="amount" class="form-control form-control-lg fw-bold text-primary" placeholder="VD: 100000" required min="1000">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label small fw-bold">Phương thức thanh toán</label>
                                    <select name="paymentMethodId" class="form-select" required>
                                        <c:forEach var="pm" items="${paymentMethods}">
                                            <option value="${pm.id}">${pm.methodName}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="isAnonymous" value="1" id="anonCheck">
                                        <label class="form-check-label small" for="anonCheck">
                                            Quyên góp ẩn danh
                                        </label>
                                    </div>
                                </div>

                                <div class="alert alert-info border-0 small mb-4">
                                    <i class="fas fa-info-circle me-2"></i> Sau khi nhấn nút, vui lòng chuyển tiền theo thông tin hướng dẫn trên màn hình tiếp theo.
                                </div>

                                <button type="submit" class="btn btn-primary w-100 rounded-pill py-3 fw-bold">XÁC NHẬN GỬI</button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
