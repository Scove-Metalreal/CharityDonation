<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: var(--transition); }
        .strength-meter { height: 6px; border-radius: 3px; transition: all 0.3s; margin-top: 8px; }
        .strength-0 { width: 0%; }
        .strength-1 { width: 25%; background-color: #ef4444; }
        .strength-2 { width: 50%; background-color: #f59e0b; }
        .strength-3 { width: 75%; background-color: #10b981; }
        .strength-4 { width: 100%; background-color: #059669; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <!-- Flash Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger border-0 shadow-sm alert-dismissible fade show rounded-4 px-4 py-3 mb-4" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show rounded-4 px-4 py-3 mb-4" role="alert">
                            <i class="fas fa-check-circle me-2"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <!-- Header with Action -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark mb-0">Quản lý Người dùng</h4>
                        <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="fas fa-user-plus me-2"></i> Thêm người dùng
                        </button>
                    </div>

                    <!-- Filters -->
                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <form action="${pageContext.request.contextPath}/admin/users" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Tìm kiếm</label>
                                <input type="text" name="keyword" class="form-control form-control-sm rounded-pill px-3" placeholder="Tên, email, SĐT..." value="${keyword}">
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Vai trò</label>
                                <select name="roleId" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <c:forEach var="r" items="${roles}">
                                        <option value="${r.id}" ${roleId == r.id ? 'selected' : ''}>${r.roleName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Đã khóa</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Không hoạt động</label>
                                <select name="inactive" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">-- Mặc định --</option>
                                    <option value="1w" ${inactive == '1w' ? 'selected' : ''}>Hơn 1 tuần</option>
                                    <option value="1m" ${inactive == '1m' ? 'selected' : ''}>Hơn 1 tháng</option>
                                    <option value="1q" ${inactive == '1q' ? 'selected' : ''}>Hơn 1 quý</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold">Lọc</button>
                            </div>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light text-uppercase smallest fw-bold text-muted">
                                    <tr>
                                        <th class="border-0">Người dùng</th>
                                        <th class="border-0">Vai trò</th>
                                        <th class="border-0">Đăng nhập cuối</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="u" items="${users}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark">${u.fullName}</div>
                                                <small class="text-muted smallest">${u.email}</small>
                                            </td>
                                            <td>
                                                <select class="form-select form-select-sm border-0 bg-light rounded-pill px-3 fw-bold" 
                                                        onchange="confirmRoleChange(${u.id}, this, '${u.role.roleName}')" style="max-width: 150px;">
                                                    <c:forEach var="r" items="${roles}">
                                                        <option value="${r.id}" ${u.role.id == r.id ? 'selected' : ''}>${r.roleName}</option>
                                                    </c:forEach>
                                                </select>
                                            </td>
                                            <td class="smallest">
                                                <c:choose>
                                                    <c:when test="${not empty u.lastLogin}">
                                                        <fmt:parseDate value="${u.lastLogin}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                                        <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy" />
                                                    </c:when>
                                                    <c:otherwise><span class="text-muted">Chưa đăng nhập</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge ${u.status == 1 ? 'bg-success' : 'bg-danger'} bg-opacity-10 ${u.status == 1 ? 'text-success' : 'text-danger'} rounded-pill px-3">
                                                    ${u.status == 1 ? 'Hoạt động' : 'Bị khóa'}
                                                </span>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex justify-content-end gap-1">
                                                    <a href="${pageContext.request.contextPath}/admin/users/detail/${u.id}" class="action-btn bg-info bg-opacity-10 text-info"><i class="far fa-eye"></i></a>
                                                    <form action="${pageContext.request.contextPath}/admin/users/toggle-status" method="post" class="m-0">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <button type="submit" class="action-btn ${u.status == 1 ? 'bg-danger bg-opacity-10 text-danger' : 'bg-success bg-opacity-10 text-success'}">
                                                            <i class="fas ${u.status == 1 ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Custom Pagination -->
                        <div class="d-flex flex-column align-items-center mt-4">
                            <div class="page-info">Trang ${currentPage} / ${totalPages}</div>
                            <div class="custom-pagination">
                                <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" 
                                   href="?page=${currentPage - 1}&keyword=${keyword}&roleId=${roleId}&status=${status}&inactive=${inactive}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                                
                                <c:forEach var="i" begin="1" end="${totalPages > 0 ? totalPages : 1}">
                                    <a class="page-btn ${currentPage == i ? 'active' : ''}" 
                                       href="?page=${i}&keyword=${keyword}&roleId=${roleId}&status=${status}&inactive=${inactive}">${i}</a>
                                </c:forEach>
                                
                                <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" 
                                   href="?page=${currentPage + 1}&keyword=${keyword}&roleId=${roleId}&status=${status}&inactive=${inactive}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-labelledby="addUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-dark" id="addUserModalLabel">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/users/save" method="post" class="needs-validation" novalidate id="addUserForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Họ và tên</label>
                                <input type="text" name="fullName" class="form-control rounded-pill px-3" placeholder="Nhập họ tên..." required>
                                <div class="invalid-feedback ps-3 smallest">Vui lòng nhập họ và tên</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Địa chỉ Email</label>
                                <input type="email" name="email" class="form-control rounded-pill px-3" placeholder="email@example.com" required>
                                <div class="invalid-feedback ps-3 smallest">Vui lòng nhập email hợp lệ</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Số điện thoại</label>
                                <input type="tel" name="phoneNumber" class="form-control rounded-pill px-3" placeholder="09xxxxxxxx" required pattern="^(0|84)(3|5|7|8|9)[0-9]{8}$">
                                <div class="invalid-feedback ps-3 smallest">Vui lòng nhập SĐT Việt Nam hợp lệ</div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Vai trò</label>
                                <select name="role.id" class="form-select rounded-pill px-3" required>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.id}">${role.roleName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Mật khẩu</label>
                                <input type="password" name="password" id="adminPwdInput" class="form-control rounded-pill px-3" placeholder="Mặc định: 123456" minlength="6">
                                <div class="progress strength-meter bg-light">
                                    <div id="adminStrengthBar" class="progress-bar strength-0"></div>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                    <small class="text-muted smallest">Độ mạnh: <span id="adminStrengthText">Chưa nhập</span></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Xác nhận mật khẩu</label>
                                <input type="password" id="adminRePwd" class="form-control rounded-pill px-3" placeholder="Nhập lại mật khẩu">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Trạng thái</label>
                                <select name="status" class="form-select rounded-pill px-3">
                                    <option value="1">Hoạt động</option>
                                    <option value="0">Khóa</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Địa chỉ</label>
                                <input type="text" name="address" class="form-control rounded-pill px-3" placeholder="Nhập địa chỉ...">
                            </div>
                        </div>
                        <div class="mt-4 pt-3 border-top text-end">
                            <button type="button" class="btn btn-light rounded-pill px-4 me-2" data-bs-dismiss="modal">Hủy bỏ</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">Lưu người dùng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/4.4.2/zxcvbn.js"></script>
    <script>
        // Password Strength
        const adminPwdInput = document.getElementById('adminPwdInput');
        const adminStrengthBar = document.getElementById('adminStrengthBar');
        const adminStrengthText = document.getElementById('adminStrengthText');
        const strengthTexts = ['Rất yếu', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];

        adminPwdInput.addEventListener('input', function() {
            const val = adminPwdInput.value;
            if(!val) {
                adminStrengthBar.className = 'progress-bar strength-0';
                adminStrengthText.innerText = 'Chưa nhập';
                return;
            }
            const result = zxcvbn(val);
            const score = result.score + 1;
            adminStrengthBar.className = 'progress-bar strength-' + score;
            adminStrengthText.innerText = strengthTexts[result.score];
            
            if(score < 3) adminStrengthText.className = 'text-danger smallest';
            else if(score === 3) adminStrengthText.className = 'text-warning smallest';
            else adminStrengthText.className = 'text-success smallest';
        });

        // Form Validation & AJAX Submission
        (() => {
            'use strict'
            const form = document.getElementById('addUserForm');
            form.addEventListener('submit', async event => {
                event.preventDefault();
                event.stopPropagation();

                const pass = document.getElementById('adminPwdInput').value;
                const rePass = document.getElementById('adminRePwd').value;
                
                if (pass && pass !== rePass) {
                    alert('Mật khẩu xác nhận không khớp!');
                    return;
                }
                
                if (!form.checkValidity()) {
                    form.classList.add('was-validated');
                    return;
                }

                const formData = new FormData(form);
                try {
                    const response = await fetch(form.action, {
                        method: 'POST',
                        body: formData
                    });

                    const result = await response.json();

                    if (response.ok) {
                        alert(result.message);
                        location.reload();
                    } else {
                        // Display server-side errors
                        let errorMsg = "";
                        for (const key in result) {
                            errorMsg += result[key] + "\n";
                        }
                        alert(errorMsg);
                    }
                } catch (error) {
                    alert('Đã có lỗi xảy ra khi lưu người dùng!');
                }
            }, false);
        })();

        // Change Role Function
        async function confirmRoleChange(userId, selectElement, oldRoleName) {
            const newRoleName = selectElement.options[selectElement.selectedIndex].text;
            const newRoleId = selectElement.value;

            if (confirm(`Bạn có chắc chắn muốn thay đổi vai trò của người dùng này từ "${oldRoleName}" sang "${newRoleName}"?`)) {
                try {
                    const params = new URLSearchParams();
                    params.append('userId', userId);
                    params.append('roleId', newRoleId);

                    const response = await fetch(`${pageContext.request.contextPath}/admin/users/update-role`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: params
                    });

                    const result = await response.json();
                    if (response.ok) {
                        alert(result.message);
                        location.reload();
                    } else {
                        alert(result.error || 'Đã có lỗi xảy ra!');
                        location.reload();
                    }
                } catch (error) {
                    alert('Lỗi kết nối server!');
                    location.reload();
                }
            } else {
                // Reset select to old value if cancelled
                location.reload();
            }
        }
    </script>
</body>
</html>
