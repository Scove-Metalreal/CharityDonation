<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="sidebar-x shadow-sm border-end d-flex flex-column" id="adminSidebar" style="background: #fff; z-index: 1100;">
    <!-- Resizer handle -->
    <div class="sidebar-resizer" id="adminSidebarResizer"></div>

    <div class="sidebar-header mb-4 ps-3 pt-3 d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none d-flex align-items-center">
            <i class="fas fa-hand-holding-heart fa-2x brand-primary"></i>
            <div class="ms-2 sidebar-text">
                <span class="fs-4 fw-bold text-dark">Charity</span>
                <div class="text-muted smallest fw-bold">ADMIN PANEL</div>
            </div>
        </a>
        <button class="btn btn-sm btn-light rounded-circle me-2 sidebar-toggle-btn" onclick="toggleAdminSidebar()" style="z-index: 1200;">
            <i class="fas fa-chevron-left" id="adminToggleIcon"></i>
        </button>
    </div>
    
    <nav class="nav flex-column mb-4 px-2 flex-grow-1 overflow-hidden">
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
    <div class="mt-auto p-3 border-top bg-white" style="z-index: 1200;">
        <div class="dropdown">
            <div class="sidebar-user-mini d-flex align-items-center cursor-pointer" data-bs-toggle="dropdown">
                <img src="${not empty sessionScope.loggedInUser.avatarUrl ? sessionScope.loggedInUser.avatarUrl : 'https://ui-avatars.com/api/?name='.concat(sessionScope.loggedInUser.fullName).concat('&background=10B981&color=fff')}" class="rounded-circle shadow-sm" width="40" height="40">
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
    const adminSidebar = document.getElementById('adminSidebar');
    const adminResizer = document.getElementById('adminSidebarResizer');
    const MIN_WIDTH_ADMIN = 80;
    const MAX_WIDTH_ADMIN = 400;
    const SNAP_MIN_ADMIN = 120;

    // Load saved width
    const savedAdminWidth = localStorage.getItem('admin-sidebar-width');
    if (savedAdminWidth) {
        applyAdminWidth(parseInt(savedAdminWidth));
    }

    function applyAdminWidth(width) {
        const icon = document.getElementById('adminToggleIcon');
        if (width <= SNAP_MIN_ADMIN) {
            adminSidebar.classList.add('collapsed');
            adminSidebar.style.width = '80px';
            if(icon) icon.classList.replace('fa-chevron-left', 'fa-chevron-right');
        } else {
            adminSidebar.classList.remove('collapsed');
            adminSidebar.style.width = width + 'px';
            if(icon) icon.classList.replace('fa-chevron-right', 'fa-chevron-left');
        }
    }

    function toggleAdminSidebar() {
        const icon = document.getElementById('adminToggleIcon');
        if (adminSidebar.classList.contains('collapsed')) {
            applyAdminWidth(280);
            localStorage.setItem('admin-sidebar-width', '280');
        } else {
            applyAdminWidth(80);
            localStorage.setItem('admin-sidebar-width', '80');
        }
    }

    // Resizing logic
    let isAdminResizing = false;

    adminResizer.addEventListener('mousedown', (e) => {
        isAdminResizing = true;
        document.body.style.cursor = 'col-resize';
        document.body.style.userSelect = 'none';
    });

    document.addEventListener('mousemove', (e) => {
        if (!isAdminResizing) return;
        
        let newWidth = e.clientX;
        if (newWidth < MIN_WIDTH_ADMIN) newWidth = MIN_WIDTH_ADMIN;
        if (newWidth > MAX_WIDTH_ADMIN) newWidth = MAX_WIDTH_ADMIN;
        
        applyAdminWidth(newWidth);
        localStorage.setItem('admin-sidebar-width', newWidth);
    });

    document.addEventListener('mouseup', () => {
        isAdminResizing = false;
        document.body.style.cursor = 'default';
        document.body.style.userSelect = 'auto';
    });
</script>

<style>
    .brand-primary { color: var(--color-primary) !important; }
    .sidebar-x { 
        width: 280px; 
        transition: width 0.1s ease; 
        height: 100vh; 
        position: sticky; 
        top: 0; 
        overflow: hidden; 
        display: flex;
        flex-direction: column;
    }
    
    .sidebar-resizer {
        position: absolute;
        right: 0;
        top: 0;
        bottom: 0;
        width: 4px;
        cursor: col-resize;
        background: transparent;
        transition: background 0.2s;
        z-index: 1110;
    }
    .sidebar-resizer:hover { background: var(--color-primary); opacity: 0.3; }

    .sidebar-nav-link { padding: 12px 15px; border-radius: 99px; margin-bottom: 5px; color: #333; display: flex; align-items: center; text-decoration: none; white-space: nowrap; }
    .sidebar-nav-link:hover { background-color: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
    .sidebar-nav-link.active { font-weight: 700; color: var(--color-primary); background-color: rgba(16, 185, 129, 0.1); }
    
    .sidebar-x.collapsed { width: 80px !important; }
    .sidebar-x.collapsed .sidebar-text { display: none; }
    .sidebar-x.collapsed .sidebar-header { justify-content: center; padding-left: 0 !important; }
    .sidebar-x.collapsed .sidebar-nav-link { justify-content: center; padding: 12px 0; }
    .sidebar-x.collapsed .sidebar-nav-link i { margin: 0 !important; }
</style>
