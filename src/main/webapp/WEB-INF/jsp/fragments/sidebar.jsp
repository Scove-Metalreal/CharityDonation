<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Mobile Toggle Button (Floating) -->
<button class="btn btn-brand-primary rounded-circle shadow-lg d-lg-none mobile-drawer-btn" onclick="openSidebar()">
    <i class="fas fa-bars"></i>
</button>

<!-- Overlay for mobile -->
<div class="sidebar-overlay" id="sidebarOverlay" onclick="closeSidebar()"></div>

<div class="sidebar-x shadow-sm d-flex flex-column h-100" id="mainSidebar">
    <!-- Resizer handle -->
    <div class="sidebar-resizer" id="sidebarResizer"></div>

    <div class="sidebar-header mb-4 ps-3 pt-3 d-flex align-items-center justify-content-between">
        <a href="${pageContext.request.contextPath}/" class="text-decoration-none logo-container d-flex align-items-center">
            <i class="fas fa-hand-holding-heart fa-2x logo-primary logo-icon"></i>
            <span class="fs-4 fw-bold text-dark ms-2 sidebar-text">Charity</span>
        </a>
        <button class="btn btn-sm btn-light rounded-circle d-lg-none" onclick="closeSidebar()">
            <i class="fas fa-times"></i>
        </button>
    </div>
    
    <nav class="nav flex-column mb-4 px-2 overflow-hidden">
        <a class="nav-link sidebar-nav-link ${currentPage == 'home' ? 'active' : ''}" href="${pageContext.request.contextPath}/#hero">
            <i class="fas fa-home"></i> <span class="sidebar-text ms-3">Trang chủ</span>
        </a>
        <a class="nav-link sidebar-nav-link" href="${pageContext.request.contextPath}/#campaigns">
            <i class="fas fa-bullhorn"></i> <span class="sidebar-text ms-3">Chiến dịch</span>
        </a>
        <a class="nav-link sidebar-nav-link" href="${pageContext.request.contextPath}/#partners">
            <i class="fas fa-handshake"></i> <span class="sidebar-text ms-3">Nhà đồng hành</span>
        </a>
        <a class="nav-link sidebar-nav-link" href="${pageContext.request.contextPath}/#faq">
            <i class="fas fa-question-circle"></i> <span class="sidebar-text ms-3">Q&A</span>
        </a>
        <c:if test="${sessionScope.loggedInUser.role.roleName == 'ADMIN'}">
            <hr class="my-2 opacity-10 sidebar-text">
            <a class="nav-link text-danger fw-bold sidebar-nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="fas fa-user-shield"></i> <span class="sidebar-text ms-3">Admin Panel</span>
            </a>
        </c:if>
    </nav>

    <div class="px-3 mb-4 donate-btn-container">
        <a href="${pageContext.request.contextPath}/#campaigns" class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold shadow-sm d-flex align-items-center justify-content-center">
            <i class="fas fa-plus"></i>
            <span class="sidebar-text ms-2">QUYÊN GÓP NGAY</span>
        </a>
    </div>

    <!-- User Profile / Auth Section (At bottom) -->
    <div class="mt-auto p-3 border-top">
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <div class="dropdown">
                    <div class="sidebar-user-mini d-flex align-items-center cursor-pointer" data-bs-toggle="dropdown">
                        <img src="${not empty sessionScope.loggedInUser.avatarUrl ? sessionScope.loggedInUser.avatarUrl : 'https://ui-avatars.com/api/?name='.concat(sessionScope.loggedInUser.fullName).concat('&background=10B981&color=fff')}" class="rounded-circle shadow-sm" width="40" height="40">
                        <div class="overflow-hidden ms-3 sidebar-text">
                            <div class="fw-bold text-dark text-truncate" style="max-width: 120px;">${sessionScope.loggedInUser.fullName}</div>
                            <div class="text-muted smallest text-truncate">@user_${sessionScope.loggedInUser.id}</div>
                        </div>
                    </div>
                    <ul class="dropdown-menu dropdown-menu-dark shadow border-0 rounded-4 p-2 mb-2">
                        <li><a class="dropdown-item rounded-3" href="${pageContext.request.contextPath}/user/profile"><i class="fas fa-user me-2"></i> Hồ sơ</a></li>
                        <c:if test="${sessionScope.loggedInUser.role.roleName == 'ADMIN'}">
                            <li><a class="dropdown-item rounded-3 text-warning" href="${pageContext.request.contextPath}/admin/dashboard"><i class="fas fa-user-shield me-2"></i> Dashboard</a></li>
                        </c:if>
                        <li><hr class="dropdown-divider opacity-10"></li>
                        <li><a class="dropdown-item rounded-3 text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </c:when>
            <c:otherwise>
                <div class="auth-buttons">
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-brand-secondary w-100 rounded-pill mb-2 fw-bold d-flex align-items-center justify-content-center">
                        <i class="fas fa-sign-in-alt"></i> <span class="sidebar-text ms-2">Đăng nhập</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-brand-primary w-100 rounded-pill fw-bold d-flex align-items-center justify-content-center">
                        <i class="fas fa-user-plus"></i> <span class="sidebar-text ms-2">Đăng ký</span>
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    const sidebar = document.getElementById('mainSidebar');
    const resizer = document.getElementById('sidebarResizer');
    const overlay = document.getElementById('sidebarOverlay');
    const MIN_WIDTH = 80;
    const MAX_WIDTH = 400;
    const SNAP_MIN = 120;

    // Load saved width
    const savedWidth = localStorage.getItem('sidebar-width');
    if (savedWidth && window.innerWidth >= 992) {
        applyWidth(parseInt(savedWidth));
    }

    function applyWidth(width) {
        if (width <= SNAP_MIN) {
            sidebar.classList.add('collapsed');
            sidebar.style.width = '80px';
            document.documentElement.style.setProperty('--sidebar-width', '80px');
        } else {
            sidebar.classList.remove('collapsed');
            sidebar.style.width = width + 'px';
            document.documentElement.style.setProperty('--sidebar-width', width + 'px');
        }
    }

    // Resizing logic
    let isResizing = false;

    resizer.addEventListener('mousedown', (e) => {
        isResizing = true;
        document.body.style.cursor = 'col-resize';
        document.body.style.userSelect = 'none';
    });

    document.addEventListener('mousemove', (e) => {
        if (!isResizing) return;
        
        let newWidth = e.clientX;
        if (newWidth < MIN_WIDTH) newWidth = MIN_WIDTH;
        if (newWidth > MAX_WIDTH) newWidth = MAX_WIDTH;
        
        applyWidth(newWidth);
        localStorage.setItem('sidebar-width', newWidth);
    });

    document.addEventListener('mouseup', () => {
        isResizing = false;
        document.body.style.cursor = 'default';
        document.body.style.userSelect = 'auto';
    });

    // Mobile Drawer logic
    function openSidebar() {
        sidebar.classList.add('mobile-open');
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeSidebar() {
        sidebar.classList.remove('mobile-open');
        overlay.classList.remove('active');
        document.body.style.overflow = 'auto';
    }
</script>

<style>
    :root {
        --sidebar-width: 280px;
    }
    
    .logo-primary {
        color: var(--color-primary) !important;
    }
    
    .sidebar-x { 
        width: var(--sidebar-width); 
        background: white;
        transition: width 0.1s ease, transform 0.3s ease; 
        position: relative;
        z-index: 1100;
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
    }
    .sidebar-resizer:hover { background: var(--color-primary); opacity: 0.3; }

    .sidebar-nav-link { padding: 12px 15px; border-radius: 99px; margin-bottom: 5px; color: #333; display: flex; align-items: center; white-space: nowrap; }
    .sidebar-nav-link:hover { background-color: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
    .sidebar-nav-link i { font-size: 1.25rem; width: 24px; text-align: center; }
    .sidebar-nav-link.active { font-weight: 700; color: var(--color-primary); background-color: rgba(16, 185, 129, 0.1); }
    
    /* Collapsed state (Mini Mode) */
    .sidebar-x.collapsed { width: 80px !important; }
    .sidebar-x.collapsed .sidebar-text { display: none; }
    .sidebar-x.collapsed .sidebar-header { justify-content: center; padding-left: 0 !important; }
    .sidebar-x.collapsed .sidebar-nav-link { justify-content: center; padding: 12px 0; }
    .sidebar-x.collapsed .sidebar-nav-link i { margin: 0 !important; }
    .sidebar-x.collapsed .donate-btn-container .btn span { display: none; }
    .sidebar-x.collapsed .donate-btn-container .btn { border-radius: 50%; width: 50px; height: 50px; padding: 0; margin: 0 auto; }
    .sidebar-x.collapsed .auth-buttons .btn span { display: none; }
    .sidebar-x.collapsed .auth-buttons .btn { border-radius: 50%; width: 45px; height: 45px; padding: 0; margin: 0 auto 10px auto; }

    /* Mobile handling */
    .mobile-drawer-btn {
        position: fixed;
        bottom: 20px;
        right: 20px;
        z-index: 1000;
        width: 60px;
        height: 60px;
        font-size: 1.5rem;
    }

    .sidebar-overlay {
        position: fixed;
        top: 0; left: 0; right: 0; bottom: 0;
        background: rgba(0,0,0,0.5);
        opacity: 0;
        visibility: hidden;
        transition: 0.3s;
        z-index: 1040;
    }
    .sidebar-overlay.active { opacity: 1; visibility: visible; }

    @media (max-width: 991.98px) {
        .sidebar-x {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            width: 280px !important;
            transform: translateX(-100%);
            box-shadow: none;
        }
        .sidebar-x.mobile-open { transform: translateX(0); box-shadow: 10px 0 30px rgba(0,0,0,0.1); }
        .sidebar-resizer { display: none; }
        .sidebar-x.collapsed { width: 280px !important; }
        .sidebar-x.collapsed .sidebar-text { display: inline; }
    }
</style>
