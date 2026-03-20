<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .campaign-card-img { height: 200px; object-fit: cover; border-radius: 12px 12px 0 0; }
        .organizer-avatar { width: 24px; height: 24px; border-radius: 50%; object-fit: cover; }
        .status-badge { font-size: 0.7rem; padding: 4px 12px; border-radius: 20px; }
    </style>
</head>
<body class="bg-light">
    <div class="container">
        <div class="row">
            <!-- Left Sidebar (X.com Style) -->
            <div class="col-lg-3 d-none d-lg-block">
                <div class="sidebar-x">
                    <div class="mb-4 ps-3">
                        <i class="fas fa-hand-holding-heart fa-2x text-primary"></i>
                    </div>
                    
                    <nav class="nav flex-column mb-4">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Trang chủ</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/?status=1"><i class="fas fa-bullhorn"></i> Chiến dịch</a>
                        <c:if test="${sessionScope.loggedInUser.role.roleName == 'ADMIN'}">
                            <a class="nav-link text-danger fw-bold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-user-shield"></i> Admin Panel</a>
                        </c:if>
                        <a class="nav-link" href="#"><i class="fas fa-handshake"></i> Nhà đồng hành</a>
                        <a class="nav-link" href="#"><i class="fas fa-question-circle"></i> Q&A</a>
                    </nav>

                    <button class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow-sm mb-4">QUYÊN GÓP NGAY</button>

                    <!-- User Mini Profile -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.loggedInUser}">
                            <div class="sidebar-user-mini d-flex align-items-center" onclick="window.location.href='${pageContext.request.contextPath}/user/profile'">
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle me-3" width="40" height="40">
                                <div class="overflow-hidden">
                                    <div class="fw-bold text-dark text-truncate">${sessionScope.loggedInUser.fullName}</div>
                                    <div class="text-muted small text-truncate">@user_${sessionScope.loggedInUser.id}</div>
                                </div>
                                <i class="fas fa-ellipsis-h ms-auto text-muted"></i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-3">
                                <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-primary w-100 rounded-pill mb-2">Đăng nhập</a>
                                <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary w-100 rounded-pill">Đăng ký</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9 py-4 border-start border-end bg-white min-vh-100 shadow-sm px-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold mb-0">Hành trình nhân ái</h2>
                    <div class="d-lg-none">
                        <c:if test="${not empty sessionScope.loggedInUser}">
                             <a href="${pageContext.request.contextPath}/user/profile">
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle" width="35" height="35">
                             </a>
                        </c:if>
                    </div>
                </div>

                <!-- Filters -->
                <div class="d-flex gap-2 mb-4 overflow-auto pb-2">
                    <a href="${pageContext.request.contextPath}/?status=1" class="btn ${currentStatus == 1 ? 'btn-primary' : 'btn-light'} rounded-pill btn-sm px-3">Đang diễn ra</a>
                    <a href="${pageContext.request.contextPath}/?status=0" class="btn ${currentStatus == 0 ? 'btn-primary' : 'btn-light'} rounded-pill btn-sm px-3">Mới tạo</a>
                    <a href="${pageContext.request.contextPath}/?status=2" class="btn ${currentStatus == 2 ? 'btn-primary' : 'btn-light'} rounded-pill btn-sm px-3">Đã kết thúc</a>
                    <a href="${pageContext.request.contextPath}/?status=3" class="btn ${currentStatus == 3 ? 'btn-primary' : 'btn-light'} rounded-pill btn-sm px-3">Đóng quỹ</a>
                </div>

                <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                    <c:if test="${empty campaigns}">
                        <div class="col-12 text-center py-5">
                            <p class="alert alert-info border-0 shadow-sm">Hiện chưa có chiến dịch nào.</p>
                        </div>
                    </c:if>
                    <c:forEach var="campaign" items="${campaigns}">
                        <div class="col">
                            <div class="card h-100 border-0 shadow-sm hover-shadow">
                                <img src="${not empty campaign.imageUrl ? campaign.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'}" class="card-img-top campaign-card-img" alt="campaign">
                                <div class="card-body">
                                    <div class="mb-2">
                                        <c:choose>
                                            <c:when test="${campaign.status == 0}"><span class="badge bg-info status-badge">Mới tạo</span></c:when>
                                            <c:when test="${campaign.status == 1}"><span class="badge bg-success status-badge">Đang diễn ra</span></c:when>
                                            <c:when test="${campaign.status == 2}"><span class="badge bg-warning status-badge">Đã kết thúc</span></c:when>
                                            <c:when test="${campaign.status == 3}"><span class="badge bg-secondary status-badge">Đóng quỹ</span></c:when>
                                        </c:choose>
                                    </div>
                                    <h5 class="card-title fw-bold mb-2 text-dark"><c:out value="${campaign.name}"/></h5>
                                    <p class="card-text text-muted small mb-3 text-truncate-2"><c:out value="${campaign.background}"/></p>
                                    
                                    <div class="mb-2">
                                        <c:set var="target" value="${campaign.targetMoney != null ? campaign.targetMoney : 1}"/>
                                        <c:set var="current" value="${campaign.currentMoney != null ? campaign.currentMoney : 0}"/>
                                        <c:set var="percent" value="${(current / target) * 100}"/>
                                        <c:if test="${percent > 100}"><c:set var="percent" value="100"/></c:if>
                                        
                                        <div class="d-flex justify-content-between small mb-1">
                                            <span class="fw-bold text-primary"><fmt:formatNumber value="${percent}" maxFractionDigits="1"/>% hoàn thành</span>
                                            <span class="text-muted"><fmt:formatNumber value="${campaign.targetMoney}" type="number"/>đ</span>
                                        </div>
                                        <div class="progress bg-light" style="height: 6px;">
                                            <div class="progress-bar" role="progressbar" style="width: ${percent}%"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="card-footer bg-white border-0 d-flex justify-content-between align-items-center pb-3 pt-0">
                                    <div class="small">
                                        <span class="fw-bold text-dark"><fmt:formatNumber value="${campaign.currentMoney}" type="number"/>đ</span>
                                        <span class="text-muted small"> quyên góp</span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/campaign/${campaign.id}" class="btn btn-primary btn-sm px-3 rounded-pill">Chi tiết</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-5 d-flex justify-content-center">
                        <ul class="pagination pagination-sm">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link rounded-circle mx-1" href="${pageContext.request.contextPath}/?status=${currentStatus}&page=${currentPage - 1}"><i class="fas fa-chevron-left"></i></a>
                            </li>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link rounded-circle mx-1" href="${pageContext.request.contextPath}/?status=${currentStatus}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link rounded-circle mx-1" href="${pageContext.request.contextPath}/?status=${currentStatus}&page=${currentPage + 1}"><i class="fas fa-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
