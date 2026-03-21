<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ - CharityDonation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        html { scroll-behavior: smooth; }
        .scrollable-main { height: 100vh; overflow-y: auto; scrollbar-width: none; }
        .scrollable-main::-webkit-scrollbar { display: none; }
        
        /* Section 1: Hero Banner */
        .hero-banner {
            background: linear-gradient(135deg, var(--color-primary) 0%, #065f46 100%);
            border-radius: 24px;
            margin: 20px;
            padding: 60px 40px;
            color: white;
            position: relative;
            overflow: hidden;
        }
        .hero-title { font-size: 2.8rem; line-height: 1.2; z-index: 1; position: relative; }

        /* Section 2: Stats */
        .stat-item { padding: 20px; border-radius: 16px; background: white; border: 1px solid var(--color-border); }
        .stat-value { font-size: 1.5rem; font-weight: 800; color: var(--color-primary); }

        /* Partners */
        .partner-card { background: #f3f4f6; border-radius: 16px; padding: 24px; text-align: center; border: 1px solid transparent; }
        .partner-logo { height: 50px; object-fit: contain; filter: grayscale(1); transition: 0.3s; margin-bottom: 15px; }
        .partner-card:hover .partner-logo { filter: grayscale(0); }

        .feature-icon { width: 50px; height: 50px; border-radius: 50%; background: var(--color-primary); color: white; display: flex; align-items: center; justify-content: center; margin-bottom: 15px; }
    </style>
</head>
<body class="bg-light">
    <div class="container-fluid">
        <div class="row flex-nowrap">
            <!-- Fixed Left Sidebar -->
            <div class="col-auto p-0 border-end" style="z-index: 1000;">
                <c:set var="currentPage" value="home" scope="request"/>
                <jsp:include page="fragments/sidebar.jsp"/>
            </div>

            <!-- Scrollable Main Content -->
            <div class="col scrollable-main p-0 bg-white" style="min-width: 0;">
                
                <!-- 1. Hero Banner Section -->
                <section id="hero" class="hero-banner shadow-lg">
                    <div id="heroCarousel" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <div class="carousel-item active">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h1 class="hero-title fw-bold mb-4">TRIỆU NGƯỜI CHUNG TAY QUYÊN GÓP<br><span class="text-warning">Vì một Việt Nam tốt đẹp hơn!</span></h1>
                                        <p class="lead opacity-75 mb-4">Mỗi đóng góp của bạn, dù nhỏ nhất, cũng góp phần thắp sáng hy vọng cho những hoàn cảnh khó khăn.</p>
                                        <a href="#campaigns" class="btn btn-warning rounded-pill px-5 py-3 fw-bold shadow">QUYÊN GÓP NGAY</a>
                                    </div>
                                    <div class="col-md-4 d-none d-md-block text-center">
                                        <i class="fas fa-heart fa-10x text-white opacity-25"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 2. Intro & Stats Section -->
                <section id="intro" class="py-5 px-4">
                    <div class="row align-items-center g-5">
                        <div class="col-lg-7">
                            <h2 class="fw-bold mb-3 text-primary">Nền tảng quyên góp tin cậy</h2>
                            <p class="text-muted mb-4 fs-5">Chúng tôi kết nối những trái tim nhân ái với những dự án cộng đồng ý nghĩa, đảm bảo sự minh bạch và tác động thực sự.</p>
                            <div class="row g-3 mb-5">
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><div class="stat-value">1+ ngàn</div><div class="text-muted small">dự án</div></div></div>
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><div class="stat-value">106+ tỷ</div><div class="text-muted small">đồng</div></div></div>
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><div class="stat-value">1+ tỷ</div><div class="text-muted small">heo vàng</div></div></div>
                                <div class="col-6 col-md-3"><div class="stat-item text-center"><div class="stat-value">163+ triệu</div><div class="text-muted small">lượt</div></div></div>
                            </div>
                            <div class="d-flex gap-3">
                                <a href="#campaigns" class="btn btn-primary rounded-pill px-4 py-2 fw-bold">Quyên góp</a>
                                <a href="#about" class="btn btn-outline-primary rounded-pill px-4 py-2 fw-bold">Giới thiệu</a>
                            </div>
                        </div>
                        <div class="col-lg-5 text-center">
                            <img src="https://images.unsplash.com/photo-1532629345422-7515f3d16bb6?auto=format&fit=crop&w=500&q=80" class="img-fluid rounded-4 shadow-sm" alt="Stats">
                        </div>
                    </div>
                </section>

                <!-- 3. Donation Campaigns Section -->
                <section id="campaigns" class="py-5 bg-light px-4">
                    <div class="text-center mb-5">
                        <h2 class="fw-bold">Các hoàn cảnh quyên góp</h2>
                        <p class="text-muted">Mọi sự giúp đỡ đều quý giá</p>
                    </div>

                    <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4 mb-5">
                        <c:forEach var="campaign" items="${campaigns}">
                            <div class="col">
                                <c:set var="campaign" value="${campaign}" scope="request"/>
                                <c:set var="isCompact" value="false" scope="request"/>
                                <jsp:include page="fragments/donation-card.jsp"/>
                            </div>
                        </c:forEach>
                    </div>
                </section>

                <!-- 4. Partners Section -->
                <section id="partners" class="py-5 px-4">
                    <div class="text-center mb-5">
                        <h2 class="fw-bold text-primary">Các đối tác đồng hành</h2>
                        <p class="text-muted">Cùng nhau lan tỏa yêu thương</p>
                    </div>
                    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
                        <div class="col"><div class="partner-card"><img src="https://momo.vn/static/momo-upload-api/2021/04/09/momo-logo.png" class="partner-logo" alt="P"><div class="fw-bold small">MoMo</div></div></div>
                        <div class="col"><div class="partner-card"><img src="https://www.unicef.org/themes/custom/unicef_bem/logo.svg" class="partner-logo" alt="P"><div class="fw-bold small">UNICEF</div></div></div>
                        <div class="col"><div class="partner-card"><img src="https://static.vnecdn.net/hoichuthapdo/v1/logo.png" class="partner-logo" alt="P"><div class="fw-bold small">Hội Chữ thập đỏ</div></div></div>
                        <div class="col"><div class="partner-card"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT7A_4vIq1G_Xz-V-P8D8C7S-7T7T7T7T7T7A" class="partner-logo" alt="P"><div class="fw-bold small">VinaCapital</div></div></div>
                    </div>
                </section>

                <!-- 5. Feature Highlights -->
                <section id="highlights" class="py-5 bg-light px-4">
                    <div class="text-center mb-5"><h2 class="fw-bold">Quyên góp đơn giản, minh bạch</h2></div>
                    <div class="row align-items-center g-4">
                        <div class="col-md-4">
                            <div class="text-md-end mb-4">
                                <div class="feature-icon ms-md-auto"><i class="fas fa-shield-alt"></i></div>
                                <h5 class="fw-bold text-primary">Minh bạch 100%</h5>
                                <p class="text-muted small">Mọi giao dịch đều được công khai.</p>
                            </div>
                        </div>
                        <div class="col-md-4 text-center">
                            <img src="https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?auto=format&fit=crop&w=300&q=80" class="img-fluid rounded-5 shadow-lg border" alt="App">
                        </div>
                        <div class="col-md-4">
                            <div class="mb-4">
                                <div class="feature-icon"><i class="fas fa-users"></i></div>
                                <h5 class="fw-bold text-primary">Cộng đồng lớn</h5>
                                <p class="text-muted small">Kết nối hàng triệu nhà hảo tâm.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 6. About -->
                <section id="about" class="py-5 px-4 text-center">
                    <div style="max-width: 800px; margin: 0 auto;">
                        <h2 class="fw-bold mb-4">Khi thiện nguyện là nguồn hạnh phúc</h2>
                        <p class="text-muted lead">Làm việc thiện không chỉ là giúp đỡ người khác, mà còn là cách để chúng ta tìm thấy ý nghĩa trong cuộc sống.</p>
                    </div>
                </section>

                <!-- 7. FAQ -->
                <section id="faq" class="py-5 bg-light px-4">
                    <div class="row g-4">
                        <div class="col-lg-5"><h2 class="fw-bold text-primary mb-4">Câu hỏi thường gặp</h2></div>
                        <div class="col-lg-7">
                            <div class="accordion" id="faqAccordion">
                                <div class="accordion-item">
                                    <h2 class="accordion-header"><button class="accordion-button fw-bold" type="button" data-bs-toggle="collapse" data-bs-target="#faq1">Quyên góp có an toàn không?</button></h2>
                                    <div id="faq1" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion"><div class="accordion-body small text-muted">Hệ thống của chúng tôi sử dụng công nghệ bảo mật đa tầng.</div></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <jsp:include page="fragments/footer.jsp"/>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
