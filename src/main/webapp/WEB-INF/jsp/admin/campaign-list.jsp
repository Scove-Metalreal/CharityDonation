<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <!-- Quill.js CSS -->
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <style>
        :root { --primary-color: var(--color-primary); --bg-light: #f8fafc; }
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .bg-brand-primary { background-color: var(--color-primary) !important; }
        .action-btn { width: 34px; height: 34px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; border: none; transition: 0.2s; }
        
        /* Quill Editor Customization */
        .ql-container { border-bottom-left-radius: 1rem; border-bottom-right-radius: 1rem; background: white; min-height: 200px; font-size: 1rem; }
        .ql-toolbar { border-top-left-radius: 1rem; border-top-right-radius: 1rem; background: #f8fafc; border-color: #dee2e6 !important; }
        .ql-container.ql-snow { border-color: #dee2e6 !important; }
        
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
                                    <option value="${STATUS.CAMPAIGN_NEW}" ${status == STATUS.CAMPAIGN_NEW ? 'selected' : ''}>Mới tạo</option>
                                    <option value="${STATUS.CAMPAIGN_ONGOING}" ${status == STATUS.CAMPAIGN_ONGOING ? 'selected' : ''}>Đang quyên góp</option>
                                    <option value="${STATUS.CAMPAIGN_COMPLETED}" ${status == STATUS.CAMPAIGN_COMPLETED ? 'selected' : ''}>Kết thúc quyên góp</option>
                                    <option value="${STATUS.CAMPAIGN_CLOSED}" ${status == STATUS.CAMPAIGN_CLOSED ? 'selected' : ''}>Đóng quyên góp</option>
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
                                                        ${c.status == STATUS.CAMPAIGN_NEW ? 'bg-info bg-opacity-10 text-info' : 
                                                          (c.status == STATUS.CAMPAIGN_ONGOING ? 'bg-success bg-opacity-10 text-success' : 
                                                          (c.status == STATUS.CAMPAIGN_COMPLETED ? 'bg-warning bg-opacity-10 text-warning' : 'bg-secondary bg-opacity-10 text-secondary'))}"
                                                        onchange="confirmCampaignStatus(${c.id}, this, ${c.status})" ${c.status == STATUS.CAMPAIGN_CLOSED ? 'disabled' : ''}>
                                                    <option value="${STATUS.CAMPAIGN_NEW}" ${c.status == STATUS.CAMPAIGN_NEW ? 'selected' : ''} ${c.status > STATUS.CAMPAIGN_NEW ? 'disabled' : ''}>Mới tạo</option>
                                                    <option value="${STATUS.CAMPAIGN_ONGOING}" ${c.status == STATUS.CAMPAIGN_ONGOING ? 'selected' : ''}>Đang quyên góp</option>
                                                    <option value="${STATUS.CAMPAIGN_COMPLETED}" ${c.status == STATUS.CAMPAIGN_COMPLETED ? 'selected' : ''}>Kết thúc quyên góp</option>
                                                    <option value="${STATUS.CAMPAIGN_CLOSED}" ${c.status == STATUS.CAMPAIGN_CLOSED ? 'selected' : ''}>Đóng quyên góp</option>
                                                </select>
                                            </td>
                                            <td class="text-end">
                                                <div class="d-flex justify-content-end gap-1">
                                                    <a href="${pageContext.request.contextPath}/campaign/${c.id}" class="action-btn bg-info bg-opacity-10 text-info" target="_blank"><i class="far fa-eye"></i></a>
                                                    <a href="${pageContext.request.contextPath}/admin/campaigns/edit?id=${c.id}" class="action-btn bg-brand-primary bg-opacity-10 brand-primary ${c.status == STATUS.CAMPAIGN_CLOSED ? 'disabled' : ''}"><i class="far fa-edit"></i></a>
                                                    <c:if test="${c.status == STATUS.CAMPAIGN_COMPLETED}">
                                                        <button class="action-btn bg-warning bg-opacity-10 text-warning" onclick="openExtendModal(${c.id}, '${c.endDate}')"><i class="fas fa-calendar-plus"></i></button>
                                                    </c:if>
                                                    <c:if test="${c.status == STATUS.CAMPAIGN_NEW}">
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
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="modal-header bg-brand-primary border-0 text-white p-4">
                    <div class="d-flex align-items-center">
                        <div class="bg-brand-primary p-2 rounded-3 me-3">
                            <i class="fas fa-plus-circle fs-4 text-white"></i>
                        </div>
                        <div>
                            <h5 class="modal-title fw-bold mb-0">Tạo chiến dịch mới</h5>
                            <small class="text-white-50">Điền thông tin để bắt đầu một hành trình nhân ái mới</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" onclick="resetCampaignForm()"></button>
                </div>
                <div class="modal-body p-4 bg-light">
                    <form action="${pageContext.request.contextPath}/admin/campaigns/save" method="post" id="addCampaignForm" enctype="multipart/form-data">
                        <div class="row g-4">
                            <!-- Left Column: Basic Info -->
                            <div class="col-lg-8">
                                <div class="card border-0 shadow-sm p-4 rounded-4 h-100">
                                    <h6 class="fw-bold mb-4 text-dark border-bottom pb-2">THÔNG TIN CƠ BẢN</h6>
                                    <div class="row g-3">
                                        <div class="col-md-8">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Tên chiến dịch</label>
                                            <input type="text" name="name" class="form-control rounded-pill px-3 shadow-none border" placeholder="Ví dụ: Áo ấm cho em 2026..." required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Mã định danh</label>
                                            <input type="text" name="code" class="form-control rounded-pill px-3 shadow-none border" placeholder="CMP-2026-01" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày bắt đầu</label>
                                            <input type="date" name="startDate" id="startDate" class="form-control rounded-pill px-3 shadow-none border" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Ngày kết thúc</label>
                                            <input type="date" name="endDate" id="endDate" class="form-control rounded-pill px-3 shadow-none border" required>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Mục tiêu (VNĐ)</label>
                                            <input type="number" name="targetMoney" class="form-control rounded-pill px-3 shadow-none border" placeholder="100,000,000" min="1000000" required>
                                        </div>
                                        <div class="col-12">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">Đối tác đồng hành</label>
                                            <select id="companionSelect" name="companionIds" multiple placeholder="Tìm và chọn đối tác..." autocomplete="off">
                                                <c:forEach var="comp" items="${allCompanions}">
                                                    <option value="${comp.id}" data-src="${comp.logoUrl}">${comp.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-12">
                                            <label class="form-label smallest fw-bold text-muted text-uppercase">SĐT Người thụ hưởng</label>
                                            <div class="input-group">
                                                <span class="input-group-text bg-light border-end-0 rounded-start-pill ps-3"><i class="fas fa-phone-alt text-muted"></i></span>
                                                <input type="text" name="beneficiaryPhone" class="form-control border-start-0 rounded-end-pill pe-3 shadow-none border" placeholder="Số điện thoại nhận tiền quyên góp...">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Right Column: Media & Meta -->
                            <div class="col-lg-4">
                                <div class="card border-0 shadow-sm p-4 rounded-4 h-100">
                                    <h6 class="fw-bold mb-4 text-dark border-bottom pb-2">HÌNH ẢNH (MAX 5)</h6>
                                    <div id="dropZone" class="drop-zone border-dashed rounded-4 p-4 text-center bg-light transition mb-3">
                                        <i class="fas fa-cloud-upload-alt fa-3x brand-primary mb-2"></i>
                                        <div class="fw-bold small">Kéo thả hoặc click</div>
                                        <input type="file" id="fileInput" multiple accept="image/*" class="d-none">
                                    </div>
                                    <div id="previewContainer" class="preview-container d-flex flex-wrap gap-2"></div>
                                    
                                    <div class="mt-4">
                                        <label class="form-label smallest fw-bold text-muted text-uppercase">Mô tả ngắn</label>
                                        <textarea name="background" class="form-control border rounded-4 shadow-none" rows="4" placeholder="Tóm tắt ngắn gọn mục đích chiến dịch..."></textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="col-12">
                                <div class="card border-0 shadow-sm p-4 rounded-4">
                                    <label class="form-label smallest fw-bold text-muted text-uppercase">Nội dung chi tiết</label>
                                    <!-- Quill Editor Container -->
                                    <div id="editor-container"></div>
                                    <!-- Hidden textarea to store HTML for submission -->
                                    <textarea name="content" id="content-hidden" class="d-none"></textarea>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-4 pt-3 border-top text-end">
                            <button type="button" class="btn btn-light rounded-pill px-4 me-2 fw-bold text-muted" data-bs-dismiss="modal" onclick="resetCampaignForm()">Hủy bỏ</button>
                            <button type="submit" class="btn btn-brand-primary rounded-pill px-5 fw-bold shadow" id="submitBtn">XÁC NHẬN TẠO CHIẾN DỊCH</button>
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
    <!-- Quill.js Library -->
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

    <script>
        // --- QUILL EDITOR INITIALIZATION ---
        let quill;
        document.addEventListener('DOMContentLoaded', function() {
            quill = new Quill('#editor-container', {
                theme: 'snow',
                placeholder: 'Nhập nội dung chi tiết chiến dịch tại đây...',
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
            if(quill) quill.setContents([]);
        }

        // --- FORM SUBMISSION ---
        const addCampaignForm = document.getElementById('addCampaignForm');
        addCampaignForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            // Sync Quill content to hidden textarea
            const contentHidden = document.getElementById('content-hidden');
            contentHidden.value = quill.root.innerHTML;
            
            // Check if content is empty (Quill empty state is <p><br></p>)
            if (quill.getText().trim().length === 0) {
                Swal.fire('Lỗi', 'Vui lòng nhập nội dung chi tiết chiến dịch!', 'warning');
                return;
            }

            const sDate = new Date(document.getElementById('startDate').value);
            const eDate = new Date(document.getElementById('endDate').value);
            if (sDate >= eDate) {
                Swal.fire('Lỗi', 'Ngày bắt đầu phải trước ngày kết thúc!', 'warning');
                return;
            }

            const submitBtn = document.getElementById('submitBtn');
            const originalBtnText = submitBtn.innerText;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span> Đang xử lý...';

            const formData = new FormData(this);
            formData.delete('imageFiles');
            selectedFiles.forEach(file => formData.append('imageFiles', file));

            try {
                const response = await fetch(this.action, { method: 'POST', body: formData });
                const result = await response.json();
                
                if (response.ok) {
                    await Swal.fire({ icon: 'success', title: 'Thành công!', text: result.message, timer: 1500, showConfirmButton: false });
                    location.reload();
                } else {
                    let errorMsg = "";
                    for (const key in result) errorMsg += `\${result[key]}<br>`;
                    Swal.fire({ icon: 'error', title: 'Lỗi!', html: errorMsg });
                }
            } catch (error) {
                Swal.fire('Lỗi!', 'Đã có lỗi xảy ra hoặc file quá lớn!', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = originalBtnText;
            }
        });

        // --- HELPER FUNCTIONS (No Magic Numbers) ---
        async function confirmCampaignStatus(id, selectElement, oldStatus) {
            const newStatus = parseInt(selectElement.value);
            const statusNames = {
                [${STATUS.CAMPAIGN_NEW}]: 'Mới tạo',
                [${STATUS.CAMPAIGN_ONGOING}]: 'Đang quyên góp',
                [${STATUS.CAMPAIGN_COMPLETED}]: 'Kết thúc quyên góp',
                [${STATUS.CAMPAIGN_CLOSED}]: 'Đóng quyên góp'
            };
            
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
                confirmButtonColor: '#ef4444',
                confirmButtonText: 'Xóa ngay',
                cancelButtonText: 'Hủy'
            }).then((result) => {
                if (result.isConfirmed) form.submit();
            });
        }

        function openExtendModal(id, oldDate) {
            document.getElementById('extendId').value = id;
            document.getElementById('oldEndDateDisplay').value = oldDate;
            new bootstrap.Modal(document.getElementById('extendModal')).show();
        }

        document.getElementById('extendForm')?.addEventListener('submit', async function(e) {
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

            try {
                const response = await fetch(this.action, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: new URLSearchParams(new FormData(this))
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
