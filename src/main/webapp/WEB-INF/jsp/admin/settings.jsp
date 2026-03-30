﻿<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Cài đặt hệ thống - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0">
                <c:set var="activePage" value="admin-settings" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <!-- Top Navbar -->
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white border-0 py-3"><h6 class="fw-bold mb-0">CÀI ĐẶT CHUNG</h6></div>
                                <div class="card-body p-4 pt-0">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Tên nền tảng</label>
                                        <input type="text" class="form-control rounded-pill px-3" value="Charity Donation Platform">
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Email hệ thống</label>
                                        <input type="email" class="form-control rounded-pill px-3" value="contact@charity.vn">
                                    </div>
                                    <button class="btn btn-brand-primary rounded-pill px-4 fw-bold mt-2">Cập nhật</button>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card border-0 shadow-sm h-100">
                                <div class="card-header bg-white border-0 py-3"><h6 class="fw-bold mb-0">CẤU HÌNH QUYÊN GÓP</h6></div>
                                <div class="card-body p-4 pt-0">
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Số tiền quyên góp tối thiểu</label>
                                        <div class="input-group">
                                            <input type="number" class="form-control rounded-start-pill ps-3" value="10000">
                                            <span class="input-group-text rounded-end-pill pe-3 bg-light">VNĐ</span>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label small fw-bold">Phí nền tảng (%)</label>
                                        <input type="number" class="form-control rounded-pill px-3" value="0">
                                    </div>
                                    <button class="btn btn-brand-primary rounded-pill px-4 fw-bold mt-2">Cập nhật</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
