<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập - Quyên Góp Từ Thiện</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="auth-container">
        <h2>Đăng nhập</h2>
        <c:if test="${param.success eq 'register'}">
            <p style="color: green;">Đăng ký thành công! Mời bạn đăng nhập.</p>
        </c:if>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/auth/login" method="post">
            <div>
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>
            <div>
                <label>Mật khẩu:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Đăng nhập</button>
        </form>
        <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/auth/register">Đăng ký ngay</a></p>
    </div>
</body>
</html>
