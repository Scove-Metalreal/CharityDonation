<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Chiến dịch - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .action-btn { width: 32px; height: 32px; border-radius: 6px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: var(--transition); }
        .drop-zone { border: 2px dashed #cbd5e1; border-radius: 1rem; padding: 2rem; text-align: center; transition: all 0.3s; cursor: pointer; background: #f8fafc; }
        .drop-zone:hover, .drop-zone.dragover { border-color: #3b82f6; background: #eff6ff; }
        .preview-container { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 15px; }
        .preview-item { width: 80px; height: 80px; position: relative; border-radius: 8px; overflow: hidden; border: 1px solid #e2e8f0; }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; }
        .preview-item .remove-btn { position: absolute; top: 2px; right: 2px; background: rgba(239, 68, 68, 0.8); color: white; border: none; border-radius: 50%; width: 18px; height: 18px; font-size: 10px; cursor: pointer; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <div class="col p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <!-- Header with Action -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4 class="fw-bold text-dark mb-0">Quản lý Chiến dịch</h4>
                        <button type="button" class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#addCampaignModal">
                            <i class="fas fa-plus-circle me-2"></i> Tạo chiến dịch
                        </button>
                    </div>

                    <div class="card border-0 shadow-sm p-4 mb-4">
                        <form action="${pageContext.request.contextPath}/admin/campaigns" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Mới tạo</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Đang chạy</option>
                                    <option value="2" ${status == 2 ? 'selected' : ''}>Kết thúc</option>
                                    <option value="3" ${status == 3 ? 'selected' : ''}>Đóng quỹ</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Mã chiến dịch</label>
                                <input type="text" name="code" class="form-control form-control-sm rounded-pill px-3" value="${code}" placeholder="Mã định danh...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">SĐT nhận</label>
                                <input type="text" name="phone" class="form-control form-control-sm rounded-pill px-3" value="${phone}" placeholder="Số điện thoại...">
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary btn-sm w-100 rounded-pill fw-bold">Tìm kiếm</button>
                            </div>
                        </form>
                    </div>

                    <div class="card border-0 shadow-sm p-4">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="bg-light text-uppercase smallest fw-bold text-muted">
                                    <tr>
                                        <th class="border-0">Chiến dịch</th>
                                        <th class="border-0">Tiến độ quỹ</th>
                                        <th class="border-0 text-center">Trạng thái</th>
                                        <th class="border-0 text-end">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${campaigns}">
                                        <tr>
                                            <td>
                                                <div class="fw-bold text-dark text-truncate" style="max-width: 250px;">${c.name}</div>
                                                <small class="text-muted smallest">Code: ${c.code}</small>
                                            </td>
                                            <td>
                                                <div class="d-flex justify-content-between smallest mb-1">
                                                    <span class="fw-bold text-primary"><fmt:formatNumber value="${c.currentMoney}" type="number"/>đ</span>
                                                    <span class="text-muted">/ <fmt:formatNumber value="${c.targetMoney}" type="number"/>đ</span>
                                                </div>
                                                <div class="progress" style="height: 6px;">
                                                    <c:set var="percent" value="${(c.currentMoney / c.targetMoney) * 100}"/>
                                                    <div class="progress-bar bg-primary" style="width: ${percent > 100 ? 100 : percent}%"></div>
                                                </div>
                                            </td>
                                            <td class="text-center">
                                                <select class="form-select form-select-sm border-0 fw-bold rounded-pill px-3 
                                                        ${c.status == 0 ? 'bg-info bg-opacity-10 text-info' : 
                                                          (c.status == 1 ? 'bg-success bg-opacity-10 text-success' : 
                                                          (c.status == 2 ? 'bg-warning bg-opacity-10 text-warning' : 'bg-secondary bg-opacity-10 text-secondary'))}"
                                                        onchange="confirmCampaignStatus(${c.id}, this, ${c.status})" ${c.status == 3 ? 'disabled' : ''}>
                                                    <option value="0" ${c.status == 0 ? 'selected' : ''} ${c.status > 0 ? 'disabled' : ''}>Mới tạo</option>
                                                    <option value="1" ${c.status == 1 ? 'selected' : ''}>Đang quyên góp</option>
                                                    <option value="2" ${c.status == 2 ? 'selected' : ''}>Kết thúc quyên góp</option>
                                                    <option value="3" ${c.status == 3 ? 'selected' : ''}>Đóng quyên góp</option>
                                                </select>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex justify-content-end gap-1">
                                                    <a href="${pageContext.request.contextPath}/campaign/${c.id}" class="action-btn bg-info bg-opacity-10 text-info" target="_blank"><i class="far fa-eye"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/campaigns/edit?id=${c.id}" class="action-btn bg-primary bg-opacity-10 text-primary ${c.status == 3 ? 'disabled' : ''}"><i class="far fa-edit"></i></a>
                                                    <c:if test="${c.status == 2}">
                                                        <button class="action-btn bg-warning bg-opacity-10 text-warning" onclick="openExtendModal(${c.id}, '${c.endDate}')"><i class="fas fa-calendar-plus"></i></button>
                                                    </c:if>
                                                    <c:if test="${c.status == 0}">
                                                        <form action="${pageContext.request.contextPath}/admin/campaigns/delete" method="post" onsubmit="return confirm('Xóa chiến dịch này?')">
                                                            <input type="hidden" name="id" value="${c.id}">
                                                            <button type="submit" class="action-btn bg-danger bg-opacity-10 text-danger"><i class="far fa-trash-alt"></i></button>
                                                        </form>
                                                    </c:if>
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
                                <a class="page-btn ${currentPage <= 1 ? 'disabled' : ''}" href="?page=${currentPage - 1}&status=${status}&code=${code}&phone=${phone}"><i class="fas fa-chevron-left"></i></a>
                                <c:forEach var="i" begin="1" end="${totalPages > 0 ? totalPages : 1}">
                                    <a class="page-btn ${currentPage == i ? 'active' : ''}" href="?page=${i}&status=${status}&code=${code}&phone=${phone}">${i}</a>
                                </c:forEach>
                                <a class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}" href="?page=${currentPage + 1}&status=${status}&code=${code}&phone=${phone}"><i class="fas fa-chevron-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <!-- Modal Gia hạn -->
    <div class="modal fade" id="extendModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 bg-dark text-white p-4">
                    <h5 class="modal-title fw-bold">GIA HẠN CHIẾN DỊCH</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/campaigns/extend" method="post">
                        <input type="hidden" name="id" id="extendId">
                        <div class="mb-4">
                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc cũ</label>
                            <input type="text" id="oldEndDate" class="form-control rounded-pill px-4 bg-light" readonly>
                        </div>
                        <div class="mb-4">
                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc mới</label>
                            <input type="date" name="newEndDate" class="form-control rounded-pill px-4" required>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 py-3 rounded-pill fw-bold shadow">XÁC NHẬN GIA HẠN</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Tạo Chiến dịch -->
    <div class="modal fade" id="addCampaignModal" data-bs-backdrop="static" tabindex="-1" aria-labelledby="addCampaignModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header border-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-dark" id="addCampaignModalLabel">Tạo chiến dịch mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/campaigns/save" method="post" id="addCampaignForm" enctype="multipart/form-data">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label small fw-bold text-muted">Tên chiến dịch</label>
                                <input type="text" name="name" class="form-control rounded-pill px-3" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Mã định danh (Unique)</label>
                                <input type="text" name="code" class="form-control rounded-pill px-3" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Ngày bắt đầu</label>
                                <input type="date" name="startDate" class="form-control rounded-pill px-3" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Ngày kết thúc</label>
                                <input type="date" name="endDate" class="form-control rounded-pill px-3" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Mục tiêu (Tối thiểu 1 triệuđ)</label>
                                <input type="number" name="targetMoney" class="form-control rounded-pill px-3" min="1000000" required>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label small fw-bold text-muted">Hình ảnh chiến dịch (Kéo thả tối đa 5 ảnh)</label>
                                <div id="dropZone" class="drop-zone">
                                    <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                                    <p class="mb-0 text-muted">Kéo thả ảnh vào đây hoặc click để chọn</p>
                                    <input type="file" id="fileInput" multiple accept="image/*" class="d-none">
                                </div>
                                <div id="previewContainer" class="preview-container"></div>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label small fw-bold text-muted">SĐT Người thụ hưởng</label>
                                <input type="text" name="beneficiaryPhone" class="form-control rounded-pill px-3">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Mô tả ngắn</label>
                                <textarea name="background" class="form-control rounded-4 px-3 py-2" rows="2"></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Nội dung chi tiết (HTML)</label>
                                <textarea name="content" class="form-control rounded-4 px-3 py-2" rows="6"></textarea>
                            </div>
                        </div>
                        <div class="mt-4 pt-3 border-top text-end">
                            <button type="button" class="btn btn-light rounded-pill px-4 me-2" data-bs-dismiss="modal">Hủy bỏ</button>
                            <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm" id="submitBtn">LƯU CHIẾN DỊCH</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openExtendModal(id, oldDate) {
            document.getElementById('extendId').value = id;
            document.getElementById('oldEndDate').value = oldDate;
            new bootstrap.Modal(document.getElementById('extendModal')).show();
        }

        // --- Drag & Drop Image Logic ---
        const dropZone = document.getElementById('dropZone');
        const fileInput = document.getElementById('fileInput');
        const previewContainer = document.getElementById('previewContainer');
        let selectedFiles = [];

        dropZone.onclick = () => fileInput.click();

        dropZone.ondragover = (e) => { e.preventDefault(); dropZone.classList.add('dragover'); };
        dropZone.ondragleave = () => dropZone.classList.remove('dragover');
        dropZone.ondrop = (e) => {
            e.preventDefault();
            dropZone.classList.remove('dragover');
            handleFiles(e.dataTransfer.files);
        };

        fileInput.onchange = (e) => handleFiles(e.target.files);

        function handleFiles(files) {
            const fileList = Array.from(files);
            if (selectedFiles.length + fileList.length > 5) {
                alert("Tối đa chỉ được upload 5 ảnh!");
                return;
            }
            fileList.forEach(file => {
                if (!file.type.startsWith('image/')) return;
                selectedFiles.push(file);
                
                const reader = new FileReader();
                reader.onload = (e) => {
                    const div = document.createElement('div');
                    div.className = 'preview-item';
                    div.innerHTML = `<img src="${e.target.result}"><button type="button" class="remove-btn" onclick="removeFile('${file.name}')">&times;</button>`;
                    previewContainer.appendChild(div);
                };
                reader.readAsDataURL(file);
            });
        }

        window.removeFile = (name) => {
            selectedFiles = selectedFiles.filter(f => f.name !== name);
            renderPreviews();
        };

        function renderPreviews() {
            previewContainer.innerHTML = '';
            selectedFiles.forEach(file => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const div = document.createElement('div');
                    div.className = 'preview-item';
                    div.innerHTML = `<img src="${e.target.result}"><button type="button" class="remove-btn" onclick="removeFile('${file.name}')">&times;</button>`;
                    previewContainer.appendChild(div);
                };
                reader.readAsDataURL(file);
            });
        }

        // --- AJAX Submit Logic ---
        const addCampaignForm = document.getElementById('addCampaignForm');
        addCampaignForm.onsubmit = async (e) => {
            e.preventDefault();
            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang lưu...';

            const formData = new FormData(addCampaignForm);
            // Remove the empty file input and add our selected files
            formData.delete('imageFiles');
            selectedFiles.forEach(file => formData.append('imageFiles', file));

            try {
                const response = await fetch(addCampaignForm.action, {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                if (response.ok) {
                    alert(result.message);
                    location.reload();
                } else {
                    let errorMsg = "Vui lòng kiểm tra lại:\n";
                    for (const key in result) {
                        errorMsg += `- ${result[key]}\n`;
                    }
                    alert(errorMsg);
                }
            } catch (error) {
                alert("Đã có lỗi xảy ra khi kết nối server!");
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = 'LƯU CHIẾN DỊCH';
            }
        };

        // --- Change Status Logic ---
        async function confirmCampaignStatus(id, selectElement, oldStatus) {
            const newStatus = selectElement.value;
            const statusNames = ['Mới tạo', 'Đang quyên góp', 'Kết thúc quyên góp', 'Đóng quyên góp'];
            
            if (confirm(`Bạn có chắc muốn chuyển trạng thái chiến dịch sang "${statusNames[newStatus]}"?`)) {
                try {
                    const params = new URLSearchParams();
                    params.append('id', id);
                    params.append('status', newStatus);

                    const response = await fetch(`${pageContext.request.contextPath}/admin/campaigns/update-status`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params
                    });

                    const result = await response.json();
                    if (response.ok) {
                        alert(result.message);
                        location.reload();
                    } else {
                        alert(result.error || 'Lỗi cập nhật!');
                        location.reload();
                    }
                } catch (error) {
                    alert("Lỗi kết nối!");
                    location.reload();
                }
            } else {
                location.reload();
            }
        }
    </script>
</body>
</html>
