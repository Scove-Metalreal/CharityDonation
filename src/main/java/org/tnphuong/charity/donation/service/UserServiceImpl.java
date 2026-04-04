package org.tnphuong.charity.donation.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tnphuong.charity.donation.dao.UserRepository;
import org.tnphuong.charity.donation.dao.DonationRepository;
import org.tnphuong.charity.donation.dao.RoleRepository;
import org.tnphuong.charity.donation.dto.UserDTO;
import org.tnphuong.charity.donation.entity.User;
import org.tnphuong.charity.donation.entity.Donation;
import org.tnphuong.charity.donation.entity.UserStatus;
import org.tnphuong.charity.donation.entity.DonationStatus;
import org.tnphuong.charity.donation.utils.PasswordUtils;

import java.util.List;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    @Value("${app.default-password:123456}")
    private String defaultPassword;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DonationRepository donationRepository;

    @Autowired
    @org.springframework.context.annotation.Lazy
    private CampaignService campaignService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private org.tnphuong.charity.donation.dao.UserFollowingRepository userFollowingRepository;

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public Page<User> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public Optional<User> getUserById(Integer id) {
        return userRepository.findById(id);
    }

    @Override
    @Transactional
    public User saveUser(User user) {
        String cleanEmail = user.getEmail() != null ? user.getEmail().trim() : null;
        String cleanPhone = user.getPhoneNumber() != null ? user.getPhoneNumber().trim() : null;

        // 1. Kiểm tra trùng Email thủ công TRƯỚC KHI LƯU
        if (cleanEmail != null) {
            Optional<User> uEmail = userRepository.findByEmail(cleanEmail);
            if (uEmail.isPresent() && (user.getId() == null || !uEmail.get().getId().equals(user.getId()))) {
                throw new RuntimeException("Email " + cleanEmail + " đã được sử dụng bởi một tài khoản khác.");
            }
        }

        // 2. Kiểm tra trùng SĐT thủ công
        if (cleanPhone != null && !cleanPhone.isEmpty() && !cleanPhone.startsWith("GUEST_")) {
            Optional<User> uPhone = userRepository.findByPhoneNumber(cleanPhone);
            if (uPhone.isPresent()) {
                User existing = uPhone.get();
                if (user.getId() == null || !existing.getId().equals(user.getId())) {
                    throw new RuntimeException("Số điện thoại " + cleanPhone + " đã được đăng ký cho email " + existing.getEmail() + ". Vui lòng dùng SĐT khác.");
                }
            }
        }

        if (user.getId() == null) {
            String pwd = user.getPassword();
            if (pwd == null || pwd.trim().isEmpty()) {
                user.setPassword(PasswordUtils.hashPassword(defaultPassword.trim()));
            } else if (!pwd.startsWith("$2")) {
                user.setPassword(PasswordUtils.hashPassword(pwd));
            }
            if (user.getCreatedAt() == null) user.setCreatedAt(java.time.LocalDateTime.now());
            if (user.getStatus() == null) user.setStatus(UserStatus.ACTIVE.getValue());
            if (user.getRole() == null) {
                roleRepository.findByRoleName("USER").ifPresent(user::setRole);
            }
            user.setEmail(cleanEmail);
            user.setPhoneNumber(cleanPhone);
            logger.info("Creating new user: {}", user.getEmail());
            return userRepository.saveAndFlush(user);
        } else {
            User existingUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng!"));
            existingUser.setFullName(user.getFullName());
            existingUser.setEmail(cleanEmail);
            existingUser.setPhoneNumber(cleanPhone);
            existingUser.setAddress(user.getAddress());
            existingUser.setStatus(user.getStatus());
            if (user.getRole() != null) existingUser.setRole(user.getRole());
            if (user.getAvatarUrl() != null) existingUser.setAvatarUrl(user.getAvatarUrl());
            if (user.getLastLogin() != null) existingUser.setLastLogin(user.getLastLogin());
            
            String inputPwd = user.getPassword();
            if (inputPwd != null && !inputPwd.trim().isEmpty() && !inputPwd.startsWith("$2")) {
                existingUser.setPassword(PasswordUtils.hashPassword(inputPwd));
            }
            logger.debug("Updating user ID: {}", existingUser.getId());
            return userRepository.saveAndFlush(existingUser);
        }
    }

    @Override
    @Transactional
    public void deleteUser(Integer id) {
        userRepository.findById(id).ifPresent(user -> {
            logger.info("Deleting user: {}", user.getEmail());
            userRepository.deleteById(id);
        });
    }

    @Override
    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public Optional<User> getUserByPhoneNumber(String phoneNumber) {
        return userRepository.findByPhoneNumber(phoneNumber);
    }

    @Override
    public List<User> searchUsers(String keyword) {
        return userRepository.searchUsers(keyword);
    }

    @Override
    public Page<User> searchUsers(String keyword, Integer roleId, Integer status, java.time.LocalDateTime inactiveSince, Pageable pageable) {
        return userRepository.searchUsers(keyword, roleId, status, inactiveSince, pageable);
    }

    @Override
    public long countUsers() {
        return userRepository.count();
    }

    @Override
    public UserDTO convertToDTO(User user) {
        if (user == null) return null;
        UserDTO dto = new UserDTO();
        dto.setId(user.getId());
        dto.setFullName(user.getFullName());
        dto.setEmail(user.getEmail());
        dto.setPhoneNumber(user.getPhoneNumber());
        dto.setAddress(user.getAddress());
        dto.setAvatarUrl(user.getAvatarUrl());
        dto.setAuthProvider(user.getAuthProvider());
        dto.setRoleName(user.getRole() != null ? user.getRole().getRoleName() : null);
        dto.setStatus(user.getStatus());
        
        java.math.BigDecimal totalAmount = donationRepository.sumDonationsByUserId(user.getId(), DonationStatus.CONFIRMED.getValue());
        dto.setTotalDonatedAmount(totalAmount != null ? totalAmount : java.math.BigDecimal.ZERO);
        dto.setCampaignCount(donationRepository.countCampaignsByUserId(user.getId(), DonationStatus.CONFIRMED.getValue()));
        dto.setFollowingCount(userFollowingRepository.countByUserId(user.getId()));
        
        dto.setCreatedAt(user.getCreatedAt());
        dto.setLastLogin(user.getLastLogin());
        return dto;
    }
}
