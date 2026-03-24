package org.tnphuong.charity.donation.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.entity.Campaign;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.service.CampaignService;
import org.tnphuong.charity.donation.service.DonationService;
import org.tnphuong.charity.donation.service.UserService;
import org.tnphuong.charity.donation.dao.CompanionRepository;

import java.nio.file.*;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private org.tnphuong.charity.donation.dao.UserRepository userRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.CampaignRepository campaignRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.DonationRepository donationRepository;

    @Autowired
    private CompanionRepository companionRepository;

    private void addCommonData(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("recentDonations", donationRepository.findTop5ByOrderByCreatedAtDesc());
        
        long pendingCount = donationRepository.countByStatus(0);
        Boolean notificationsRead = (Boolean) session.getAttribute("notificationsRead");
        
        if (notificationsRead != null && notificationsRead) {
            model.addAttribute("notificationCount", 0);
        } else {
            model.addAttribute("notificationCount", pendingCount);
        }
    }

    @GetMapping("/mark-notifications-read")
    @ResponseBody
    public ResponseEntity<?> markNotificationsRead(jakarta.servlet.http.HttpSession session) {
        session.setAttribute("notificationsRead", true);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-dashboard");
        addCommonData(model, session);
        
        model.addAttribute("totalUsers", userRepository.count());
        model.addAttribute("activeCampaigns", campaignRepository.countByStatus(1));
        model.addAttribute("pendingDonations", donationRepository.countByStatus(0));
        
        // Fetch 10 for dashboard table
        model.addAttribute("dashboardDonations", donationRepository.findTop10ByOrderByCreatedAtDesc());
        
        java.math.BigDecimal totalAmount = donationRepository.sumTotalDonations();
        model.addAttribute("totalAmount", totalAmount != null ? totalAmount : java.math.BigDecimal.ZERO);
        
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String listUsers(@RequestParam(required = false) String keyword,
                           @RequestParam(required = false) Integer roleId,
                           @RequestParam(required = false) Integer status,
                           @RequestParam(required = false) String inactive,
                           @RequestParam(defaultValue = "1") int page, 
                           Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        
        int pageSize = 20; 
        Pageable pageable = PageRequest.of(page - 1, pageSize);
        
        java.time.LocalDateTime inactiveSince = null;
        if (inactive != null && !inactive.isEmpty()) {
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            switch (inactive) {
                case "1w": inactiveSince = now.minusWeeks(1); break;
                case "1m": inactiveSince = now.minusMonths(1); break;
                case "1q": inactiveSince = now.minusMonths(3); break;
                case "1y": inactiveSince = now.minusYears(1); break;
            }
        }

        String trimmedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        Page<User> userPage = userService.searchUsers(trimmedKeyword, roleId, status, inactiveSince, pageable);
        
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleId", roleId);
        model.addAttribute("status", status);
        model.addAttribute("inactive", inactive);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("roles", roleRepository.findAll());
        
        return "admin/user-list";
    }

    @GetMapping("/users/detail/{id}")
    public String userDetail(@PathVariable Integer id, Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        userRepository.findById(id).ifPresent(user -> model.addAttribute("user", user));
        return "admin/user-detail";
    }

    @GetMapping("/users/add")
    public String showAddUserForm(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        model.addAttribute("user", new User());
        model.addAttribute("roles", roleRepository.findAll());
        return "admin/user-form";
    }

    @PostMapping("/users/save")
    @ResponseBody
    public ResponseEntity<?> saveUser(@ModelAttribute("user") User user) {
        Map<String, String> errors = new HashMap<>();
        if (user.getId() == null) {
            if (userService.getUserByEmail(user.getEmail()).isPresent()) {
                errors.put("email", "Email đã tồn tại!");
            }
            if (user.getPhoneNumber() != null && !user.getPhoneNumber().isEmpty() 
                && userService.getUserByPhoneNumber(user.getPhoneNumber()).isPresent()) {
                errors.put("phone", "Số điện thoại đã tồn tại!");
            }
        }
        if (!errors.isEmpty()) {
            return ResponseEntity.badRequest().body(errors);
        }
        userService.saveUser(user);
        return ResponseEntity.ok().body(Map.of("message", "Lưu người dùng thành công!"));
    }

    @PostMapping("/users/toggle-status")
    public String toggleStatus(@RequestParam Integer userId) {
        userService.getUserById(userId).ifPresent(user -> {
            user.setStatus(user.getStatus() == 1 ? 0 : 1);
            userService.saveUser(user);
        });
        return "redirect:/admin/users";
    }

    @PostMapping("/users/update-role")
    @ResponseBody
    public ResponseEntity<?> updateRole(@RequestParam Integer userId, @RequestParam Integer roleId) {
        Optional<User> userOpt = userService.getUserById(userId);
        Optional<org.tnphuong.charity.donation.entity.Role> roleOpt = roleRepository.findById(roleId);
        
        if (userOpt.isPresent() && roleOpt.isPresent()) {
            User user = userOpt.get();
            user.setRole(roleOpt.get());
            userService.saveUser(user);
            return ResponseEntity.ok().body(Map.of("message", "Cập nhật vai trò thành công!"));
        }
        return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy người dùng hoặc vai trò!"));
    }

    @GetMapping("/campaigns")
    public String listCampaigns(@RequestParam(required = false) Integer status,
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) String code,
                                @RequestParam(defaultValue = "1") int page,
                                Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model, session);
        
        Pageable pageable = PageRequest.of(page - 1, 20); 
        Page<Campaign> campaignPage = campaignService.searchCampaigns(status, phone, code, pageable);
        
        model.addAttribute("campaigns", campaignPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", campaignPage.getTotalPages());
        model.addAttribute("status", status);
        model.addAttribute("phone", phone);
        model.addAttribute("code", code);
        model.addAttribute("allCompanions", companionRepository.findAll());
        
        return "admin/campaign-list";
    }

    @GetMapping("/campaigns/new")
    public String showCampaignForm(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model, session);
        model.addAttribute("campaign", new Campaign());
        return "admin/campaign-form";
    }

    @GetMapping("/campaigns/edit")
    public String showEditCampaignForm(@RequestParam Integer id, Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model, session);
        campaignService.getCampaignById(id).ifPresent(campaign -> model.addAttribute("campaign", campaign));
        return "admin/campaign-form";
    }

    @PostMapping("/campaigns/save")
    @ResponseBody
    public ResponseEntity<?> saveCampaign(@ModelAttribute("campaign") Campaign campaign,
                                         @RequestParam(value = "imageFiles", required = false) MultipartFile[] files,
                                         @RequestParam(value = "companionIds", required = false) List<Integer> companionIds) {
        Map<String, String> errors = new HashMap<>();
        
        // 1. Uniqueness check
        if (campaign.getId() == null && campaignRepository.existsByCode(campaign.getCode())) {
            errors.put("code", "Mã chiến dịch đã tồn tại!");
        }

        // 2. Strict Date check
        if (campaign.getStartDate() == null) errors.put("startDate", "Vui lòng chọn ngày bắt đầu!");
        if (campaign.getEndDate() == null) errors.put("endDate", "Vui lòng chọn ngày kết thúc!");
        
        if (campaign.getStartDate() != null && campaign.getEndDate() != null) {
            if (!campaign.getStartDate().isBefore(campaign.getEndDate())) {
                errors.put("date", "Ngày bắt đầu phải TRƯỚC ngày kết thúc!");
            }
        }

        // 3. Money check
        if (campaign.getTargetMoney() == null || campaign.getTargetMoney().compareTo(java.math.BigDecimal.valueOf(1000000)) < 0) {
            errors.put("money", "Mục tiêu tối thiểu là 1,000,000 VNĐ!");
        }

        if (!errors.isEmpty()) return ResponseEntity.badRequest().body(errors);

        // 4. Multiple Image Upload (Max 5)
        if (files != null && files.length > 0 && !files[0].isEmpty()) {
            try {
                StringBuilder galleryStr = new StringBuilder();
                Path uploadPath = Paths.get("uploads");
                if (!Files.exists(uploadPath)) Files.createDirectories(uploadPath);

                int count = 0;
                for (MultipartFile file : files) {
                    if (file == null || file.isEmpty()) continue;
                    if (count >= 5) break;

                    String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename().replaceAll("\\s+", "_");
                    Path filePath = uploadPath.resolve(fileName);
                    Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
                    
                    String url = "/uploads/" + fileName;
                    if (count == 0) campaign.setImageUrl(url); 
                    
                    if (galleryStr.length() > 0) galleryStr.append(",");
                    galleryStr.append(url);
                    count++;
                }
                if (galleryStr.length() > 0) campaign.setGalleryUrls(galleryStr.toString());
            } catch (Exception e) {
                return ResponseEntity.internalServerError().body(Map.of("error", "Lỗi upload ảnh: " + e.getMessage()));
            }
        }

        // 5. Handle Companions
        if (companionIds != null && !companionIds.isEmpty()) {
            List<org.tnphuong.charity.donation.entity.Companion> companions = companionRepository.findAllById(companionIds);
            campaign.setCompanions(companions);
        }

        campaignService.saveCampaign(campaign);
        return ResponseEntity.ok().body(Map.of("message", "Lưu chiến dịch thành công!"));
    }

    @PostMapping("/campaigns/update-status")
    @ResponseBody
    public ResponseEntity<?> updateCampaignStatus(@RequestParam Integer id, @RequestParam Integer status) {
        Optional<Campaign> campaignOpt = campaignRepository.findById(id);
        if (campaignOpt.isPresent()) {
            Campaign current = campaignOpt.get();
            
            // Nếu TRONG DB đang là 3 thì chặn
            if (current.getStatus() == 3) {
                return ResponseEntity.badRequest().body(Map.of("error", "Chiến dịch đã đóng, không thể thay đổi trạng thái!"));
            }
            
            // Cập nhật trực tiếp
            campaignRepository.updateStatus(id, status);
            return ResponseEntity.ok().body(Map.of("message", "Cập nhật trạng thái thành công!"));
        }
        return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy chiến dịch!"));
    }

    @PostMapping("/campaigns/delete")
    public String deleteCampaign(@RequestParam Integer id) {
        try {
            campaignService.deleteCampaign(id);
        } catch (Exception e) {}
        return "redirect:/admin/campaigns";
    }

    @GetMapping("/donations")
    public String listDonations(@RequestParam(required = false) String keyword,
                               @RequestParam(required = false) Integer status,
                               @RequestParam(defaultValue = "1") int page,
                               Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-donations");
        addCommonData(model, session);
        
        Pageable pageable = PageRequest.of(page - 1, 20); 
        String trimmedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        Page<Donation> donationPage = donationRepository.searchDonations(trimmedKeyword, status, pageable);
        
        model.addAttribute("donations", donationPage.getContent());
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", donationPage.getTotalPages());
        
        return "admin/donation-list";
    }

    @PostMapping("/donations/confirm")
    public String confirmDonation(@RequestParam Integer donationId) {
        donationService.confirmDonation(donationId);
        return "redirect:/admin/donations";
    }
    
    @PostMapping("/donations/reject")
    public String rejectDonation(@RequestParam Integer donationId) {
        donationService.rejectDonation(donationId);
        return "redirect:/admin/donations";
    }

    @PostMapping("/campaigns/extend")
    public String extendCampaign(@RequestParam Integer id, @RequestParam String newEndDate) {
        campaignService.extendCampaign(id, java.time.LocalDate.parse(newEndDate));
        return "redirect:/admin/campaigns";
    }

    @GetMapping("/settings")
    public String showSettings(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-settings");
        addCommonData(model, session);
        return "admin/settings";
    }
}
