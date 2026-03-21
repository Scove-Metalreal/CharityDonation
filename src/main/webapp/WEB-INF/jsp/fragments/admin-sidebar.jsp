<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="sidebar-x shadow-sm border-end d-flex flex-column position-sticky top-0" id="adminSidebar" style="height: 100vh; background: #fff;">
    <div class="sidebar-header mb-4 ps-3 pt-3 d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-flex align-items-center">
            <i class="fas fa-hand-holding-heart fa-2x text-primary"></i>
            <div class="ms-2 sidebar-text">
                <span class="fs-4 fw-bold text-dark">Charity</span>
                <div class="text-muted smallest fw-bold">ADMIN PANEL</div>
            </div>
        </a>
        <button class="btn btn-sm btn-light rounded-circle me-2 sidebar-toggle-btn" onclick="toggleAdminSidebar()">
            <i class="fas fa-chevron-left" id="adminToggleIcon"></i>
        </button>
    </div>
    
    <nav class="nav flex-column mb-4 px-2 flex-grow-1">
        <a class="nav-link sidebar-nav-link ${activePage == 'admin-dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-chart-line"></i> <span class="sidebar-text ms-2">Dashboard</span>
        </a>
        <a class="nav-link sidebar-nav-link ${activePage == 'admin-users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
            <i class="fas fa-users"></i> <span class="sidebar-text ms-2">Người dùng</span>
        </a>
        <a class="nav-link sidebar-nav-link ${activePage == 'admin-campaigns' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/campaigns">
            <i class="fas fa-bullhorn"></i> <span class="sidebar-text ms-2">Chiến dịch</span>
        </a>
        <a class="nav-link sidebar-nav-link ${activePage == 'admin-donations' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/donations">
            <i class="fas fa-check-circle"></i> <span class="sidebar-text ms-2">Xác nhận</span>
        </a>
        <a class="nav-link sidebar-nav-link ${activePage == 'admin-settings' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/settings">
            <i class="fas fa-cog"></i> <span class="sidebar-text ms-2">Cài đặt</span>
        </a>
        <hr class="mx-3 opacity-10 sidebar-text">
        <a href="${pageContext.request.contextPath}/" class="nav-link sidebar-nav-link text-muted">
            <i class="fas fa-external-link-alt"></i> <span class="sidebar-text ms-2">Trang chủ</span>
        </a>
    </nav>

    <!-- Pin to Bottom -->
    <div class="mt-auto p-3 border-top bg-white">
        <div class="dropdown">
            <div class="sidebar-user-mini d-flex align-items-center cursor-pointer" data-bs-toggle="dropdown">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.loggedInUser.fullName}&background=10B981&color=fff" class="rounded-circle shadow-sm" width="40" height="40">
                <div class="overflow-hidden ms-3 sidebar-text">
                    <div class="fw-bold text-dark text-truncate" style="max-width: 120px;">${sessionScope.loggedInUser.fullName}</div>
                    <div class="text-muted smallest">Admin</div>
                </div>
            </div>
            <ul class="dropdown-menu dropdown-menu-dark shadow border-0 rounded-4 p-2 mb-2">
                <li><a class="dropdown-item rounded-3" href="${pageContext.request.contextPath}/user/profile"><i class="fas fa-user me-2"></i> Hồ sơ</a></li>
                <li><hr class="dropdown-divider opacity-10"></li>
                <li><a class="dropdown-item rounded-3 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
            </ul>
        </div>
    </div>
</div>

<script>
    function toggleAdminSidebar() {
        const sidebar = document.getElementById('adminSidebar');
        const icon = document.getElementById('adminToggleIcon');
        sidebar.classList.toggle('collapsed');
        
        if (sidebar.classList.contains('collapsed')) {
            icon.classList.replace('fa-chevron-left', 'fa-chevron-right');
            localStorage.setItem('admin-sidebar-collapsed', 'true');
        } else {
            icon.classList.replace('fa-chevron-right', 'fa-chevron-left');
            localStorage.setItem('admin-sidebar-collapsed', 'false');
        }
    }

    if (localStorage.getItem('admin-sidebar-collapsed') === 'true') {
        document.getElementById('adminSidebar').classList.add('collapsed');
        document.getElementById('adminToggleIcon').classList.replace('fa-chevron-left', 'fa-chevron-right');
    }
</script>

<style>
    .sidebar-x { width: 280px; transition: all 0.3s ease; }
    .sidebar-nav-link { padding: 12px 15px; border-radius: 99px; margin-bottom: 5px; color: #333; display: flex; align-items: center; text-decoration: none; }
    .sidebar-nav-link:hover { background-color: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
    .sidebar-nav-link.active { font-weight: 700; color: var(--color-primary); background-color: rgba(16, 185, 129, 0.1); }
    
    .sidebar-x.collapsed { width: 80px !important; }
    .sidebar-x.collapsed .sidebar-text { display: none; }
    .sidebar-x.collapsed .sidebar-header { justify-content: center; padding-left: 0 !important; }
    .sidebar-x.collapsed .sidebar-nav-link { justify-content: center; width: 50px; height: 50px; padding: 0; margin: 0 auto 10px auto; }
</style>
