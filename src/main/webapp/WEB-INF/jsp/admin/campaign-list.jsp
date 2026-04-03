﻿<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Quản lý Chiến dịch - Admin</title>
    <!-- CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/css/tom-select.bootstrap5.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        :root { --primary-color: var(--color-primary); --bg-light: #f8fafc; }
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .bg-brand-primary { background-color: var(--color-primary) !important; }
        .action-btn { width: 34px; height: 34px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: 0.2s; }
        
        /* Drag & Drop Zone */
        .drop-zone { 
            border: 2px dashed #e2e8f0; border-radius: 1.25rem; padding: 2.5rem; 
            text-align: center; transition: all 0.3s; cursor: pointer; background: #fff;
            display: flex; flex-direction: column; align-items: center; gap: 10px;
        }
        .drop-zone:hover, .drop-zone.dragover { border-color: var(--primary-color); background: #eff6ff; }
        .drop-zone i { color: #cbd5e1; transition: 0.3s; }
        .drop-zone:hover i { color: var(--primary-color); transform: translateY(-5px); }

        /* Preview Images */
        .preview-container { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 20px; }
        .preview-item { 
            width: 100px; height: 100px; position: relative; border-radius: 12px; 
            overflow: hidden; border: 2px solid #fff; shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); 
        }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; }
        .preview-item .remove-btn { 
            position: absolute; top: 5px; right: 5px; background: #ef4444; color: white; 
            border: none; border-radius: 50%; width: 22px; height: 22px; 
            display: flex; align-items: center; justify-content: center; cursor: pointer;
            font-size: 12px; font-weight: bold; box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        /* Tom Select Custom UI */
        .ts-control { border-radius: 50rem !important; padding: 8px 16px !important; border: 1px solid #dee2e6 !important; }
        .ts-dropdown .companion-option { padding: 10px 15px; display: flex; align-items: center; gap: 12px; transition: 0.2s; }
        .ts-dropdown .active { background-color: #f1f5f9 !important; }
        .companion-avatar { width: 32px; height: 32px; border-radius: 8px; object-fit: cover; border: 1px solid #e2e8f0; }
        .ts-control .item { background: #e2e8f0 !important; border-radius: 50rem !important; padding: 2px 10px !important; display: flex; align-items: center; gap: 6px; }
        .ts-control .item img { width: 18px; height: 18px; border-radius: 50%; }
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
                        <h4 class="fw-bold text-dark mb-0">Quản lý Chiến dịch</h4>
                        <button type="button" class="btn btn-brand-primary rounded-pill px-4 shadow-sm fw-bold" data-bs-toggle="modal" data-bs-target="#addCampaignModal">
                            <i class="fas fa-plus-circle me-2"></i> Tạo chiến dịch
                        </button>
                    </div>

                    <!-- Search Filters -->
                    <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: 1rem;">
                        <form action="${pageContext.request.contextPath}/admin/campaigns" method="get" class="row g-3">
                            <div class="col-md-3">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="">Tất cả</option>
                                    <option value="0" ${status == 0 ? 'selected' : ''}>Mới tạo</option>
                                    <option value="1" ${status == 1 ? 'selected' : ''}>Đang quyên góp</option>
                                    <option value="2" ${status == 2 ? 'selected' : ''}>Kết thúc quyên góp</option>
                                    <option value="3" ${status == 3 ? 'selected' : ''}>Đóng quyên góp</option>
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
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Sắp xếp</label>
                                <select name="sortBy" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="createdAt" ${sortBy == 'createdAt' ? 'selected' : ''}>Ngày tạo</option>
                                    <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên chiến dịch</option>
                                    <option value="targetMoney" ${sortBy == 'targetMoney' ? 'selected' : ''}>Mục tiêu</option>
                                    <option value="currentMoney" ${sortBy == 'currentMoney' ? 'selected' : ''}>Đã đạt được</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <label class="form-label smallest fw-bold text-muted text-uppercase">Thứ tự</label>
                                <select name="direction" class="form-select form-select-sm rounded-pill px-3">
                                    <option value="desc" ${direction == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                    <option value="asc" ${direction == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-brand-primary btn-sm w-100 rounded-pill fw-bold">Lọc & Xếp</button>
                            </div>
                        </form>
                    </div>

                    <!-- Campaign Table -->
                    <div class="card border-0 shadow-sm p-4" style="border-radius: 1rem;">
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
                                                    <span class="fw-bold brand-primary"><fmt:formatNumber value="${c.currentMoney}" type="number"/>đ</span>
                                                    <span class="text-muted">/ <fmt:formatNumber value="${c.targetMoney}" type="number"/>đ</span>
                                                </div>
                                                <div class="progress" style="height: 6px; border-radius: 10px;">
                                                    <c:set var="percent" value="${(c.currentMoney / c.targetMoney) * 100}"/>
                                                    <div class="progress-bar bg-brand-primary" style="width: ${percent > 100 ? 100 : percent}%"></div>
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
                                                    <a href="${pageContext.request.contextPath}/admin/campaigns/edit?id=${c.id}" class="action-btn bg-brand-primary bg-opacity-10 brand-primary ${c.status == 3 ? 'disabled' : ''}"><i class="far fa-edit"></i></a>
                                                    <c:if test="${c.status == 2}">
                                                        <button class="action-btn bg-warning bg-opacity-10 text-warning" onclick="openExtendModal(${c.id}, '${c.endDate}')"><i class="fas fa-calendar-plus"></i></button>
                                                    </c:if>
                                                    <c:if test="${c.status == 0}">
                                                        <form action="${pageContext.request.contextPath}/admin/campaigns/delete" method="post" class="d-inline delete-form">
                                                            <input type="hidden" name="id" value="${c.id}">
                                                            <button type="button" class="action-btn bg-danger bg-opacity-10 text-danger" onclick="confirmDelete(this.form)"><i class="far fa-trash-alt"></i></button>
                                                        </form>
                                                    </c:if>
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
        <div class="modal-dialog modal-dialog-centered mx-auto" style="max-width: 400px; width: 95%;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.25rem;">
                <div class="modal-header border-0 bg-dark text-white p-4" style="border-radius: 1.25rem 1.25rem 0 0;">
                    <h5 class="modal-title fw-bold">GIA HẠN CHIẾN DỊCH</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${pageContext.request.contextPath}/admin/campaigns/extend" method="post" id="extendForm">
                        <input type="hidden" name="id" id="extendId">
                        <div class="mb-4">
                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc cũ</label>
                            <input type="text" id="oldEndDateDisplay" class="form-control rounded-pill px-4 bg-light border-0" readonly>
                        </div>
                        <div class="mb-4">
                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc mới</label>
                            <input type="date" name="newEndDate" id="newEndDate" class="form-control rounded-pill px-4 border-0 bg-light shadow-sm" required>
                        </div>
                        <button type="submit" class="btn btn-brand-primary w-100 py-3 rounded-pill fw-bold shadow" id="extendSubmitBtn">XÁC NHẬN GIA HẠN</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Tạo Chiến dịch -->
    <div class="modal fade" id="addCampaignModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered mx-auto" style="width: 95%;">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem;">
                <div class="modal-header border-0 pb-0 pt-4 px-4">
                    <h5 class="modal-title fw-bold text-dark fs-4">Tạo chiến dịch mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="resetCampaignForm()"></button>
                </div>
                <div class="modal-body p-3 p-md-4">
                    <form action="${pageContext.request.contextPath}/admin/campaigns/save" method="post" id="addCampaignForm" enctype="multipart/form-data">
                        <div class="row g-3 g-md-4">
                            <div class="col-12 col-md-8">
                                <label class="form-label small fw-bold text-muted">Tên chiến dịch</label>
                                <input type="text" name="name" class="form-control rounded-pill px-3 shadow-sm border-0 bg-light" placeholder="Nhập tên..." required>
                            </div>
                            <div class="col-12 col-md-4">
                                <label class="form-label small fw-bold text-muted">Mã định danh (Duy nhất)</label>
                                <input type="text" name="code" class="form-control rounded-pill px-3 shadow-sm border-0 bg-light" placeholder="Ví dụ: CMP2024..." required>
                            </div>
                            <div class="col-12 col-sm-6 col-md-4">
                                <label class="form-label small fw-bold text-muted">Ngày bắt đầu</label>
                                <input type="date" name="startDate" id="startDate" class="form-control rounded-pill px-3 shadow-sm border-0 bg-light" required>
                            </div>
                            <div class="col-12 col-sm-6 col-md-4">
                                <label class="form-label small fw-bold text-muted">Ngày kết thúc</label>
                                <input type="date" name="endDate" id="endDate" class="form-control rounded-pill px-3 shadow-sm border-0 bg-light" required>
                            </div>
                            <div class="col-12 col-md-4">
                                <label class="form-label small fw-bold text-muted">Mục tiêu (VNĐ)</label>
                                <input type="number" name="targetMoney" class="form-control rounded-pill px-3 shadow-sm border-0 bg-light" placeholder="1000000" min="1000000" required>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Đối tác đồng hành</label>
                                <select id="companionSelect" name="companionIds" multiple placeholder="Tìm và chọn đối tác..." autocomplete="off">
                                    <c:forEach var="comp" items="${allCompanions}">
                                        <option value="${comp.id}" data-src="${comp.logoUrl}">${comp.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Hình ảnh chiến dịch (Tối đa 5 ảnh)</label>
                                <div id="dropZone" class="drop-zone shadow-sm">
                                    <i class="fas fa-cloud-upload-alt fa-2x fa-md-3x mb-2"></i>
                                    <span class="fw-bold text-dark">Kéo thả ảnh vào đây</span>
                                    <span class="text-muted smallest">Hoặc click để chọn file</span>
                                    <input type="file" id="fileInput" multiple accept="image/*" class="d-none">
                                </div>
                                <div id="previewContainer" class="preview-container"></div>
                            </div>
                            
                            <div class="col-12 col-md-12">
                                <label class="form-label small fw-bold text-muted">SĐT Người thụ hưởng</label>
                                <input type="text" name="beneficiaryPhone" class="form-control rounded-pill px-3 shadow-sm border-0 bg-light" placeholder="Số điện thoại nhận tiền...">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Mô tả ngắn</label>
                                <textarea name="background" class="form-control border-0 bg-light shadow-sm" rows="2" style="border-radius: 1rem;" placeholder="Tóm tắt mục đích..."></textarea>
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Nội dung chi tiết (HTML)</label>
                                <textarea name="content" class="form-control border-0 bg-light shadow-sm" rows="5" style="border-radius: 1rem;" placeholder="Nội dung hiển thị trên trang chi tiết..."></textarea>
                            </div>
                        </div>
                        <div class="mt-4 mt-md-5 pt-3 border-top text-end d-flex flex-column flex-md-row justify-content-md-end gap-2">
                            <button type="button" class="btn btn-light rounded-pill px-4 order-2 order-md-1 fw-bold text-muted" data-bs-dismiss="modal" onclick="resetCampaignForm()">Hủy bỏ</button>
                            <button type="submit" class="btn btn-brand-primary rounded-pill px-5 order-1 order-md-2 fw-bold shadow" id="submitBtn">LƯU CHIẾN DỊCH</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.complete.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script>
        // --- UI INITIALIZATION ---
        let companionSelect;
        document.addEventListener('DOMContentLoaded', function() {
            companionSelect = new TomSelect('#companionSelect', {
                plugins: ['remove_button'],
                render: {
                    option: function(data, escape) {
                        return `<div class="companion-option">
                            <img class="companion-avatar" src="\${escape(data.src)}">
                            <span class="fw-bold">\${escape(data.text)}</span>
                        </div>`;
                    },
                    item: function(data, escape) {
                        return `<div class="item">
                            <img src="\${escape(data.src)}">
                            \${escape(data.text)}
                        </div>`;
                    }
                }
            });
        });

        // --- IMAGE UPLOAD LOGIC ---
        const dropZone = document.getElementById('dropZone');
        const fileInput = document.getElementById('fileInput');
        const previewContainer = document.getElementById('previewContainer');
        let selectedFiles = [];

        // Fix click error
        dropZone.addEventListener('click', () => fileInput.click());

        dropZone.addEventListener('dragover', (e) => { e.preventDefault(); dropZone.classList.add('dragover'); });
        dropZone.addEventListener('dragleave', () => dropZone.classList.remove('dragover'));
        dropZone.addEventListener('drop', (e) => {
            e.preventDefault();
            dropZone.classList.remove('dragover');
            handleFiles(e.dataTransfer.files);
        });

        fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

        function handleFiles(files) {
            const fileList = Array.from(files);
            if (selectedFiles.length + fileList.length > 5) {
                Swal.fire('Lỗi', 'Tối đa chỉ được upload 5 ảnh!', 'error');
                return;
            }
            fileList.forEach(file => {
                if (!file.type.startsWith('image/')) return;
                if (selectedFiles.some(f => f.name === file.name && f.size === file.size)) return;
                
                selectedFiles.push(file);
            });
            renderPreviews();
        }

        window.removeFile = function(fileName) {
            selectedFiles = selectedFiles.filter(f => f.name !== fileName);
            renderPreviews();
        };

        function renderPreviews() {
            previewContainer.innerHTML = '';
            selectedFiles.forEach(file => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const div = document.createElement('div');
                    div.className = 'preview-item shadow-sm';
                    // Escape single quotes in file name for JS function call
                    const escapedName = file.name.replace(/'/g, "\\'");
                    div.innerHTML = `<img src="\${e.target.result}">
                                   <button type="button" class="remove-btn" onclick="removeFile('\${escapedName}')">&times;</button>`;
                    previewContainer.appendChild(div);
                };
                reader.readAsDataURL(file);
            });
        }

        function resetCampaignForm() {
            const form = document.getElementById('addCampaignForm');
            form.reset();
            selectedFiles = [];
            renderPreviews();
            if(companionSelect) companionSelect.clear();
            form.classList.remove('was-validated');
        }

        // --- FORM SUBMISSION (AJAX) ---
        const addCampaignForm = document.getElementById('addCampaignForm');
        addCampaignForm.addEventListener('submit', async function(e) {
            e.preventDefault(); // Stop standard redirect
            
            // Validate Dates
            const sDate = new Date(document.getElementById('startDate').value);
            const eDate = new Date(document.getElementById('endDate').value);
            if (sDate >= eDate) {
                Swal.fire('Ngày tháng không hợp lệ', 'Ngày bắt đầu phải TRƯỚC ngày kết thúc!', 'warning');
                return;
            }

            const submitBtn = document.getElementById('submitBtn');
            const originalBtnText = submitBtn.innerText;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang xử lý...';

            const formData = new FormData(this);
            // Append files manually
            formData.delete('imageFiles');
            selectedFiles.forEach(file => formData.append('imageFiles', file));

            try {
                const response = await fetch(this.action, {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                
                if (response.ok) {
                    await Swal.fire({
                        icon: 'success',
                        title: 'Thành công!',
                        text: result.message,
                        timer: 2000,
                        showConfirmButton: false
                    });
                    location.reload();
                } else {
                    let errorMsg = "";
                    for (const key in result) {
                        errorMsg += `\${result[key]}<br>`;
                    }
                    Swal.fire({
                        icon: 'error',
                        title: 'Không thể lưu!',
                        html: `<div class="text-start text-danger">\${errorMsg}</div>`
                    });
                }
            } catch (error) {
                Swal.fire('Lỗi hệ thống', 'Đã có lỗi xảy ra hoặc file quá lớn (Max 10MB)!', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = originalBtnText;
            }
        });

        // --- HELPER FUNCTIONS ---
        async function confirmCampaignStatus(id, selectElement, oldStatus) {
            const newStatus = selectElement.value;
            const statusNames = ['Mới tạo', 'Đang quyên góp', 'Kết thúc quyên góp', 'Đóng quyên góp'];
            
            const confirm = await Swal.fire({
                title: 'Xác nhận thay đổi?',
                text: `Chuyển chiến dịch sang trạng thái "\${statusNames[newStatus]}"?`,
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Đồng ý',
                cancelButtonText: 'Hủy'
            });

            if (confirm.isConfirmed) {
                const params = new URLSearchParams();
                params.append('id', id);
                params.append('status', newStatus);

                try {
                    const response = await fetch(`${pageContext.request.contextPath}/admin/campaigns/update-status`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params
                    });
                    const result = await response.json();
                    if (response.ok) {
                        Swal.fire('Thành công', result.message, 'success').then(() => location.reload());
                    } else {
                        Swal.fire('Lỗi', result.error, 'error').then(() => location.reload());
                    }
                } catch (e) {
                    Swal.fire('Lỗi', 'Kết nối server thất bại!', 'error').then(() => location.reload());
                }
            } else {
                location.reload();
            }
        }

        function confirmDelete(form) {
            Swal.fire({
                title: 'Bạn có chắc chắn?',
                text: "Dữ liệu chiến dịch sẽ bị xóa vĩnh viễn!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Xóa ngay',
                cancelButtonText: 'Quay lại'
            }).then((result) => {
                if (result.isConfirmed) form.submit();
            });
        }

        // --- EXTEND CAMPAIGN LOGIC ---
        function openExtendModal(id, oldDate) {
            document.getElementById('extendId').value = id;
            document.getElementById('oldEndDateDisplay').value = oldDate;
            const modal = new bootstrap.Modal(document.getElementById('extendModal'));
            modal.show();
        }

        document.getElementById('extendForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            const submitBtn = document.getElementById('extendSubmitBtn');
            const originalText = submitBtn.innerText;
            
            const newDate = new Date(document.getElementById('newEndDate').value);
            const oldDate = new Date(document.getElementById('oldEndDateDisplay').value);
            
            if (newDate <= oldDate) {
                Swal.fire('Lỗi', 'Ngày kết thúc mới phải sau ngày cũ!', 'warning');
                return;
            }

            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang xử lý...';

            const formData = new URLSearchParams(new FormData(this));

            try {
                const response = await fetch(this.action, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData
                });

                if (response.ok) {
                    await Swal.fire('Thành công', 'Gia hạn chiến dịch thành công!', 'success');
                    location.reload();
                } else {
                    Swal.fire('Lỗi', 'Không thể gia hạn chiến dịch.', 'error');
                }
            } catch (e) {
                Swal.fire('Lỗi', 'Kết nối server thất bại!', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = originalText;
            }
        });
    </script>
</body>
</html>
