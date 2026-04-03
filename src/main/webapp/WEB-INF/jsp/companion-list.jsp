<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đối tác đồng hành - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .brand-primary { color: var(--color-primary) !important; }
        
        .companion-sidebar { background: #f8fafc; border-right: 1px solid #e2e8f0; height: 100vh; overflow-y: auto; }
        .companion-item { 
            padding: 20px; cursor: pointer; transition: 0.2s; border-bottom: 1px solid #f1f5f9;
            display: flex; align-items: center; gap: 15px; border-left: 4px solid transparent;
        }
        .companion-item:hover { background: #fff; }
        .companion-item.active { background: #fff; border-left-color: var(--color-primary); }
        .companion-logo-sm { width: 45px; height: 45px; object-fit: contain; border-radius: 10px; background: white; padding: 5px; border: 1px solid #f1f5f9; }
        
        .detail-content { padding: 40px; }
        .detail-card { border-radius: 20px; border: none; overflow: hidden; background: white; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .detail-header { background: #f8fafc; padding: 40px; text-align: center; border-bottom: 1px solid #f1f5f9; }
        .detail-logo-lg { width: 100px; height: 100px; object-fit: contain; margin-bottom: 20px; }
        .detail-body { padding: 40px; }
        .mini-card { border: 1px solid #eee; border-radius: 12px; padding: 10px; margin-bottom: 10px; text-decoration: none; color: inherit; display: flex; align-items: center; gap: 10px; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <div class="col-auto p-0 border-end" style="z-index: 1000;">
                <c:set var="currentPage" value="partners" scope="request"/>
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <div class="col-auto p-0 companion-sidebar" style="width: 300px;">
                <div class="p-4 border-bottom bg-white">
                    <h5 class="fw-bold mb-0">Đối tác</h5>
                </div>
                <div class="companion-list">
                    <c:forEach var="c" items="${companions}">
                        <div class="companion-item ${selectedCompanion.id == c.id ? 'active' : ''}" 
                             onclick="window.location.href='?id=${c.id}'">
                            <img src="${c.logoUrl}" class="companion-logo-sm">
                            <div class="overflow-hidden">
                                <div class="fw-bold text-dark text-truncate">${c.name}</div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col scrollable-main p-0">
                <div class="detail-content">
                    <c:if test="${not empty selectedCompanion}">
                        <div class="detail-card">
                            <div class="detail-header">
                                <img src="${selectedCompanion.logoUrl}" class="detail-logo-lg">
                                <h2 class="fw-bold text-dark">${selectedCompanion.name}</h2>
                            </div>
                            <div class="detail-body">
                                <div class="row">
                                    <div class="col-md-7">
                                        <h5 class="fw-bold mb-3">Giới thiệu</h5>
                                        <p class="text-muted">${selectedCompanion.description}</p>
                                    </div>
                                    <div class="col-md-5">
                                        <h5 class="fw-bold mb-3">Chiến dịch đồng hành</h5>
                                        <c:forEach var="camp" items="${selectedCompanion.campaigns}">
                                            <a href="${pageContext.request.contextPath}/campaign/${camp.id}" class="mini-card">
                                                <img src="${camp.imageUrl}" width="50" height="50" class="rounded">
                                                <div class="small fw-bold text-truncate">${camp.name}</div>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <jsp:include page="fragments/footer.jsp"/>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
