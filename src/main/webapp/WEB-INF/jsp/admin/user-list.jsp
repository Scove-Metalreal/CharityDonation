<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Quản lý Người dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .bg-brand-primary { background-color: var(--color-primary) !important; }
        .action-btn { width: 34px; height: 34px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: 0.2s; }
        .strength-meter { height: 6px; border-radius: 3px; transition: all 0.3s; margin-top: 8px; }
        .strength-0 { width: 0%; }
        .strength-1 { width: 25%; background-color: #ef4444; }
        .strength-2 { width: 50%; background-color: #f59e0b; }
        .strength-3 { width: 75%; background-color: #10b981; }
        .strength-4 { width: 100%; background-color: #059669; }
        .smallest { font-size: 0.75rem; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <div class="col scrollable-main p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark mb-0">Quản lý Người dùng</h4>
                        <button type="button" class="btn btn-brand-primary rounded-pill px-4 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#addUserModal">
                            <i class="fas fa-user-plus me-2"></i> Thêm người dùng
                        </button>
                    </div>

                    <!-- Filters -->
                    <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: 1rem;">
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
                                <button type="submit" class="btn btn-brand-primary btn-sm w-100 rounded-pill fw-bold">Lọc dữ liệu</button>
                            </div>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm p-4" style="border-radius: 1rem;">
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
                                                <div class="d-flex align-items-center">
                                                    <img src="${not empty u.avatarUrl ? u.avatarUrl : 'https://ui-avatars.com/api/?name='.concat(u.fullName).concat('&background=10B981&color=fff')}" 
                                                         class="rounded-circle me-3 shadow-sm" width="36" height="36">
                                                    <div>
                                                        <div class="fw-bold text-dark">${u.fullName}</div>
                                                        <small class="text-muted smallest">${u.email}</small>
                                                    </div>
                                                </div>
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
                                                        <fmt:formatDate value="${parsedDateTime}" pattern="dd/MM/yyyy HH:mm" />
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
                                                    <form action="${pageContext.request.contextPath}/admin/users/toggle-status" method="post" class="m-0 d-inline status-form">
                                                        <input type="hidden" name="userId" value="${u.id}">
                                                        <button type="button" class="action-btn ${u.status == 1 ? 'bg-danger bg-opacity-10 text-danger' : 'bg-success bg-opacity-10 text-success'}" 
                                                                onclick="confirmToggleStatus(this.form, ${u.status})">
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

                        <!-- Pagination -->
                        <div class="d-flex flex-column align-items-center mt-4">
                            <div class="page-info mb-2 text-muted smallest fw-bold">Trang ${currentPage} / ${totalPages}</div>
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

                <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <!-- Modal Thêm Người dùng -->
    <div class="modal fade" id="addUserModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem;">
                <div class="modal-header border-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-dark fs-4">Thêm người dùng mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="resetUserForm()"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/users/save" method="post" id="addUserForm" class="needs-validation" novalidate>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Họ và tên</label>
                                <input type="text" name="fullName" class="form-control rounded-pill px-3 bg-light border-0 shadow-sm" placeholder="Nhập họ tên..." required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Địa chỉ Email</label>
                                <input type="email" name="email" class="form-control rounded-pill px-3 bg-light border-0 shadow-sm" placeholder="email@example.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Số điện thoại</label>
                                <input type="tel" name="phoneNumber" class="form-control rounded-pill px-3 bg-light border-0 shadow-sm" placeholder="09xxxxxxxx" required pattern="^(0|84)(3|5|7|8|9)[0-9]{8}$">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Vai trò</label>
                                <select name="role.id" class="form-select rounded-pill px-3 bg-light border-0 shadow-sm" required>
                                    <c:forEach var="role" items="${roles}">
                                        <option value="${role.id}">${role.roleName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Mật khẩu</label>
                                <input type="password" name="password" id="adminPwdInput" class="form-control rounded-pill px-3 bg-light border-0 shadow-sm" placeholder="Mặc định: 123456" minlength="6">
                                <div class="progress strength-meter bg-white mt-2 shadow-none border">
                                    <div id="adminStrengthBar" class="progress-bar strength-0"></div>
                                </div>
                                <div class="d-flex justify-content-between mt-1">
                                    <small class="text-muted smallest fw-bold">Độ mạnh: <span id="adminStrengthText">Chưa nhập</span></small>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Xác nhận mật khẩu</label>
                                <input type="password" id="adminRePwd" class="form-control rounded-pill px-3 bg-light border-0 shadow-sm" placeholder="Nhập lại mật khẩu">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Trạng thái</label>
                                <select name="status" class="form-select rounded-pill px-3 bg-light border-0 shadow-sm">
                                    <option value="1">Hoạt động</option>
                                    <option value="0">Khóa</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Địa chỉ</label>
                                <input type="text" name="address" class="form-control rounded-pill px-3 bg-light border-0 shadow-sm" placeholder="Nhập địa chỉ...">
                            </div>
                        </div>
                        <div class="mt-5 pt-3 border-top text-end">
                            <button type="button" class="btn btn-light rounded-pill px-4 me-2 fw-bold text-muted" data-bs-dismiss="modal" onclick="resetUserForm()">Hủy bỏ</button>
                            <button type="submit" class="btn btn-brand-primary rounded-pill px-5 fw-bold shadow" id="userSubmitBtn">LƯU NGƯỜI DÙNG</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/zxcvbn/4.4.2/zxcvbn.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        // Password Strength Logic
        const adminPwdInput = document.getElementById('adminPwdInput');
        const adminStrengthBar = document.getElementById('adminStrengthBar');
        const adminStrengthText = document.getElementById('adminStrengthText');
        const strengthTexts = ['Rất yếu', 'Yếu', 'Trung bình', 'Mạnh', 'Rất mạnh'];

        adminPwdInput.addEventListener('input', function() {
            const val = adminPwdInput.value;
            if(!val) {
                adminStrengthBar.className = 'progress-bar strength-0';
                adminStrengthText.innerText = 'Chưa nhập';
                adminStrengthText.className = 'text-muted smallest fw-bold';
                return;
            }
            const result = zxcvbn(val);
            const score = result.score + 1;
            adminStrengthBar.className = 'progress-bar strength-' + score;
            adminStrengthText.innerText = strengthTexts[result.score];
            
            if(score < 3) adminStrengthText.className = 'text-danger smallest fw-bold';
            else if(score === 3) adminStrengthText.className = 'text-warning smallest fw-bold';
            else adminStrengthText.className = 'text-success smallest fw-bold';
        });

        function resetUserForm() {
            const form = document.getElementById('addUserForm');
            form.reset();
            form.classList.remove('was-validated');
            adminStrengthBar.className = 'progress-bar strength-0';
            adminStrengthText.innerText = 'Chưa nhập';
        }

        // --- AJAX Form Submission ---
        const addUserForm = document.getElementById('addUserForm');
        addUserForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            if (!this.checkValidity()) {
                this.classList.add('was-validated');
                return;
            }

            const pass = document.getElementById('adminPwdInput').value;
            const rePass = document.getElementById('adminRePwd').value;
            if (pass && pass !== rePass) {
                Swal.fire('Lỗi', 'Mật khẩu xác nhận không khớp!', 'warning');
                return;
            }

            const submitBtn = document.getElementById('userSubmitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang lưu...';

            try {
                const response = await fetch(this.action, {
                    method: 'POST',
                    body: new FormData(this)
                });

                const result = await response.json();
                if (response.ok) {
                    await Swal.fire({ icon: 'success', title: 'Thành công', text: result.message, timer: 1500, showConfirmButton: false });
                    location.reload();
                } else {
                    let errorMsg = "";
                    for (const key in result) { errorMsg += `\${result[key]}<br>`; }
                    Swal.fire({ icon: 'error', title: 'Lỗi dữ liệu', html: `<div class="text-start text-danger">\${errorMsg}</div>` });
                }
            } catch (error) {
                Swal.fire('Lỗi', 'Kết nối server thất bại!', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = 'LƯU NGƯỜI DÙNG';
            }
        });

        // --- Role Change Logic ---
        async function confirmRoleChange(userId, selectElement, oldRoleName) {
            const newRoleName = selectElement.options[selectElement.selectedIndex].text;
            const newRoleId = selectElement.value;

            const confirm = await Swal.fire({
                title: 'Thay đổi vai trò?',
                text: `Chuyển người dùng từ "\${oldRoleName}" sang "\${newRoleName}"?`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy'
            });

            if (confirm.isConfirmed) {
                try {
                    const params = new URLSearchParams();
                    params.append('userId', userId);
                    params.append('roleId', newRoleId);

                    const response = await fetch(`${pageContext.request.contextPath}/admin/users/update-role`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params
                    });

                    const result = await response.json();
                    if (response.ok) {
                        Swal.fire({ icon: 'success', title: 'Thành công', text: result.message, timer: 1500, showConfirmButton: false }).then(() => location.reload());
                    } else {
                        Swal.fire('Lỗi', result.error, 'error').then(() => location.reload());
                    }
                } catch (error) {
                    Swal.fire('Lỗi', 'Kết nối thất bại!', 'error').then(() => location.reload());
                }
            } else {
                location.reload();
            }
        }

        function confirmToggleStatus(form, currentStatus) {
            const action = currentStatus === 1 ? 'Khóa' : 'Mở khóa';
            Swal.fire({
                title: `\${action} tài khoản?`,
                text: `Bạn có chắc muốn \${action.toLowerCase()} người dùng này không?`,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: currentStatus === 1 ? '#d33' : '#28a745',
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) form.submit();
            });
        }
    </script>
</body>
</html>
