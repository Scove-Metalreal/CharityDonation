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
        if (user.getId() == null) {
            // New user
            String pwd = user.getPassword();
            if (pwd == null || pwd.trim().isEmpty()) {
                String dPwd = (defaultPassword != null) ? defaultPassword.trim() : "123456";
                user.setPassword(PasswordUtils.hashPassword(dPwd));
                logger.info("Using default password for new user: {}", user.getEmail());
            } else if (!pwd.startsWith("$2")) {
                user.setPassword(PasswordUtils.hashPassword(pwd));
            }
            
            if (user.getCreatedAt() == null) {
                user.setCreatedAt(java.time.LocalDateTime.now());
            }
            if (user.getStatus() == null) {
                user.setStatus(UserStatus.ACTIVE.getValue());
            }
            
            // Ensure Role is persistent
            if (user.getRole() != null && user.getRole().getId() != null) {
                roleRepository.findById(user.getRole().getId()).ifPresent(user::setRole);
            } else if (user.getRole() == null) {
                roleRepository.findByRoleName("USER").ifPresent(user::setRole);
            }
            
            logger.info("Creating new user: {}", user.getEmail());
            return userRepository.save(user);
        } else {
            // Update user
            User existingUser = userRepository.findById(user.getId())
                    .orElseThrow(() -> new RuntimeException("User not found"));
            
            // Basic Info
            if (user.getFullName() != null) existingUser.setFullName(user.getFullName());
            if (user.getEmail() != null) existingUser.setEmail(user.getEmail());
            if (user.getPhoneNumber() != null) existingUser.setPhoneNumber(user.getPhoneNumber());
            if (user.getAddress() != null) existingUser.setAddress(user.getAddress());
            if (user.getStatus() != null) existingUser.setStatus(user.getStatus());
            if (user.getRole() != null) existingUser.setRole(user.getRole());
            if (user.getAvatarUrl() != null) existingUser.setAvatarUrl(user.getAvatarUrl());
            if (user.getLastLogin() != null) existingUser.setLastLogin(user.getLastLogin());
            
            // Password logic: Only hash if it's a NEW raw password
            String inputPwd = user.getPassword();
            if (inputPwd != null && !inputPwd.trim().isEmpty()) {
                // If input password is NOT already hashed (doesn't start with $2)
                if (!inputPwd.startsWith("$2")) {
                    existingUser.setPassword(PasswordUtils.hashPassword(inputPwd));
                }
            }
            
            logger.debug("Updating user ID: {}", existingUser.getId());
            return userRepository.save(existingUser);
        }
    }

    @Override
    @Transactional
    public void deleteUser(Integer id) {
        userRepository.findById(id).ifPresent(user -> {
            logger.info("Deleting user: {}", user.getEmail());
            // Clear donations or handle money subtraction if needed (ideally via a Trigger or a safer Service orchestration)
            // For now, delete directly to break cycle
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
        
        if (dto.getTotalDonatedAmount().compareTo(java.math.BigDecimal.ZERO) == 0) {
            logger.debug("Stats for user {} (ID: {}) are zero. Role: {}", user.getEmail(), user.getId(), dto.getRoleName());
        }
        
        dto.setCreatedAt(user.getCreatedAt());
        dto.setLastLogin(user.getLastLogin());
        return dto;
    }
}
