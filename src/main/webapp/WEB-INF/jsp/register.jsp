<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký - Quyên Góp Từ Thiện</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <div class="auth-container">
        <h2>Đăng ký tài khoản</h2>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        <form action="${pageContext.request.contextPath}/auth/register" method="post">
            <div>
                <label>Họ và tên:</label>
                <input type="text" name="fullName" required>
            </div>
            <div>
                <label>Email:</label>
                <input type="email" name="email" required>
            </div>
            <div>
                <label>Mật khẩu:</label>
                <input type="password" name="password" required>
            </div>
            <div>
                <label>Số điện thoại:</label>
                <input type="text" name="phoneNumber">
            </div>
            <div>
                <label>Địa chỉ:</label>
                <input type="text" name="address">
            </div>
            <button type="submit">Đăng ký</button>
        </form>
        <p>Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập ngay</a></p>
    </div>
</body>
</html>
