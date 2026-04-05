<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>${not empty campaign.id ? 'Sửa' : 'Thêm'} Chiến dịch - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/css/tom-select.bootstrap5.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        .brand-primary { color: var(--color-primary) !important; }
        .bg-brand-primary { background-color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        
        .ql-container { min-height: 300px; font-size: 1rem; border-bottom-left-radius: 1rem; border-bottom-right-radius: 1rem; background: white; }
        .ql-toolbar { border-top-left-radius: 1rem; border-top-right-radius: 1rem; background: #f8fafc; border-color: #dee2e6 !important; }

        .preview-container { display: flex; flex-wrap: wrap; gap: 10px; margin-top: 15px; }
        .preview-item { width: 80px; height: 80px; border-radius: 12px; overflow: hidden; position: relative; border: 2px solid #fff; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .preview-item img { width: 100%; height: 100%; object-fit: cover; }
        .preview-item .remove-btn { 
            position: absolute; top: 2px; right: 2px; width: 20px; height: 20px; 
            background: rgba(239, 68, 68, 0.9); color: white; border: none; 
            border-radius: 50%; font-size: 12px; display: flex; align-items: center; 
            justify-content: center; cursor: pointer; z-index: 10;
        }
        
        .drop-zone { cursor: pointer; transition: 0.3s; border: 2px dashed #cbd5e1; min-height: 120px; display: flex; flex-direction: column; align-items: center; justify-content: center; border-radius: 1rem; }
        .drop-zone:hover, .drop-zone.dragover { background: #edfcf7 !important; border-color: var(--color-primary) !important; }

        /* --- TOM SELECT LUXURY FIXED --- */
        .ts-wrapper.multi .ts-control { 
            border-radius: 50rem !important; 
            padding: 8px 20px !important; 
            min-height: 50px !important; 
            border: 1px solid #dee2e6 !important;
            background-color: #f8fafc !important;
        }
        .ts-dropdown { border-radius: 1rem !important; border: 1px solid #e2e8f0 !important; box-shadow: 0 10px 30px rgba(0,0,0,0.1) !important; z-index: 2000 !important; }
        
        /* Cố định kích thước ảnh trong danh sách đối tác */
        .companion-option, .ts-control .item { display: flex; align-items: center; gap: 10px; overflow: hidden; }
        .companion-avatar, .ts-control .item img { 
            width: 28px !important; 
            height: 28px !important; 
            min-width: 28px !important; 
            object-fit: contain !important; 
            border-radius: 6px !important; 
            background: white; 
            border: 1px solid #eee; 
        }
        
        .ts-control .item { 
            background: #fff !important; 
            border: 1px solid #e2e8f0 !important; 
            border-radius: 99px !important; 
            padding: 2px 12px 2px 4px !important;
            font-weight: 600 !important;
            max-width: 200px;
        }
        .ts-control .item span { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <div class="col-auto p-0">
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4 pb-5">
                    <div class="d-flex align-items-center mb-4 pt-3">
                        <a href="${pageContext.request.contextPath}/admin/campaigns" class="btn btn-light rounded-circle me-3 shadow-sm"><i class="fas fa-arrow-left"></i></a>
                        <div>
                            <h4 class="fw-bold text-dark mb-0">${not empty campaign.id ? 'Chỉnh sửa' : 'Thêm mới'} chiến dịch</h4>
                            <small class="text-muted">Quản lý thông tin chiến dịch quyên góp</small>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/campaigns/save" method="post" id="campaignForm" enctype="multipart/form-data">
                        <input type="hidden" name="id" value="${campaign.id}">
                        <input type="hidden" name="status" value="${not empty campaign.status ? campaign.status : 0}">
                        
                        <div class="row g-4">
                            <div class="col-lg-8">
                                <div class="card border-0 shadow-sm p-4 rounded-4 h-100 bg-white border border-light">
                                    <h6 class="fw-bold mb-4 text-dark border-bottom pb-2 text-uppercase smallest">Thông tin cơ bản</h6>
                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Tên chiến dịch</label>
                                            <input type="text" name="name" class="form-control rounded-pill px-3 shadow-none border" value="${campaign.name}" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Mã định danh</label>
                                            <input type="text" name="code" class="form-control rounded-pill px-3 shadow-none border" value="${campaign.code}" ${not empty campaign.id ? 'readonly' : ''} required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày bắt đầu</label>
                                            <input type="date" name="startDate" id="startDate" class="form-control rounded-pill px-3 shadow-none border" value="${campaign.startDate}" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc</label>
                                            <input type="date" name="endDate" id="endDate" class="form-control rounded-pill px-3 shadow-none border" value="${campaign.endDate}" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Mục tiêu (VNĐ)</label>
                                            <input type="number" name="targetMoney" class="form-control rounded-pill px-3 shadow-none border" value="${campaign.targetMoney}" min="1000000" required>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Đối tác đồng hành</label>
                                            <select id="companionSelect" name="companionIds" multiple placeholder="Chọn đối tác...">
                                                <c:forEach var="comp" items="${allCompanions}">
                                                    <c:set var="isSelected" value="false"/>
                                                    <c:forEach var="cc" items="${campaign.companions}">
                                                        <c:if test="${cc.id == comp.id}"><c:set var="isSelected" value="true"/></c:if>
                                                    </c:forEach>
                                                    <option value="${comp.id}" data-src="${comp.logoUrl}" ${isSelected ? 'selected' : ''}>${comp.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">SĐT Người thụ hưởng</label>
                                            <input type="text" name="beneficiaryPhone" class="form-control rounded-pill px-3 shadow-none border" value="${campaign.beneficiaryPhone}" placeholder="Số điện thoại nhận tiền...">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-4">
                                <div class="card border-0 shadow-sm p-4 rounded-4 h-100 bg-white border border-light">
                                    <h6 class="fw-bold mb-4 text-dark border-bottom pb-2 text-uppercase smallest">Hình ảnh & Mô tả</h6>
                                    <div id="dropZone" class="drop-zone rounded-4 p-4 text-center bg-light transition mb-3">
                                        <i class="fas fa-cloud-upload-alt fa-3x brand-primary mb-2"></i>
                                        <div class="fw-bold small text-muted">Kéo thả hoặc click để đổi ảnh</div>
                                        <input type="file" id="fileInput" multiple accept="image/*" class="d-none">
                                    </div>
                                    <div id="previewContainer" class="preview-container">
                                        <c:if test="${not empty campaign.imageUrl}">
                                            <div class="preview-item shadow-sm old-image" title="Ảnh đại diện hiện tại">
                                                <img src="${campaign.imageUrl}">
                                                <span class="position-absolute bottom-0 start-0 w-100 bg-dark bg-opacity-75 text-white smallest text-center py-1">Cover</span>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty campaign.galleryUrls}">
                                            <c:forEach var="url" items="${campaign.galleryUrls.split(',')}">
                                                <c:if test="${url.trim() != campaign.imageUrl}">
                                                    <div class="preview-item shadow-sm old-image">
                                                        <img src="${url.trim()}">
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:if>
                                    </div>
                                    <div class="mt-4">
                                        <label class="form-label smallest fw-bold text-muted text-uppercase">Mô tả ngắn</label>
                                        <textarea name="background" class="form-control border rounded-4 shadow-none" rows="4" placeholder="Tóm tắt nội dung...">${campaign.background}</textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <div class="card border-0 shadow-sm p-4 rounded-4 bg-white border border-light">
                                    <label class="form-label smallest fw-bold text-muted text-uppercase mb-3">Nội dung bài viết</label>
                                    <div id="editor-container">${campaign.content}</div>
                                    <textarea name="content" id="content-hidden" class="d-none"></textarea>
                                </div>
                            </div>
                        </div>

                        <div class="mt-5 pt-4 border-top text-end">
                            <button type="submit" class="btn btn-brand-primary rounded-pill px-5 py-3 fw-bold shadow-lg" id="submitBtn">
                                <i class="fas fa-save me-2"></i> LƯU THAY ĐỔI CHIẾN DỊCH
                            </button>
                        </div>
                    </form>
                </div>

                <jsp:include page="../fragments/footer.jsp"/>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/tom-select@2.3.1/dist/js/tom-select.complete.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

    <script>
        // --- QUILL ---
        let quill;
        document.addEventListener('DOMContentLoaded', function() {
            quill = new Quill('#editor-container', {
                theme: 'snow',
                placeholder: 'Nhập nội dung chiến dịch...',
                modules: {
                    toolbar: [
                        [{ 'header': [1, 2, 3, false] }],
                        ['bold', 'italic', 'underline', 'strike'],
                        [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                        [{ 'align': [] }],
                        ['link', 'clean']
                    ]
                }
            });
        });

        // --- TOM SELECT (WITH EXPLICIT CLASSES) ---
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
                            <img class="companion-avatar" src="\${escape(data.src)}">
                            <span>\${escape(data.text)}</span>
                        </div>`;
                    }
                }
            });
        });

        // --- IMAGE HANDLING ---
        const dropZone = document.getElementById('dropZone');
        const fileInput = document.getElementById('fileInput');
        const previewContainer = document.getElementById('previewContainer');
        let selectedFiles = [];

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
                Swal.fire('Lỗi', 'Tối đa 5 ảnh!', 'warning');
                return;
            }
            fileList.forEach(file => {
                if (!file.type.startsWith('image/')) return;
                selectedFiles.push(file);
            });
            renderPreviews();
        }

        function renderPreviews() {
            const dynamicPreviews = previewContainer.querySelectorAll('.preview-item:not(.old-image)');
            dynamicPreviews.forEach(el => el.remove());

            selectedFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const div = document.createElement('div');
                    div.className = 'preview-item shadow-sm';
                    div.innerHTML = `<img src="\${e.target.result}"><button type="button" class="remove-btn" onclick="removeSelectedFile(\${index})">&times;</button>`;
                    previewContainer.appendChild(div);
                };
                reader.readAsDataURL(file);
            });
        }

        window.removeSelectedFile = function(index) {
            selectedFiles.splice(index, 1);
            renderPreviews();
        };

        // --- AJAX FORM SUBMISSION ---
        document.getElementById('campaignForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            document.getElementById('content-hidden').value = quill.root.innerHTML;
            
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> ĐANG LƯU...';

            const formData = new FormData(this);
            formData.delete('imageFiles');
            selectedFiles.forEach(file => formData.append('imageFiles', file));

            try {
                const response = await fetch(this.action, { method: 'POST', body: formData });
                const result = await response.json();
                if (response.ok) {
                    await Swal.fire({ icon: 'success', title: 'Thành công!', text: result.message, timer: 1500, showConfirmButton: false });
                    window.location.href = '${pageContext.request.contextPath}/admin/campaigns';
                } else {
                    let errorMsg = "";
                    for (const key in result) errorMsg += `\${result[key]}<br>`;
                    Swal.fire({ icon: 'error', title: 'Lỗi!', html: errorMsg });
                }
            } catch (error) {
                Swal.fire('Lỗi!', 'Có lỗi xảy ra!', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = originalText;
            }
        });
    </script>
</body>
</html>
