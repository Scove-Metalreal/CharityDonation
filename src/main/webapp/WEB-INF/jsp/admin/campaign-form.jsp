<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${campaign.id == null ? 'Tạo mới' : 'Cập nhật'} Chiến dịch - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .admin-content { margin-left: 260px; padding: 20px; min-height: 100vh; background: var(--color-bg-light); }
        .admin-sidebar { width: 260px; height: 100vh; position: fixed; left: 0; top: 0; background: #fff; border-right: 1px solid var(--color-border); z-index: 1000; }
        .nav-link-admin { padding: 12px 20px; border-radius: 8px; color: var(--color-text-main); margin: 5px 15px; display: flex; align-items: center; text-decoration: none; transition: var(--transition); }
        .nav-link-admin:hover, .nav-link-admin.active { background: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="admin-sidebar shadow-sm d-none d-md-block">
        <div class="p-4 text-center border-bottom mb-3">
            <h4 class="text-primary fw-bold mb-0"><i class="fas fa-hand-holding-heart me-2"></i>Charity</h4>
            <small class="text-muted">QUẢN TRỊ HỆ THỐNG</small>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-admin">
            <i class="fas fa-chart-line"></i> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-admin">
            <i class="fas fa-users"></i> Quản lý Người dùng
        </a>
        <a href="${pageContext.request.contextPath}/admin/campaigns" class="nav-link-admin active">
            <i class="fas fa-bullhorn"></i> Quản lý Chiến dịch
        </a>
        <a href="${pageContext.request.contextPath}/admin/donations" class="nav-link-admin">
            <i class="fas fa-check-circle"></i> Xác nhận quyên góp
        </a>
        <hr class="mx-3 opacity-10">
        <a href="${pageContext.request.contextPath}/" class="nav-link-admin">
            <i class="fas fa-external-link-alt"></i> Xem Trang chủ
        </a>
    </div>

    <!-- Main Content -->
    <div class="admin-content">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h5 class="fw-bold mb-0">${campaign.id == null ? 'TẠO CHIẾN DỊCH MỚI' : 'CẬP NHẬT CHIẾN DỊCH'}</h5>
                <a href="${pageContext.request.contextPath}/admin/campaigns" class="btn btn-light btn-sm rounded-pill border px-3">Quay lại</a>
            </div>

            <div class="card border-0 shadow-sm p-4">
                <form action="${pageContext.request.contextPath}/admin/campaigns/save" method="post">
                    <input type="hidden" name="id" value="${campaign.id}">
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Tên chiến dịch</label>
                            <input type="text" name="name" class="form-control" value="${campaign.name}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Mã chiến dịch (Duy nhất)</label>
                            <input type="text" name="code" class="form-control" value="${campaign.code}" required ${campaign.id != null ? 'readonly' : ''}>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label small fw-bold">Ngày bắt đầu</label>
                            <input type="date" name="startDate" class="form-control" value="${campaign.startDate}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">Ngày kết thúc</label>
                            <input type="date" name="endDate" class="form-control" value="${campaign.endDate}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold">Mục tiêu quyên góp (VNĐ)</label>
                            <input type="number" name="targetMoney" class="form-control" value="${campaign.targetMoney}" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-bold">SĐT Người thụ hưởng</label>
                            <input type="text" name="beneficiaryPhone" class="form-control" value="${campaign.beneficiaryPhone}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="0" ${campaign.status == 0 ? 'selected' : ''}>Mới tạo</option>
                                <option value="1" ${campaign.status == 1 ? 'selected' : ''}>Đang diễn ra</option>
                                <option value="2" ${campaign.status == 2 ? 'selected' : ''}>Đã kết thúc</option>
                                <option value="3" ${campaign.status == 3 ? 'selected' : ''}>Đóng quỹ</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-bold">Mô tả ngắn (Background)</label>
                            <textarea name="background" class="form-control" rows="2">${campaign.background}</textarea>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-bold">Nội dung chi tiết (HTML)</label>
                            <textarea name="content" class="form-control" rows="10">${campaign.content}</textarea>
                        </div>

                        <div class="col-12 text-end">
                            <hr class="my-4 opacity-10">
                            <button type="submit" class="btn btn-primary px-5 py-2 rounded-pill shadow-sm">LƯU CHIẾN DỊCH</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
