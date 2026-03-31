package org.tnphuong.charity.donation.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.tnphuong.charity.donation.entity.*;
import org.tnphuong.charity.donation.service.*;

import java.nio.file.*;
import java.util.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);

    @Autowired
    private UserService userService;

    @Autowired
    private RoleService roleService;

    @Autowired
    private CampaignService campaignService;

    @Autowired
    private DonationService donationService;

    @Autowired
    private CompanionService companionService;

    private void addCommonData(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("recentDonations", donationService.getRecentDonations(5));
        
        long pendingCount = donationService.countDonationsByStatus(DonationStatus.PENDING.getValue());
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
        
        model.addAttribute("totalUsers", userService.countUsers());
        model.addAttribute("activeCampaigns", campaignService.countCampaignsByStatus(CampaignStatus.IN_PROGRESS.getValue()));
        model.addAttribute("pendingDonations", donationService.countDonationsByStatus(DonationStatus.PENDING.getValue()));
        
        // Fetch 10 for dashboard table
        model.addAttribute("dashboardDonations", donationService.getDashboardDonations(10));
        
        java.math.BigDecimal totalAmount = donationService.getTotalDonatedAmount();
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
        model.addAttribute("roles", roleService.getAllRoles());
        
        return "admin/user-list";
    }

    @GetMapping("/users/detail/{id}")
    public String userDetail(@PathVariable Integer id, Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        userService.getUserById(id).ifPresent(user -> model.addAttribute("user", user));
        return "admin/user-detail";
    }

    @GetMapping("/users/add")
    public String showAddUserForm(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        model.addAttribute("user", new User());
        model.addAttribute("roles", roleService.getAllRoles());
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
            user.setStatus(user.getStatus() == UserStatus.ACTIVE.getValue() ? UserStatus.LOCKED.getValue() : UserStatus.ACTIVE.getValue());
            userService.saveUser(user);
            logger.info("Admin toggled status for user ID {}: now {}", userId, user.getStatus());
        });
        return "redirect:/admin/users";
    }

    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam Integer userId) {
        try {
            userService.deleteUser(userId);
            logger.info("Admin deleted user ID: {}", userId);
        } catch (Exception e) {
            logger.error("Failed to delete user ID {}: {}", userId, e.getMessage());
        }
        return "redirect:/admin/users";
    }

    @PostMapping("/users/update-role")
    @ResponseBody
    public ResponseEntity<?> updateRole(@RequestParam Integer userId, @RequestParam Integer roleId) {
        Optional<User> userOpt = userService.getUserById(userId);
        Optional<org.tnphuong.charity.donation.entity.Role> roleOpt = roleService.getRoleById(roleId);
        
        if (userOpt.isPresent() && roleOpt.isPresent()) {
            User user = userOpt.get();
            user.setRole(roleOpt.get());
            userService.saveUser(user);
            logger.info("Admin updated role for user ID {} to role ID {}", userId, roleId);
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
        model.addAttribute("allCompanions", companionService.getAllCompanions());
        
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
        
        if (campaign.getId() == null && campaignService.existsByCode(campaign.getCode())) {
            errors.put("code", "Mã chiến dịch đã tồn tại!");
        }

        if (campaign.getStartDate() == null) errors.put("startDate", "Vui lòng chọn ngày bắt đầu!");
        if (campaign.getEndDate() == null) errors.put("endDate", "Vui lòng chọn ngày kết thúc!");
        
        if (campaign.getStartDate() != null && campaign.getEndDate() != null) {
            if (!campaign.getStartDate().isBefore(campaign.getEndDate())) {
                errors.put("date", "Ngày bắt đầu phải TRƯỚC ngày kết thúc!");
            }
        }

        if (campaign.getTargetMoney() == null || campaign.getTargetMoney().compareTo(java.math.BigDecimal.valueOf(1000000)) < 0) {
            errors.put("money", "Mục tiêu tối thiểu là 1,000,000 VNĐ!");
        }

        if (!errors.isEmpty()) return ResponseEntity.badRequest().body(errors);

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
                logger.error("Image upload failed for campaign {}: {}", campaign.getCode(), e.getMessage());
                return ResponseEntity.internalServerError().body(Map.of("error", "Lỗi upload ảnh: " + e.getMessage()));
            }
        }

        if (companionIds != null && !companionIds.isEmpty()) {
            List<org.tnphuong.charity.donation.entity.Companion> companions = companionService.getAllCompanionsByIds(companionIds);
            campaign.setCompanions(companions);
        }

        campaignService.saveCampaign(campaign);
        logger.info("Admin saved campaign: {}", campaign.getCode());
        return ResponseEntity.ok().body(Map.of("message", "Lưu chiến dịch thành công!"));
    }

    @PostMapping("/campaigns/update-status")
    @ResponseBody
    public ResponseEntity<?> updateCampaignStatus(@RequestParam Integer id, @RequestParam Integer status) {
        Optional<Campaign> campaignOpt = campaignService.getCampaignById(id);
        if (campaignOpt.isPresent()) {
            Campaign current = campaignOpt.get();
            if (current.getStatus() == CampaignStatus.CLOSED.getValue()) { // 3 = CLOSED
                return ResponseEntity.badRequest().body(Map.of("error", "Chiến dịch đã đóng, không thể thay đổi trạng thái!"));
            }
            current.setStatus(status);
            campaignService.saveCampaign(current);
            logger.info("Admin updated status for campaign ID {} to {}", id, status);
            return ResponseEntity.ok().body(Map.of("message", "Cập nhật trạng thái thành công!"));
        }
        return ResponseEntity.badRequest().body(Map.of("error", "Không tìm thấy chiến dịch!"));
    }

    @PostMapping("/campaigns/delete")
    public String deleteCampaign(@RequestParam Integer id) {
        try {
            campaignService.deleteCampaign(id);
            logger.info("Admin deleted campaign ID: {}", id);
        } catch (Exception e) {
            logger.error("Failed to delete campaign ID {}: {}", id, e.getMessage());
        }
        return "redirect:/admin/campaigns";
    }

    @GetMapping("/donations")
    public String listDonations(@RequestParam(required = false) String keyword,
                               @RequestParam(required = false) Integer status,
                               @RequestParam(defaultValue = "1") int page,
                               Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-donations");
        addCommonData(model, session);
        
        Pageable pageable = PageRequest.of(page - 1, 20, Sort.by("createdAt").descending()); 
        String trimmedKeyword = (keyword != null && !keyword.trim().isEmpty()) ? keyword.trim() : null;
        
        Page<Donation> donationPage = donationService.searchDonations(trimmedKeyword, status, pageable);
        
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
        logger.info("Admin confirmed donation ID: {}", donationId);
        return "redirect:/admin/donations";
    }
    
    @PostMapping("/donations/reject")
    public String rejectDonation(@RequestParam Integer donationId, @RequestParam(required = false, defaultValue = "Thông tin không hợp lệ") String reason) {
        donationService.rejectDonation(donationId, reason);
        logger.info("Admin rejected donation ID: {} for reason: {}", donationId, reason);
        return "redirect:/admin/donations";
    }

    @PostMapping("/campaigns/extend")
    public String extendCampaign(@RequestParam Integer id, @RequestParam String newEndDate) {
        campaignService.extendCampaign(id, java.time.LocalDate.parse(newEndDate));
        logger.info("Admin extended campaign ID: {} to {}", id, newEndDate);
        return "redirect:/admin/campaigns";
    }

    @GetMapping("/settings")
    public String showSettings(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-settings");
        addCommonData(model, session);
        return "admin/settings";
    }
}
