<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết chiến dịch</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <header>
        <h1>Chi tiết chiến dịch</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/">Trang chủ</a> | 
            <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
        </nav>
    </header>

    <main>
        <h2><c:out value="${campaign.name}"/></h2>
        <p><strong>Mã chiến dịch:</strong> <c:out value="${campaign.code}"/></p>
        <p><strong>Mô tả:</strong> <c:out value="${campaign.background}"/></p>
        <p><strong>Mục tiêu:</strong> <c:out value="${campaign.targetMoney}"/> VNĐ</p>
        <p><strong>Đã quyên góp:</strong> <c:out value="${campaign.currentMoney}"/> VNĐ</p>
        <p><strong>Ngày bắt đầu:</strong> <c:out value="${campaign.startDate}"/></p>
        <p><strong>Ngày kết thúc:</strong> <c:out value="${campaign.endDate}"/></p>
        
        <hr>
        <p><em>Chức năng quyên góp đang được phát triển...</em></p>
    </main>
</body>
</html>
