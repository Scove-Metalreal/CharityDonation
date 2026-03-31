<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<nav class="bg-white d-flex justify-content-between align-items-center shadow-sm sticky-top px-4 py-3 mb-4">
    <div class="d-flex align-items-center">
        <h5 class="mb-0 fw-bold text-dark">
            <c:choose>
                <c:when test="${activePage == 'admin-dashboard'}">Dashboard Overview</c:when>
                <c:when test="${activePage == 'admin-users'}">Quản lý Người dùng</c:when>
                <c:when test="${activePage == 'admin-campaigns'}">Quản lý Chiến dịch</c:when>
                <c:when test="${activePage == 'admin-donations'}">Xác nhận Quyên góp</c:when>
                <c:when test="${activePage == 'admin-settings'}">Cài đặt hệ thống</c:when>
                <c:otherwise>Hệ thống quản trị</c:otherwise>
            </c:choose>
        </h5>
    </div>
    <div class="d-flex align-items-center">
        <!-- Notifications -->
        <div class="dropdown me-3">
            <div class="position-relative cursor-pointer" data-bs-toggle="dropdown" id="notificationBell">
                <i class="far fa-bell fs-5 text-muted"></i>
                <c:if test="${notificationCount > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" id="notificationBadge" style="font-size: 0.6rem;">
                        ${notificationCount}
                    </span>
                </c:if>
            </div>
            <div class="dropdown-menu dropdown-menu-end notification-dropdown shadow border-0 rounded-4 py-0 mt-3" style="width: 320px; max-height: 400px; overflow-y: auto;">
                <div class="p-3 border-bottom bg-light rounded-top-4">
                    <h6 class="mb-0 fw-bold">Thông báo mới nhất</h6>
                </div>
                <c:forEach var="d" items="${recentDonations}">
                    <a href="${pageContext.request.contextPath}/admin/donations" class="text-decoration-none text-dark">
                        <div class="p-3 border-bottom hover-bg-light" style="font-size: 0.85rem;">
                            <div class="fw-bold">${d.donorName}</div>
                            <div class="text-muted small">Quyên góp <fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                            <div class="smallest brand-primary">
                                <fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedCreatedAt" type="both" />
                                <fmt:formatDate value="${parsedCreatedAt}" pattern="dd/MM/yyyy" />
                            </div>
                        </div>
                    </a>
                </c:forEach>
                <div class="p-2 text-center border-top">
                    <a href="${pageContext.request.contextPath}/admin/donations" class="small fw-bold brand-primary text-decoration-none">Xem tất cả</a>
                </div>
            </div>
        </div>
        
        <div class="text-end d-none d-lg-block border-start ps-3">
            <p class="mb-0 fw-bold small text-dark">${sessionScope.loggedInUser.fullName}</p>
            <small class="text-muted smallest">Administrator</small>
        </div>
    </div>
</nav>

<script>
    document.getElementById('notificationBell').addEventListener('show.bs.dropdown', function () {
        fetch('${pageContext.request.contextPath}/admin/mark-notifications-read')
            .then(response => {
                if (response.ok) {
                    const badge = document.getElementById('notificationBadge');
                    if (badge) {
                        badge.style.display = 'none';
                    }
                }
            });
    });
</script>

<style>
    .brand-primary { color: var(--color-primary) !important; }
    .hover-bg-light:hover { background-color: #f8f9fa; }
    .smallest { font-size: 0.7rem; }
</style>
