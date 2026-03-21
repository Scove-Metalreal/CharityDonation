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
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-lg-2 col-xl-2 d-none d-lg-block p-0 position-fixed" style="height: 100vh;">
                <c:set var="currentPage" value="admin-campaigns" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col-lg-10 offset-lg-2 py-0">
                <!-- Top Navbar -->
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <div class="card border-0 shadow-sm p-4">
                        <form action="${pageContext.request.contextPath}/admin/campaigns/save" method="post">
                            <input type="hidden" name="id" value="${campaign.id}">
                            
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Tên chiến dịch</label>
                                    <input type="text" name="name" class="form-control rounded-pill px-3" value="${campaign.name}" required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Mã chiến dịch (Duy nhất)</label>
                                    <input type="text" name="code" class="form-control rounded-pill px-3" value="${campaign.code}" required ${campaign.id != null ? 'readonly' : ''}>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Ngày bắt đầu</label>
                                    <input type="date" name="startDate" class="form-control rounded-pill px-3" value="${campaign.startDate}" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Ngày kết thúc</label>
                                    <input type="date" name="endDate" class="form-control rounded-pill px-3" value="${campaign.endDate}" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Mục tiêu quyên góp (VNĐ)</label>
                                    <input type="number" name="targetMoney" class="form-control rounded-pill px-3" value="${campaign.targetMoney}" required>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-muted text-uppercase">SĐT Người thụ hưởng</label>
                                    <input type="text" name="beneficiaryPhone" class="form-control rounded-pill px-3" value="${campaign.beneficiaryPhone}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Ảnh đại diện (URL)</label>
                                    <input type="text" name="imageUrl" class="form-control rounded-pill px-3" value="${campaign.imageUrl}">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Danh sách ảnh Gallery (URLs, cách nhau bởi dấu phẩy)</label>
                                    <textarea name="galleryUrls" class="form-control rounded-4 px-3 py-2" rows="1" placeholder="https://image1.jpg, https://image2.jpg...">${campaign.galleryUrls}</textarea>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Mô tả ngắn (Background)</label>
                                    <textarea name="background" class="form-control rounded-4 px-3 py-2" rows="2">${campaign.background}</textarea>
                                </div>

                                <div class="col-12">
                                    <label class="form-label small fw-bold text-muted text-uppercase">Nội dung chi tiết (HTML)</label>
                                    <textarea name="content" class="form-control rounded-4 px-3 py-2" rows="10">${campaign.content}</textarea>
                                </div>

                                <div class="col-12 text-end border-top pt-4">
                                    <a href="${pageContext.request.contextPath}/admin/campaigns" class="btn btn-light rounded-pill px-4 me-2">Hủy bỏ</a>
                                    <button type="submit" class="btn btn-primary px-5 rounded-pill shadow-sm fw-bold">LƯU CHIẾN DỊCH</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
