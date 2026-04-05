package org.tnphuong.charity.donation.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.tnphuong.charity.donation.entity.*;
import org.tnphuong.charity.donation.service.*;
import org.tnphuong.charity.donation.dto.*;

import jakarta.validation.Valid;
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
        model.addAttribute("recentDonations", donationService.getRecentDonations(5).stream().map(donationService::convertToDTO).toList());
        
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
        
        model.addAttribute("dashboardDonations", donationService.getDashboardDonations(10).stream().map(donationService::convertToDTO).toList());
        
        java.math.BigDecimal totalAmount = donationService.getTotalDonatedAmount();
        model.addAttribute("totalAmount", totalAmount != null ? totalAmount : java.math.BigDecimal.ZERO);
        
        model.addAttribute("donationStats", donationService.getDonationStatsByStatus());
        model.addAttribute("roleDistribution", userService.getRoleDistribution());
        model.addAttribute("paymentStats", donationService.getDonationStatsByPaymentMethod());
        model.addAttribute("topCampaigns", campaignService.getAllCampaigns(
                PageRequest.of(0, 5, org.springframework.data.domain.Sort.by("currentMoney").descending()))
                .getContent().stream().map(campaignService::convertToDTO).toList());
        
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String listUsers(@RequestParam(required = false) String keyword,
                           @RequestParam(required = false) Integer roleId,
                           @RequestParam(required = false) Integer status,
                           @RequestParam(required = false) String inactive,
                           @RequestParam(defaultValue = "createdAt") String sortBy,
                           @RequestParam(defaultValue = "desc") String direction,
                           @RequestParam(defaultValue = "1") int page, 
                           Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        
        org.springframework.data.domain.Sort sort = direction.equalsIgnoreCase("asc") 
                ? org.springframework.data.domain.Sort.by(sortBy).ascending() 
                : org.springframework.data.domain.Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page - 1, 20, sort);
        
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
        
        model.addAttribute("users", userPage.getContent().stream().map(userService::convertToDTO).toList());
        model.addAttribute("keyword", keyword);
        model.addAttribute("roleId", roleId);
        model.addAttribute("status", status);
        model.addAttribute("inactive", inactive);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("direction", direction);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("roles", roleService.getAllRoles());
        
        return "admin/user-list";
    }

    @GetMapping("/users/detail/{id}")
    public String userDetail(@PathVariable Integer id, Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-users");
        addCommonData(model, session);
        userService.getUserById(id).ifPresent(user -> model.addAttribute("user", userService.convertToDTO(user)));
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
    public ResponseEntity<?> saveUser(@Valid @ModelAttribute("user") User user, BindingResult result) {
        if (result.hasErrors()) {
            return ResponseEntity.badRequest().body(Map.of("error", result.getFieldErrors().get(0).getDefaultMessage()));
        }
        
        try {
            userService.saveUser(user);
            return ResponseEntity.ok().body(Map.of("message", "Lưu người dùng thành công!"));
        } catch (Exception e) {
            logger.error("Error saving user: {}", e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/users/toggle-status")
    @ResponseBody
    public ResponseEntity<?> toggleStatus(@RequestParam Integer userId, jakarta.servlet.http.HttpSession session) {
        Integer currentAdminId = (Integer) session.getAttribute("userId");
        if (userId.equals(currentAdminId)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Bạn không thể tự khóa tài khoản của chính mình!"));
        }
        try {
            User user = userService.getUserById(userId).orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng!"));
            user.setStatus(user.getStatus() == UserStatus.ACTIVE.getValue() ? UserStatus.LOCKED.getValue() : UserStatus.ACTIVE.getValue());
            userService.saveUser(user);
            String statusName = user.getStatus() == UserStatus.ACTIVE.getValue() ? "Mở khóa" : "Khóa";
            return ResponseEntity.ok().body(Map.of("message", statusName + " người dùng thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/users/delete")
    @ResponseBody
    public ResponseEntity<?> deleteUser(@RequestParam Integer userId, jakarta.servlet.http.HttpSession session) {
        Integer currentAdminId = (Integer) session.getAttribute("userId");
        if (userId.equals(currentAdminId)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Bạn không thể tự xóa tài khoản của chính mình!"));
        }
        try {
            userService.deleteUser(userId);
            return ResponseEntity.ok().body(Map.of("message", "Xóa người dùng thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi: " + e.getMessage()));
        }
    }

    @PostMapping("/users/update-role")
    @ResponseBody
    public ResponseEntity<?> updateRole(@RequestParam Integer userId, @RequestParam Integer roleId) {
        Optional<User> userOpt = userService.getUserById(userId);
        Optional<Role> roleOpt = roleService.getRoleById(roleId);
        
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
                                @RequestParam(defaultValue = "createdAt") String sortBy,
                                @RequestParam(defaultValue = "desc") String direction,
                                @RequestParam(defaultValue = "1") int page,
                                Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model, session);

        String searchPhone = (phone != null && !phone.trim().isEmpty()) ? phone.trim() : null;
        String searchCode = (code != null && !code.trim().isEmpty()) ? code.trim() : null;

        org.springframework.data.domain.Sort sort = direction.equalsIgnoreCase("asc")
                ? org.springframework.data.domain.Sort.by(sortBy).ascending()
                : org.springframework.data.domain.Sort.by(sortBy).descending();
        
        Pageable pageable = PageRequest.of(page - 1, 20, sort);
        Page<Campaign> campaignPage = campaignService.searchCampaigns(status, searchPhone, searchCode, pageable);

        model.addAttribute("campaigns", campaignPage.getContent().stream().map(campaignService::convertToDTO).toList());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", campaignPage.getTotalPages());
        model.addAttribute("status", status);
        model.addAttribute("phone", phone);
        model.addAttribute("code", code);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("direction", direction);
        model.addAttribute("allCompanions", companionService.getAllCompanions());

        return "admin/campaign-list";
    }

    @GetMapping("/campaigns/new")
    public String showCampaignForm(Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model, session);
        model.addAttribute("campaign", new Campaign());
        model.addAttribute("allCompanions", companionService.getAllCompanions());
        return "admin/campaign-form";
    }

    @GetMapping("/campaigns/edit")
    public String showEditCampaignForm(@RequestParam Integer id, Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-campaigns");
        addCommonData(model, session);
        campaignService.getCampaignById(id).ifPresent(campaign -> model.addAttribute("campaign", campaign));
        model.addAttribute("allCompanions", companionService.getAllCompanions());
        return "admin/campaign-form";
    }

    @PostMapping("/campaigns/save")
    @ResponseBody
    public ResponseEntity<?> saveCampaign(@Valid @ModelAttribute("campaign") Campaign campaign,
                                         BindingResult result,
                                         @RequestParam(value = "imageFiles", required = false) MultipartFile[] files,
                                         @RequestParam(value = "companionIds", required = false) List<Integer> companionIds) {
        
        if (result.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            result.getFieldErrors().forEach(error -> errors.put(error.getField(), error.getDefaultMessage()));
            return ResponseEntity.badRequest().body(errors);
        }

        if (campaign.getId() != null) {
            Optional<Campaign> existingOpt = campaignService.getCampaignById(campaign.getId());
            if (existingOpt.isPresent()) {
                Campaign existing = existingOpt.get();
                if (files == null || files.length == 0 || files[0].isEmpty()) {
                    campaign.setImageUrl(existing.getImageUrl());
                    campaign.setGalleryUrls(existing.getGalleryUrls());
                }
                campaign.setCreatedAt(existing.getCreatedAt());
            }
        }

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
                logger.error("Image upload failed: {}", e.getMessage());
                return ResponseEntity.internalServerError().body(Map.of("error", "Lỗi upload ảnh"));
            }
        }

        if (companionIds != null && !companionIds.isEmpty()) {
            campaign.setCompanions(companionService.getAllCompanionsByIds(companionIds));
        }

        try {
            campaignService.saveCampaign(campaign);
            return ResponseEntity.ok().body(Map.of("message", "Lưu chiến dịch thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/campaigns/update-status")
    @ResponseBody
    public ResponseEntity<?> updateCampaignStatus(@RequestParam Integer id, @RequestParam Integer status) {
        try {
            campaignService.getCampaignById(id).ifPresent(c -> {
                c.setStatus(status);
                campaignService.saveCampaign(c);
            });
            return ResponseEntity.ok().body(Map.of("message", "Cập nhật trạng thái thành công!"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PostMapping("/campaigns/delete")
    public String deleteCampaign(@RequestParam Integer id) {
        campaignService.deleteCampaign(id);
        return "redirect:/admin/campaigns";
    }

    @GetMapping("/donations")
    public String listDonations(@RequestParam(required = false) String keyword,
                               @RequestParam(required = false) Integer status,
                               @RequestParam(defaultValue = "createdAt") String sortBy,
                               @RequestParam(defaultValue = "desc") String direction,
                               @RequestParam(defaultValue = "1") int page,
                               Model model, jakarta.servlet.http.HttpSession session) {
        model.addAttribute("activePage", "admin-donations");
        addCommonData(model, session);

        org.springframework.data.domain.Sort sort = direction.equalsIgnoreCase("asc") 
                ? org.springframework.data.domain.Sort.by(sortBy).ascending() 
                : org.springframework.data.domain.Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page - 1, 20, sort);
        
        Page<Donation> donationPage = donationService.searchDonations(keyword, status, pageable);

        model.addAttribute("donations", donationPage.getContent().stream().map(donationService::convertToDTO).toList());
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("direction", direction);
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
    public String rejectDonation(@RequestParam Integer donationId, @RequestParam(required = false, defaultValue = "Thông tin không hợp lệ") String reason) {
        donationService.rejectDonation(donationId, reason);
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
