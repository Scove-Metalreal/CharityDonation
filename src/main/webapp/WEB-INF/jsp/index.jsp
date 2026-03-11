<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Trang chủ - Quyên Góp Từ Thiện</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

    <header>
        <h1>Website Quyên Góp Từ Thiện</h1>
    </header>

    <main>
        <h2>Các chiến dịch quyên góp</h2>
        <div class="campaign-list">
            <c:if test="${empty campaigns}">
                <p>Hiện chưa có chiến dịch nào.</p>
            </c:if>
            <c:forEach var="campaign" items="${campaigns}">
                <div class="campaign-card">
                    <h3><c:out value="${campaign.name}"/></h3>
                    <p><c:out value="${campaign.background}"/></p>
                    <p>Mục tiêu: <c:out value="${campaign.targetMoney}"/> VNĐ</p>
                    <p>Hiện tại: <c:out value="${campaign.currentMoney}"/> VNĐ</p>
                    <a href="${pageContext.request.contextPath}/campaign/${campaign.id}">Chi tiết</a>
                </div>
            </c:forEach>
        </div>
    </main>

</body>
</html>
