<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Đối tác đồng hành - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .brand-primary { color: var(--color-primary) !important; }

        .companion-sidebar { 
            background: #f8fafc; 
            border-right: 1px solid #e2e8f0; 
            height: 100vh; 
            overflow-y: auto;
            width: 350px;
            transition: all 0.3s ease;
        }
        
        .companion-item { 
            padding: 20px; 
            cursor: pointer; 
            transition: 0.2s; 
            border-bottom: 1px solid #f1f5f9;
            display: flex; 
            align-items: center; 
            gap: 15px; 
            border-left: 4px solid transparent;
        }
        .companion-item:hover { background: #fff; }
        .companion-item.active { background: #fff; border-left-color: var(--color-primary); }
        .companion-logo-sm { width: 45px; height: 45px; object-fit: contain; border-radius: 10px; background: white; padding: 5px; border: 1px solid #f1f5f9; }

        .detail-card { border-radius: 24px; border: none; overflow: hidden; background: white; box-shadow: 0 10px 40px rgba(0,0,0,0.04); }
        .detail-header { background: #f8fafc; padding: 40px 20px; text-align: center; border-bottom: 1px solid #f1f5f9; }
        .detail-logo-lg { width: 120px; height: 120px; object-fit: contain; margin-bottom: 20px; filter: drop-shadow(0 4px 6px rgba(0,0,0,0.05)); }
        .detail-body { padding: 40px; }
        
        .mini-card { 
            border: 1px solid #f1f5f9; 
            border-radius: 16px; 
            padding: 12px; 
            margin-bottom: 12px; 
            text-decoration: none; 
            color: inherit; 
            display: flex; 
            align-items: center; 
            gap: 12px;
            transition: 0.3s;
            background: white;
        }
        .mini-card:hover { border-color: var(--color-primary); transform: translateX(5px); box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .mini-card img { border-radius: 10px; object-fit: cover; }

        @media (max-width: 991.98px) {
            .companion-sidebar { 
                height: auto; 
                width: 100%; 
                border-right: none; 
                border-bottom: 1px solid #e2e8f0;
                padding: 10px 0;
            }
            .companion-list { 
                display: flex; 
                overflow-x: auto; 
                padding: 10px 20px;
                gap: 10px;
                scrollbar-width: none;
            }
            .companion-list::-webkit-scrollbar { display: none; }
            
            .companion-item { 
                flex: 0 0 auto; 
                padding: 10px 20px; 
                border-radius: 50rem; 
                border: 1px solid #e2e8f0; 
                background: white;
                border-left: 1px solid #e2e8f0;
            }
            .companion-item.active { 
                background: var(--color-primary); 
                color: white; 
                border-color: var(--color-primary); 
            }
            .companion-item.active .text-dark { color: white !important; }
            .companion-item .companion-logo-sm { width: 30px; height: 30px; }
            
            .detail-body { padding: 30px 20px; }
            .detail-header { padding: 30px 20px; }
        }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap g-0">
            <!-- Sidebar (Main) -->
            <div class="col-auto p-0 border-end" style="z-index: 1035;">
                <c:set var="currentPage" value="partners" scope="request"/>
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <!-- Content Area -->
            <div class="col scrollable-main p-0 d-flex flex-column flex-lg-row">
                
                <!-- 1. Master List Section -->
                <div class="companion-sidebar shadow-sm">
                    <div class="p-4 border-bottom bg-white d-none d-lg-block">
                        <h5 class="fw-bold mb-0">Đối tác đồng hành</h5>
                        <small class="text-muted">Danh sách các tổ chức kết nối</small>
                    </div>
                    <div class="companion-list">
                        <c:forEach var="c" items="${companions}">
                            <div class="companion-item ${selectedCompanion.id == c.id ? 'active' : ''}" 
                                 onclick="window.location.href='?id=${c.id}'">
                                <img src="${c.logoUrl}" class="companion-logo-sm shadow-sm">
                                <div class="overflow-hidden">
                                    <div class="fw-bold text-dark text-nowrap">${c.name}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- 2. Detail Content Section -->
                <div class="flex-grow-1 p-3 p-md-4 p-xl-5">
                    <c:if test="${not empty selectedCompanion}">
                        <div class="detail-card shadow-sm mx-auto" style="max-width: 1000px;">
                            <div class="detail-header">
                                <img src="${selectedCompanion.logoUrl}" class="detail-logo-lg">
                                <h2 class="fw-bold text-dark mb-1">${selectedCompanion.name}</h2>
                                <span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3 py-2 fw-bold small">ĐỐI TÁC CHIẾN LƯỢC</span>
                            </div>
                            <div class="detail-body">
                                <div class="row g-5">
                                    <div class="col-lg-7">
                                        <h5 class="fw-bold mb-4 d-flex align-items-center">
                                            <i class="fas fa-info-circle brand-primary me-2"></i> Giới thiệu
                                        </h5>
                                        <div class="text-muted" style="line-height: 1.8; text-align: justify;">
                                            ${selectedCompanion.description}
                                        </div>
                                    </div>
                                    <div class="col-lg-5">
                                        <h5 class="fw-bold mb-4 d-flex align-items-center">
                                            <i class="fas fa-bullhorn brand-primary me-2"></i> Chiến dịch đồng hành
                                        </h5>
                                        <div class="row g-2 row-cols-1 row-cols-md-2 row-cols-lg-1">
                                            <c:forEach var="camp" items="${selectedCompanion.campaigns}">
                                                <div class="col">
                                                    <a href="${pageContext.request.contextPath}/campaign/${camp.id}" class="mini-card">
                                                        <img src="${not empty camp.imageUrl ? camp.imageUrl : 'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80'}" 
                                                             width="60" height="60" class="shadow-sm">
                                                        <div class="overflow-hidden">
                                                            <div class="small fw-bold text-dark text-truncate">${camp.name}</div>
                                                            <div class="smallest text-muted">Xem chi tiết <i class="fas fa-arrow-right ms-1" style="font-size: 0.6rem;"></i></div>
                                                        </div>
                                                    </a>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <c:if test="${empty selectedCompanion.campaigns}">
                                            <div class="p-4 text-center bg-light rounded-4 text-muted small">
                                                Hiện chưa có chiến dịch nào được ghi nhận.
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty selectedCompanion}">
                        <div class="h-100 d-flex flex-column align-items-center justify-content-center py-5 text-center">
                            <i class="fas fa-handshake fa-4x text-muted opacity-25 mb-4"></i>
                            <h4 class="fw-bold text-muted">Vui lòng chọn một đối tác</h4>
                            <p class="text-muted small">Khám phá thông tin và các hoạt động của các nhà đồng hành cùng chúng tôi</p>
                        </div>
                    </c:if>
                    
                    <!-- Footer inside scrollable area -->
                    <jsp:include page="fragments/footer.jsp"/>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
