<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 
    Parameters:
    - campaign: The Campaign entity
    - isCompact: boolean (optional, for sidebar/smaller versions)
--%>

<a href="${pageContext.request.contextPath}/campaign/${campaign.id}" class="text-decoration-none donation-card-wrapper">
    <div class="card h-100 border-0 shadow-sm donation-card ${isCompact ? 'compact-card' : ''}">
        <div class="position-relative">
            <img src="${not empty campaign.imageUrl ? campaign.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'}" 
                 class="card-img-top campaign-card-img" alt="${campaign.name}">
            <c:choose>
                <c:when test="${campaign.status == 0}"><span class="badge bg-info status-badge shadow-sm">Mới tạo</span></c:when>
                <c:when test="${campaign.status == 1}"><span class="badge bg-success status-badge shadow-sm">Đang diễn ra</span></c:when>
                <c:when test="${campaign.status == 2}"><span class="badge bg-warning status-badge shadow-sm">Đã kết thúc</span></c:when>
                <c:when test="${campaign.status == 3}"><span class="badge bg-secondary status-badge shadow-sm">Đóng quỹ</span></c:when>
            </c:choose>
        </div>
        <div class="card-body p-3">
            <h6 class="card-title fw-bold text-dark mb-1 campaign-name-text line-clamp-2">${campaign.name}</h6>
            
            <!-- Companion Info -->
            <div class="d-flex align-items-center mb-3">
                <c:choose>
                    <c:when test="${not empty campaign.companions}">
                        <img src="${not empty campaign.companions[0].logoUrl ? campaign.companions[0].logoUrl : 'https://ui-avatars.com/api/?name=' + campaign.companions[0].name + '&background=random'}" 
                             class="rounded-circle me-2 border" width="24" height="24" style="object-fit: cover;">
                        <span class="smallest text-muted text-truncate fw-medium">${campaign.companions[0].name}</span>
                    </c:when>
                    <c:otherwise>
                        <img src="https://ui-avatars.com/api/?name=Charity&background=10B981&color=fff" 
                             class="rounded-circle me-2 border" width="24" height="24">
                        <span class="smallest text-muted fw-medium">Charity Foundation</span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <c:set var="target" value="${campaign.targetMoney != null && campaign.targetMoney != 0 ? campaign.targetMoney : 1}"/>
            <c:set var="current" value="${campaign.currentMoney != null ? campaign.currentMoney : 0}"/>
            <c:set var="percent" value="${(current / target) * 100}"/>
            
            <div class="d-flex justify-content-between align-items-end mb-2">
                <div class="stats-left">
                    <div class="small fw-bold text-dark"><fmt:formatNumber value="${current}" type="number"/>đ</div>
                    <div class="text-muted smallest">quyên góp</div>
                </div>
                <div class="stats-right text-end">
                    <div class="small fw-bold text-primary"><fmt:formatNumber value="${percent}" maxFractionDigits="0"/>%</div>
                    <div class="text-muted smallest">đạt được</div>
                </div>
            </div>
            
            <div class="progress mb-3" style="height: 6px; background-color: #eee;">
                <div class="progress-bar" role="progressbar" style="width: ${percent > 100 ? 100 : percent}%" 
                     aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100"></div>
            </div>
            
            <div class="d-flex justify-content-between align-items-center">
                <div class="smallest text-muted">
                    <i class="far fa-clock me-1"></i> Còn ${campaign.endDate}
                </div>
                <div class="btn btn-outline-primary btn-sm rounded-pill px-3 py-1 fw-bold donate-btn-indicator">
                    Quyên góp
                </div>
            </div>
        </div>
    </div>
</a>

<style>
    .donation-card-wrapper { display: block; height: 100%; }
    .donation-card { transition: all 0.3s cubic-bezier(.25,.8,.25,1); border-radius: 16px; overflow: hidden; background: white; }
    .donation-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
    
    /* Hover effects requested: name and button change color */
    .donation-card-wrapper:hover .campaign-name-text { color: var(--color-primary) !important; }
    .donation-card-wrapper:hover .donate-btn-indicator { background-color: var(--color-primary) !important; color: white !important; }
    
    .campaign-card-img { height: 180px; object-fit: cover; width: 100%; }
    .status-badge { position: absolute; top: 12px; left: 12px; padding: 5px 12px; border-radius: 20px; font-size: 0.7rem; font-weight: 700; z-index: 2; }
    
    .line-clamp-2 {
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;  
        overflow: hidden;
    }
    .smallest { font-size: 0.75rem; }
    
    /* Compact version for sidebar */
    .compact-card .campaign-card-img { height: 120px; }
    .compact-card .card-body { padding: 12px; }
</style>
