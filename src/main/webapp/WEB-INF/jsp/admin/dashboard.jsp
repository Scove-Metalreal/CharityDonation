<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 640 512'><path fill='%2310B981' d='M256 160a64 64 0 1 1 128 0 64 64 0 1 1 -128 0zM128 352c0-17.7 14.3-32 32-32H480c17.7 0 32 14.3 32 32v48H128V352zm320 128H480c35.3 0 64-28.7 64-64V352c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32v64c0 35.3 28.7 64 64 64H448zM160 80a32 32 0 1 1 64 0 32 32 0 1 1 -64 0zm256 32a32 32 0 1 1 0-64 32 32 0 1 1 0 64z'/></svg>">
    <title>Dashboard - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .brand-primary { color: var(--color-primary) !important; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        .stat-card { border-left: 4px solid var(--color-primary); transition: transform 0.2s; }
        .stat-card:hover { transform: scale(1.02); }
        .chart-container { position: relative; height: 300px; width: 100%; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Sidebar -->
            <div class="col-auto p-0">
                <c:set var="activePage" value="admin-dashboard" scope="request"/>
                <jsp:include page="../fragments/admin-sidebar.jsp"/>
            </div>

            <!-- Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0; min-height: 100vh;">
                <!-- Top Navbar -->
                <jsp:include page="../fragments/admin-header.jsp"/>

                <div class="px-4">
                    <!-- Compact Stats Group -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-3">
                            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary bg-opacity-10 p-3 rounded-3 me-3 text-primary"><i class="fas fa-users fs-4"></i></div>
                                    <div>
                                        <div class="smallest text-muted text-uppercase fw-bold">Người dùng</div>
                                        <h4 class="mb-0 fw-bold">${totalUsers}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                                <div class="d-flex align-items-center">
                                    <div class="bg-success bg-opacity-10 p-3 rounded-3 me-3 text-success"><i class="fas fa-bullhorn fs-4"></i></div>
                                    <div>
                                        <div class="smallest text-muted text-uppercase fw-bold">Đang chạy</div>
                                        <h4 class="mb-0 fw-bold">${activeCampaigns}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                                <div class="d-flex align-items-center">
                                    <div class="bg-info bg-opacity-10 p-3 rounded-3 me-3 text-info"><i class="fas fa-hand-holding-heart fs-4"></i></div>
                                    <div>
                                        <div class="smallest text-muted text-uppercase fw-bold">Tổng quỹ</div>
                                        <h4 class="mb-0 fw-bold"><fmt:formatNumber value="${totalAmount / 1000000}" maxFractionDigits="1"/>M</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card border-0 shadow-sm rounded-4 p-3 bg-white">
                                <div class="d-flex align-items-center">
                                    <div class="bg-warning bg-opacity-10 p-3 rounded-3 me-3 text-warning"><i class="fas fa-clock fs-4"></i></div>
                                    <div>
                                        <div class="smallest text-muted text-uppercase fw-bold">Chờ duyệt</div>
                                        <h4 class="mb-0 fw-bold">${pendingDonations}</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 pb-5">
                        <!-- Refined Transactions List -->
                        <div class="col-lg-7">
                            <div class="card border-0 shadow-sm rounded-4 h-100 bg-white overflow-hidden">
                                <div class="card-header bg-white border-0 py-4 px-4 d-flex justify-content-between align-items-center">
                                    <h5 class="fw-bold mb-0">Hoạt động mới nhất</h5>
                                    <a href="${pageContext.request.contextPath}/admin/donations" class="btn btn-light btn-sm rounded-pill px-3 fw-bold small text-muted">Tất cả</a>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle mb-0">
                                            <thead class="bg-light bg-opacity-50">
                                                <tr class="smallest text-muted text-uppercase">
                                                    <th class="border-0 px-4">Nhà hảo tâm</th>
                                                    <th class="border-0">Số tiền</th>
                                                    <th class="border-0 text-center">Trạng thái</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="d" items="${dashboardDonations}">
                                                    <tr>
                                                        <td class="px-4 py-3">
                                                            <div class="d-flex align-items-center">
                                                                <img src="https://ui-avatars.com/api/?name=${d.donorName}&background=random&color=fff&size=32" class="rounded-circle me-3">
                                                                <div>
                                                                    <div class="fw-bold small text-dark">${d.donorName}</div>
                                                                    <div class="smallest text-muted text-truncate" style="max-width: 150px;">${d.campaignName}</div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="py-3">
                                                            <div class="fw-bold text-dark small"><fmt:formatNumber value="${d.amount}" type="number"/>đ</div>
                                                            <div class="smallest text-muted">
                                                                <fmt:parseDate value="${d.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM HH:mm" />
                                                            </div>
                                                        </td>
                                                        <td class="text-center py-3">
                                                            <c:choose>
                                                                <c:when test="${d.status == STATUS.DONATION_CONFIRMED}"><span class="badge bg-success bg-opacity-10 text-success rounded-pill px-3">Thành công</span></c:when>
                                                                <c:when test="${d.status == STATUS.DONATION_PENDING}"><span class="badge bg-warning bg-opacity-10 text-warning rounded-pill px-3">Chờ duyệt</span></c:when>
                                                                <c:otherwise><span class="badge bg-danger bg-opacity-10 text-danger rounded-pill px-3">Từ chối</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Analytics Section -->
                        <div class="col-lg-5">
                            <div class="card p-4 shadow-sm border-0 rounded-4 h-100">
                                <div class="d-flex justify-content-between align-items-center mb-4">
                                    <h5 class="fw-bold mb-0">Phân tích hệ thống</h5>
                                    <select id="chartSelector" class="form-select form-select-sm rounded-pill w-auto border-0 bg-light px-3 fw-bold">
                                        <option value="donations">Quyên góp</option>
                                        <option value="users">Người dùng</option>
                                        <option value="campaigns">Top Chiến dịch</option>
                                        <option value="payments">Thanh toán</option>
                                    </select>
                                </div>
                                
                                <div class="chart-container">
                                    <canvas id="systemChart"></canvas>
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
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('systemChart').getContext('2d');
            let currentChart = null;

            // Prepare Data from Model
            const chartDataConfig = {
                donations: {
                    type: 'doughnut',
                    labels: ['Chờ duyệt', 'Thành công', 'Từ chối'],
                    values: [${donationStats['0']}, ${donationStats['1']}, ${donationStats['2']}],
                    colors: ['#fbbf24', '#10b981', '#ef4444'],
                    title: 'Trạng thái quyên góp'
                },
                users: {
                    type: 'pie',
                    labels: [<c:forEach var="entry" items="${roleDistribution}">"${entry.key}",</c:forEach>],
                    values: [<c:forEach var="entry" items="${roleDistribution}">${entry.value},</c:forEach>],
                    colors: ['#3b82f6', '#10b981', '#8b5cf6', '#f59e0b'],
                    title: 'Cơ cấu người dùng'
                },
                campaigns: {
                    type: 'bar',
                    labels: [<c:forEach var="c" items="${topCampaigns}">"${c.name}",</c:forEach>],
                    values: [<c:forEach var="c" items="${topCampaigns}">${c.currentMoney},</c:forEach>],
                    colors: ['#10b981', '#10b981', '#10b981', '#10b981', '#10b981'],
                    title: 'Top 5 chiến dịch (VNĐ)'
                },
                payments: {
                    type: 'polarArea',
                    labels: [<c:forEach var="entry" items="${paymentStats}">"${entry.key}",</c:forEach>],
                    values: [<c:forEach var="entry" items="${paymentStats}">${entry.value},</c:forEach>],
                    colors: ['#3b82f6', '#f59e0b', '#ef4444', '#10b981'],
                    title: 'Theo phương thức thanh toán'
                }
            };

            function renderChart(chartKey) {
                if (currentChart) {
                    currentChart.destroy();
                }

                const config = chartDataConfig[chartKey];
                const data = {
                    labels: config.labels,
                    datasets: [{
                        data: config.values,
                        backgroundColor: config.colors,
                        borderWidth: 0,
                        hoverOffset: 15
                    }]
                };

                const options = {
                    responsive: true,
                    maintainAspectRatio: false,
                    animation: {
                        duration: 1000,
                        easing: 'easeOutQuart'
                    },
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                usePointStyle: true,
                                padding: 20,
                                font: { size: 11, weight: '600' }
                            }
                        },
                        title: {
                            display: true,
                            text: config.title,
                            font: { size: 14, weight: '700' },
                            padding: { bottom: 10 }
                        }
                    }
                };

                if (config.type === 'doughnut') {
                    options.cutout = '65%';
                }

                if (config.type === 'bar') {
                    options.plugins.legend.display = false;
                    options.scales = {
                        y: { 
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return (value / 1000000).toFixed(1) + 'M';
                                }
                            }
                        }
                    };
                }

                currentChart = new Chart(ctx, {
                    type: config.type,
                    data: data,
                    options: options
                });
            }

            // Initial render
            renderChart('donations');

            // Handle selector change
            document.getElementById('chartSelector').addEventListener('change', function(e) {
                renderChart(e.target.value);
            });
        });
    </script>
</body>
</html>
